#!/usr/bin/env bash
#
# Driver do skill terraform-deploy: para uma ou mais stacks numeradas
# (NN-*-stack*/) deste repo, roda fmt -> init -> validate -> plan -> print
# do plan -> apply -auto-approve -> gera documentacao em docs/deployments/,
# em sequencia, sem pausa manual.
#
# Stacks com backend remoto real configurado (backend.hcl presente) sao
# SEMPRE ignoradas (nunca fmt/init/validate/plan/apply) — este driver so
# opera contra stacks em backend local (override.tf). Ver SKILL.md.
#
# ATENCAO: com credenciais AWS reais no ambiente, isto cria/modifica
# infraestrutura de verdade e cobravel. Nao ha confirmacao interativa.
#
set -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

DRY_RUN=0
STACK_ARGS=()

usage() {
  cat <<'EOF'
Uso: deploy.sh [--dry-run] [--help] [stack-dir ...]

Para cada stack alvo: terraform fmt, init, validate, plan (print do plan),
apply -auto-approve, geracao de documentacao em docs/deployments/<stack>.md.
Sem pausa manual entre plan e apply.

Stacks com backend remoto real (backend.hcl presente) sao SEMPRE
ignoradas — nunca fmt/init/validate/plan/apply contra elas.

  (sem argumentos)   Descobre e faz deploy de todas as stacks NN-*-stack*/
                       na raiz do repo (exceto as de backend remoto).
  stack-dir ...       Nome/caminho de uma ou mais stacks especificas
                       (ex.: deploy.sh 01-networking-stack-ai). Se a stack
                       nomeada tiver backend remoto, e ignorada mesmo assim.
  --dry-run           Mostra o plano de execucao (stacks, backend
                       detectado, comandos) sem chamar terraform/aws.
  --help, -h          Mostra esta mensagem e sai.

Codigos de saida:
  0  todas as stacks alvo foram aplicadas, sem mudancas, ou ignoradas
     (backend remoto) — nenhuma falhou.
  1  alguma stack falhou em fmt/init/validate/plan/apply.
  2  erro de uso/ambiente (terraform ausente, stack invalida, nenhuma
     stack encontrada).
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    -*)
      echo "ERRO: flag desconhecida '$arg'." >&2
      usage >&2
      exit 2
      ;;
    *) STACK_ARGS+=("$arg") ;;
  esac
done

discover_stacks() {
  local found=()
  local d
  for d in "$REPO_ROOT"/[0-9][0-9]-*-stack*/; do
    [[ -d "$d" ]] && found+=("${d%/}")
  done
  printf '%s\n' "${found[@]}"
}

resolve_stack_arg() {
  local arg="$1" candidate
  if [[ "$arg" == /* && -d "$arg" ]]; then
    echo "$arg"
    return 0
  fi
  candidate="$REPO_ROOT/$arg"
  if [[ -d "$candidate" ]]; then
    echo "$candidate"
    return 0
  fi
  return 1
}

STACKS=()
if [[ ${#STACK_ARGS[@]} -eq 0 ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && STACKS+=("$line")
  done < <(discover_stacks)
  if [[ ${#STACKS[@]} -eq 0 ]]; then
    echo "ERRO: nenhuma stack encontrada em $REPO_ROOT (padrao esperado: NN-*-stack*/)." >&2
    exit 2
  fi
else
  for arg in "${STACK_ARGS[@]}"; do
    resolved="$(resolve_stack_arg "$arg")" || {
      echo "ERRO: stack '$arg' nao encontrada em $REPO_ROOT." >&2
      exit 2
    }
    base="$(basename "$resolved")"
    if [[ ! "$base" =~ ^[0-9][0-9]-.*-stack.*$ ]]; then
      echo "ERRO: '$arg' nao segue o padrao NN-*-stack*/ (encontrado: '$base')." >&2
      exit 2
    fi
    STACKS+=("$resolved")
  done
fi

detect_backend() {
  local dir="$1"
  if [[ -f "$dir/backend.hcl" ]]; then
    echo "remote-s3"
  elif [[ -f "$dir/override.tf" ]]; then
    echo "local"
  else
    echo "missing"
  fi
}

if [[ $DRY_RUN -eq 1 ]]; then
  echo "==> [--dry-run] Nenhum comando terraform/aws sera executado."
  echo "==> Repo root: $REPO_ROOT"
  echo "==> Stacks alvo (${#STACKS[@]}):"
  for s in "${STACKS[@]}"; do
    name="$(basename "$s")"
    backend_mode="$(detect_backend "$s")"
    if [[ "$backend_mode" == remote-s3 ]]; then
      echo "    - $name  [backend detectado: remote-s3]  -> IGNORADA (backend remoto real, nunca tocada)"
      continue
    fi
    echo "    - $name  [backend detectado: $backend_mode]"
    echo "        1. terraform fmt -recursive"
    echo "        2. terraform init -input=false"
    echo "        3. terraform validate"
    echo "        4. terraform plan -input=false -out=<tmpdir>/$name/tfplan -detailed-exitcode"
    echo "        5. terraform show <plan> (print do plan)"
    echo "        6. terraform apply -auto-approve <plan>  (SEM pausa manual)"
    echo "        7. gerar docs/deployments/$name.md (outputs, recursos, log do apply)"
  done
  exit 0
fi

command -v terraform >/dev/null 2>&1 || {
  echo "ERRO: terraform CLI nao encontrado no PATH." >&2
  exit 2
}
terraform version | head -1

if command -v aws >/dev/null 2>&1; then
  if identity="$(aws sts get-caller-identity --query '[Account,Arn]' --output text 2>&1)"; then
    echo "==> Identidade AWS ativa (conta real): $identity"
  else
    echo "AVISO: nao foi possivel resolver credenciais AWS via 'aws sts get-caller-identity'." >&2
    echo "       terraform init/plan/apply vai expor o erro real adiante." >&2
  fi
fi

RUN_DIR="$(mktemp -d -t terraform-deploy.XXXXXX)"
echo "==> Plan files desta execucao ficarao fora do repo, em: $RUN_DIR"

DOCS_DIR="$REPO_ROOT/docs/deployments"

# Gera/atualiza docs/deployments/<name>.md com o resultado do apply mais
# recente: identidade AWS, log do apply, outputs e recursos no state.
# Roda so apos um apply bem-sucedido (nunca contra stack ignorada/falha).
generate_doc() {
  local stack_dir="$1" name="$2" apply_log="$3"
  local doc_file timestamp tf_version aws_identity outputs_json resources

  mkdir -p "$DOCS_DIR"
  doc_file="$DOCS_DIR/$name.md"
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  tf_version="$(cd "$stack_dir" && terraform version | head -1)"
  aws_identity="$(aws sts get-caller-identity --query '[Account,Arn]' --output text 2>/dev/null || echo "indisponivel")"
  outputs_json="$(cd "$stack_dir" && terraform output -json 2>/dev/null || echo '{}')"
  resources="$(cd "$stack_dir" && terraform state list 2>/dev/null)"

  {
    echo "# Deployment: $name"
    echo
    echo "> Gerado automaticamente por \`.claude/skills/terraform-deploy/deploy.sh\`"
    echo "> apos \`terraform apply -auto-approve\`. Nao editar manualmente —"
    echo "> este arquivo e sobrescrito no proximo deploy desta stack."
    echo
    echo "- **Stack:** \`$name\`"
    echo "- **Data do apply (UTC):** $timestamp"
    echo "- **Terraform:** $tf_version"
    echo "- **Identidade AWS que aplicou:** $aws_identity"
    echo
    echo "## Resultado do apply"
    echo
    echo '```'
    echo "$apply_log"
    echo '```'
    echo
    echo "## Outputs"
    echo
    echo '```json'
    echo "$outputs_json"
    echo '```'
    echo
    echo "## Recursos no state"
    echo
    echo '```'
    echo "$resources"
    echo '```'
  } > "$doc_file"

  echo "==> [$name] Documentacao gerada em: $doc_file"
}

# Codigos de retorno de run_stack: 0=aplicada/sem-mudancas, 1=falha, 3=ignorada (backend remoto)
run_stack() {
  local stack_dir="$1" name backend_mode plan_file rc
  name="$(basename "$stack_dir")"
  backend_mode="$(detect_backend "$stack_dir")"

  echo "================================================================"
  echo "==> Stack: $name"
  echo "================================================================"

  if [[ "$backend_mode" == remote-s3 ]]; then
    echo "IGNORANDO [$name]: backend.hcl (backend remoto S3) presente."
    echo "  Este driver nunca faz fmt/init/validate/plan/apply contra uma stack"
    echo "  com backend remoto real configurado — protege o state de producao"
    echo "  de qualquer automacao sem revisao humana. Ver SKILL.md."
    return 3
  fi

  if [[ "$backend_mode" == missing ]]; then
    echo "FALHA [$name]: nem override.tf nem backend.hcl encontrados." >&2
    echo "  Crie um override.tf de backend local para deploy automatizado," >&2
    echo "  ou um backend.hcl (backend remoto — ai esta stack passa a ser" >&2
    echo "  ignorada por este driver, nao mais aplicada por ele)." >&2
    return 1
  fi

  echo "[BACKEND: LOCAL/override.tf] state descartavel."

  ( cd "$stack_dir" && terraform fmt -recursive )
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform fmt." >&2
    return 1
  fi

  ( cd "$stack_dir" && terraform init -input=false )
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform init." >&2
    return 1
  fi

  ( cd "$stack_dir" && terraform validate )
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform validate." >&2
    return 1
  fi

  mkdir -p "$RUN_DIR/$name"
  plan_file="$RUN_DIR/$name/tfplan"

  ( cd "$stack_dir" && terraform plan -input=false -out="$plan_file" -detailed-exitcode )
  rc=$?
  case $rc in
    0)
      echo "==> [$name] Plan: sem mudancas (No changes). Apply pulado (nada a fazer)."
      return 0
      ;;
    2)
      echo "==> [$name] Plan gerado com mudancas pendentes."
      ;;
    *)
      echo "FALHA [$name]: terraform plan retornou erro (rc=$rc)." >&2
      return 1
      ;;
  esac

  echo "----------------------------------------------------------------"
  echo "==> [$name] Plan:"
  ( cd "$stack_dir" && terraform show -no-color "$plan_file" )
  echo "----------------------------------------------------------------"

  echo "==> [$name] Aplicando (auto-approve, sem pausa manual)..."
  local apply_log="$RUN_DIR/$name/apply.log"
  ( cd "$stack_dir" && terraform apply -auto-approve -no-color "$plan_file" ) | tee "$apply_log"
  rc=${PIPESTATUS[0]}
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform apply retornou erro (rc=$rc)." >&2
    return 1
  fi
  echo "==> [$name] Apply concluido com sucesso."

  generate_doc "$stack_dir" "$name" "$(cat "$apply_log")"
  return 0
}

applied=0
ignored=0
failed=0
for s in "${STACKS[@]}"; do
  run_stack "$s"
  case $? in
    0) applied=$((applied + 1)) ;;
    3) ignored=$((ignored + 1)) ;;
    *) failed=$((failed + 1)) ;;
  esac
done

echo "================================================================"
echo "Resumo: ${#STACKS[@]} stack(s) alvo — $applied aplicada(s)/sem-mudanca, $ignored ignorada(s) (backend remoto), $failed com falha."

if [[ $failed -gt 0 ]]; then
  exit 1
fi
exit 0
