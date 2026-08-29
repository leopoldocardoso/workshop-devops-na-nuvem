#!/usr/bin/env bash
#
# Driver do skill terraform-destroy: para uma ou mais stacks numeradas
# (NN-*-stack*/) deste repo, roda fmt -> init -> validate -> plan -destroy
# -> print do plan -> (opcional) destroy -auto-approve -> atualiza
# docs/deployments/, em sequencia.
#
# Ao contrario do terraform-deploy (que aplica automaticamente), este
# driver NUNCA destroi de verdade sem a flag --auto-approve passada
# explicitamente nesta chamada — por padrao ele so gera e mostra o plano
# de destruicao e para. Isso reflete a regra do projeto (CLAUDE.md): "no
# terraform destroy ... sem confirmacao explicita em sessao, mesmo que o
# ADR mencione". Ver SKILL.md.
#
# Stacks com backend remoto real configurado (backend.hcl presente) sao
# ignoradas por padrao (nunca fmt/init/validate/plan/destroy) — este
# driver so opera automaticamente contra stacks em backend local
# (override.tf). A flag --allow-remote-apply libera o mesmo pipeline
# tambem para stacks com backend.hcl, mas so quando pedida explicitamente
# nesta chamada — nunca e o comportamento padrao.
#
# ATENCAO: com credenciais AWS reais no ambiente e --auto-approve, isto
# DESTROI infraestrutura de verdade, de forma irreversivel. Nao ha
# confirmacao interativa dentro do script alem da propria flag.
#
set -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

DRY_RUN=0
ALLOW_REMOTE_APPLY=0
AUTO_APPROVE=0
STACK_ARGS=()

usage() {
  cat <<'EOF'
Uso: destroy.sh [--dry-run] [--auto-approve] [--allow-remote-apply] [--help] [stack-dir ...]

Para cada stack alvo: terraform fmt, init, validate, plan -destroy (print
do plano). Por padrao PARA AQUI — nunca destroi de verdade. So executa
`terraform destroy -auto-approve` quando a flag --auto-approve e passada
explicitamente nesta chamada. Apos um destroy real, registra o evento em
docs/deployments/<stack>.md.

Stacks com backend remoto real (backend.hcl presente) sao ignoradas por
padrao — nunca fmt/init/validate/plan/destroy contra elas, a menos que
--allow-remote-apply seja passado nesta chamada (ver abaixo).

  (sem argumentos)   Descobre e faz preview de destroy de todas as stacks
                       NN-*-stack*/ na raiz do repo (exceto as de backend
                       remoto, salvo --allow-remote-apply).
  stack-dir ...       Nome/caminho de uma ou mais stacks especificas
                       (ex.: destroy.sh 01-networking-stack-ai). Se a stack
                       nomeada tiver backend remoto, e ignorada a menos que
                       --allow-remote-apply seja passado.
  --dry-run           Mostra o plano de execucao (stacks, backend
                       detectado, comandos) sem chamar terraform/aws.
  --auto-approve      Executa de fato `terraform destroy -auto-approve`
                       apos mostrar o plano de destruicao. Sem esta flag,
                       o driver so gera/mostra o plano e para — nunca
                       destroi. Precisa ser passada explicitamente a cada
                       chamada (nao e persistente); nunca deve ser
                       adicionada por um agente por conta propria — exige
                       autorizacao explicita do operador para aquela
                       chamada especifica, por stack.
  --allow-remote-apply
                       Libera fmt/init/validate/plan(-destroy) tambem para
                       stacks com backend.hcl (backend remoto S3 real) —
                       precisa ser combinada com --auto-approve para
                       destruir de fato; sozinha, so libera o preview do
                       plano de destruicao contra o backend remoto.
                       Precisa ser passada explicitamente a cada chamada;
                       nunca deve ser adicionada por um agente por conta
                       propria "para destravar" um destroy. terraform init
                       injeta automaticamente -backend-config=backend.hcl
                       para essas stacks.
  --help, -h          Mostra esta mensagem e sai.

Codigos de saida:
  0  todas as stacks alvo tiveram o plano de destroy gerado/mostrado (ou
     destruidas de verdade, com --auto-approve), nada a destruir, ou
     foram ignoradas (backend remoto, sem --allow-remote-apply) — nenhuma
     falhou.
  1  alguma stack falhou em fmt/init/validate/plan/destroy.
  2  erro de uso/ambiente (terraform ausente, stack invalida, nenhuma
     stack encontrada).
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --auto-approve) AUTO_APPROVE=1 ;;
    --allow-remote-apply) ALLOW_REMOTE_APPLY=1 ;;
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
  echo "==> --allow-remote-apply: $([[ $ALLOW_REMOTE_APPLY -eq 1 ]] && echo "SIM" || echo "nao")"
  echo "==> --auto-approve: $([[ $AUTO_APPROVE -eq 1 ]] && echo "SIM (destroi de verdade)" || echo "nao (so mostra o plano de destroy)")"
  echo "==> Stacks alvo (${#STACKS[@]}):"
  for s in "${STACKS[@]}"; do
    name="$(basename "$s")"
    backend_mode="$(detect_backend "$s")"
    if [[ "$backend_mode" == remote-s3 && $ALLOW_REMOTE_APPLY -eq 0 ]]; then
      echo "    - $name  [backend detectado: remote-s3]  -> IGNORADA (backend remoto real, sem --allow-remote-apply)"
      continue
    fi
    if [[ "$backend_mode" == remote-s3 ]]; then
      echo "    - $name  [backend detectado: remote-s3, --allow-remote-apply ativo]"
      echo "        1. terraform fmt -recursive"
      echo "        2. terraform init -input=false -backend-config=backend.hcl"
    else
      echo "    - $name  [backend detectado: $backend_mode]"
      echo "        1. terraform fmt -recursive"
      echo "        2. terraform init -input=false"
    fi
    echo "        3. terraform validate"
    echo "        4. terraform plan -destroy -input=false -out=<tmpdir>/$name/tfplan -detailed-exitcode"
    echo "        5. terraform show <plan> (print do plano de destruicao)"
    if [[ $AUTO_APPROVE -eq 1 ]]; then
      echo "        6. terraform destroy -auto-approve <plan>  (DESTROI DE VERDADE, --auto-approve ativo)"
      echo "        7. atualizar docs/deployments/$name.md com o registro de destroy"
    else
      echo "        6. PARA AQUI (sem --auto-approve) — nada e destruido"
    fi
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
    echo "       terraform init/plan/destroy vai expor o erro real adiante." >&2
  fi
fi

RUN_DIR="$(mktemp -d -t terraform-destroy.XXXXXX)"
echo "==> Plan files desta execucao ficarao fora do repo, em: $RUN_DIR"

DOCS_DIR="$REPO_ROOT/docs/deployments"

# Registra um destroy real no topo de docs/deployments/<name>.md, preservando
# o historico de deploy anterior abaixo (nao sobrescreve o arquivo inteiro).
record_destroy() {
  local stack_dir="$1" name="$2" destroy_log="$3"
  local doc_file timestamp tf_version aws_identity resources_after tmp_file

  mkdir -p "$DOCS_DIR"
  doc_file="$DOCS_DIR/$name.md"
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  tf_version="$(cd "$stack_dir" && terraform version | head -1)"
  aws_identity="$(aws sts get-caller-identity --query '[Account,Arn]' --output text 2>/dev/null || echo "indisponivel")"
  resources_after="$(cd "$stack_dir" && terraform state list 2>/dev/null)"

  tmp_file="$(mktemp -t terraform-destroy-doc.XXXXXX)"
  {
    echo "# Deployment: $name — STACK DESTRUIDA"
    echo
    echo "> Registrado automaticamente por \`.claude/skills/terraform-destroy/destroy.sh\`"
    echo "> apos \`terraform destroy -auto-approve\`. Nao editar manualmente."
    echo
    echo "- **Stack:** \`$name\`"
    echo "- **Data do destroy (UTC):** $timestamp"
    echo "- **Terraform:** $tf_version"
    echo "- **Identidade AWS que destruiu:** $aws_identity"
    echo
    echo "## Resultado do destroy"
    echo
    echo '```'
    echo "$destroy_log"
    echo '```'
    echo
    echo "## Recursos remanescentes no state apos o destroy"
    echo
    echo '```'
    if [[ -n "$resources_after" ]]; then
      echo "$resources_after"
    else
      echo "(vazio — nenhum recurso remanescente no state)"
    fi
    echo '```'
    echo
    if [[ -f "$doc_file" ]]; then
      echo "---"
      echo
      echo "## Historico anterior (ultimo deploy antes do destroy)"
      echo
      cat "$doc_file"
    fi
  } > "$tmp_file"

  mv "$tmp_file" "$doc_file"
  echo "==> [$name] Registro de destroy adicionado em: $doc_file"
}

# Codigos de retorno de run_stack: 0=ok (plano mostrado e/ou destruida, ou nada a destruir), 1=falha, 3=ignorada (backend remoto)
run_stack() {
  local stack_dir="$1" name backend_mode plan_file rc
  name="$(basename "$stack_dir")"
  backend_mode="$(detect_backend "$stack_dir")"

  echo "================================================================"
  echo "==> Stack: $name"
  echo "================================================================"

  if [[ "$backend_mode" == remote-s3 && $ALLOW_REMOTE_APPLY -eq 0 ]]; then
    echo "IGNORANDO [$name]: backend.hcl (backend remoto S3) presente."
    echo "  Por padrao este driver nunca faz fmt/init/validate/plan/destroy contra"
    echo "  uma stack com backend remoto real configurado — protege o state de"
    echo "  producao de qualquer automacao sem revisao humana. Rode com"
    echo "  --allow-remote-apply para liberar o preview do plano tambem para ela"
    echo "  (exige autorizacao explicita do operador por chamada). Ver SKILL.md."
    return 3
  fi

  if [[ "$backend_mode" == missing ]]; then
    echo "FALHA [$name]: nem override.tf nem backend.hcl encontrados." >&2
    echo "  Crie um override.tf de backend local, ou um backend.hcl (backend" >&2
    echo "  remoto — requer tambem --allow-remote-apply para ser tocada)." >&2
    return 1
  fi

  local init_extra_args=()
  if [[ "$backend_mode" == remote-s3 ]]; then
    echo "[BACKEND: REMOTE-S3/backend.hcl] --allow-remote-apply ATIVO."
    init_extra_args=(-backend-config=backend.hcl)
  else
    echo "[BACKEND: LOCAL/override.tf] state descartavel."
  fi

  ( cd "$stack_dir" && terraform fmt -recursive )
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform fmt." >&2
    return 1
  fi

  ( cd "$stack_dir" && terraform init -input=false "${init_extra_args[@]}" )
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

  ( cd "$stack_dir" && terraform plan -destroy -input=false -out="$plan_file" -detailed-exitcode )
  rc=$?
  case $rc in
    0)
      echo "==> [$name] Plan -destroy: nada a destruir (state ja vazio ou sem drift). Nada a fazer."
      return 0
      ;;
    2)
      echo "==> [$name] Plano de destruicao gerado com recursos a remover."
      ;;
    *)
      echo "FALHA [$name]: terraform plan -destroy retornou erro (rc=$rc)." >&2
      return 1
      ;;
  esac

  echo "----------------------------------------------------------------"
  echo "==> [$name] Plano de destruicao (o que sera REMOVIDO):"
  ( cd "$stack_dir" && terraform show -no-color "$plan_file" )
  echo "----------------------------------------------------------------"

  if [[ $AUTO_APPROVE -eq 0 ]]; then
    echo "==> [$name] PARANDO AQUI: --auto-approve nao foi passado."
    echo "    Nada foi destruido. Revise o plano acima; se estiver correto e"
    echo "    autorizado pelo operador, rode novamente com --auto-approve"
    echo "    (e --allow-remote-apply, se backend remoto) para esta stack."
    return 0
  fi

  echo "==> [$name] --auto-approve ativo: destruindo de verdade, sem pausa manual..."
  local destroy_log="$RUN_DIR/$name/destroy.log"
  ( cd "$stack_dir" && terraform destroy -auto-approve -no-color ) | tee "$destroy_log"
  rc=${PIPESTATUS[0]}
  if [[ $rc -ne 0 ]]; then
    echo "FALHA [$name]: terraform destroy retornou erro (rc=$rc)." >&2
    return 1
  fi
  echo "==> [$name] Destroy concluido com sucesso."

  record_destroy "$stack_dir" "$name" "$(cat "$destroy_log")"
  return 0
}

ok=0
ignored=0
failed=0
for s in "${STACKS[@]}"; do
  run_stack "$s"
  case $? in
    0) ok=$((ok + 1)) ;;
    3) ignored=$((ignored + 1)) ;;
    *) failed=$((failed + 1)) ;;
  esac
done

echo "================================================================"
echo "Resumo: ${#STACKS[@]} stack(s) alvo — $ok processada(s) (plano mostrado e/ou destruida/nada-a-destruir), $ignored ignorada(s) (backend remoto), $failed com falha."

if [[ $failed -gt 0 ]]; then
  exit 1
fi
exit 0
