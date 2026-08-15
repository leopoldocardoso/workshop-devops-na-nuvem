---
name: terraform-deploy
description: >
  Roda o pipeline completo (fmt, init, validate, plan, apply -auto-approve)
  para uma ou todas as stacks numeradas (NN-*-stack*/) deste repo com
  backend local, e gera documentação do que foi implantado em
  docs/deployments/<stack>.md. Use quando pedirem para deployar, aplicar,
  ou rodar uma stack (e.g. "deploy 01-networking-stack-ai", "aplica todas
  as stacks"). Aplica automaticamente, sem pausa manual, contra qualquer
  stack com backend local (override.tf) — inclusive em prd. Stacks com
  backend remoto real (backend.hcl) continuam SEMPRE ignoradas por este
  driver, em qualquer circunstância.
---

# terraform-deploy

Este projeto não é um app com GUI/CLI/servidor — é infraestrutura como
código. "Rodar" aqui significa validar a configuração, aplicar contra a
stack Terraform e documentar o resultado. O driver programático é
`.claude/skills/terraform-deploy/deploy.sh` (caminhos abaixo são
relativos à raiz do repo).

## O que este skill faz

Para cada stack alvo com backend local (`override.tf` presente):
`terraform fmt -check` → `init` → `validate` → `plan` → `apply
-auto-approve` → gera `docs/deployments/<stack>.md` com o resultado.
**Sem pausa manual entre plan e apply.** Stacks com backend remoto real
(`backend.hcl` presente) são sempre ignoradas — nunca sofrem
fmt/init/validate/plan/apply por este driver, em nenhuma circunstância
(ver Gotchas).

## Como rodar

```bash
# 1) sanity-check sem tocar terraform/aws (sempre seguro, sem autorização extra)
.claude/skills/terraform-deploy/deploy.sh --dry-run

# 2) execução real (fmt/init/validate/plan/apply/docs) — credenciais AWS reais,
#    cria/modifica infraestrutura de verdade e cobrável, sem confirmação interativa
.claude/skills/terraform-deploy/deploy.sh                        # todas as stacks
.claude/skills/terraform-deploy/deploy.sh 01-networking-stack-ai  # uma stack específica
```

Saída, por stack: um banner `[BACKEND: LOCAL/override.tf]`, o resultado
de cada etapa, o print do plan, o log do apply, e por fim o caminho do
arquivo de documentação gerado em `docs/deployments/`.

Códigos de saída: `0` = todas as stacks alvo aplicadas, sem mudanças, ou
ignoradas (backend remoto) — nenhuma falhou; `1` = alguma stack falhou em
fmt/init/validate/plan/apply; `2` = erro de uso (terraform ausente, stack
inexistente/fora do padrão `NN-*-stack*/`, nenhuma stack encontrada).

## Documentação gerada

Após um `apply` bem-sucedido com mudanças, o driver escreve/sobrescreve
`docs/deployments/<stack>.md` com:

- Timestamp (UTC) e identidade AWS (conta/ARN) que executou o apply.
- Versão do Terraform usada.
- Log completo do `terraform apply` (o que foi criado/alterado/destruído).
- `terraform output -json` da stack.
- `terraform state list` (inventário de recursos após o apply).

O arquivo é **sobrescrito a cada deploy** — reflete sempre o estado da
última aplicação, não um histórico acumulado. Se a stack não tiver
mudanças (`plan` sem diffs), o apply é pulado e a documentação existente
não é regenerada.

## Pré-requisitos

- Terraform CLI no PATH (versão mínima definida no `versions.tf` de cada
  stack; `01-networking-stack-ai` exige `>= 1.15.8`).
- Credenciais AWS configuradas no ambiente (`aws sts get-caller-identity`
  deve funcionar) — necessárias a partir do passo `init`/`plan`/`apply`.
- Bucket S3 do backend real já existente, com `versioning`/SSE
  habilitados, se a stack usar `backend.hcl` (fora do escopo deste
  skill e da stack — depende de uma futura `00-bootstrap`; e mesmo
  depois de existir, este driver nunca aplica contra ela — ver Gotchas).

## O que este skill explicitamente NÃO faz

- Não roda nada contra stack com backend remoto real (`backend.hcl`) —
  fmt/init/validate/plan/apply, todos pulados. Essa proteção não foi
  alterada por este ajuste.
- Não cria o bucket S3 do backend.
- Não ordena dependências entre stacks (ex.: uma futura `02-compute`
  consumindo outputs de `01-networking`) nem roda em paralelo.
- Não opera fora de diretórios `NN-*-stack*/` na raiz do repo.
- Não pede confirmação interativa entre plan e apply, para stacks de
  backend local — ver Gotchas para o porquê dessa mudança.

## Gotchas

- **Por que `apply -auto-approve` está ativo (de novo).** Uma versão
  anterior deste `SKILL.md` documentava a remoção deliberada do
  auto-approve, citando um incidente registrado na memória do projeto
  (subagente `devops-engineer` rodou `terraform plan` real sem
  autorização) e o fato de `01-networking-stack-ai` ser hoje ambiente
  único `prd` (sem `dev`/`hml` para absorver erro). O `deploy.sh`,
  porém, já continha `apply -auto-approve` implementado — só a
  documentação estava desatualizada. Em 2026-08-01 o operador confirmou
  explicitamente, ciente desse histórico e do risco em produção, que
  quer o comportamento auto-approve documentado e mantido como
  comportamento oficial do skill. Se esse contexto mudar (ex.: voltar a
  múltiplos ambientes, ou um novo incidente), reavalie esta decisão
  antes de manter o auto-approve.
- **Credenciais reais, conta real.** Este ambiente pode autenticar
  contra uma conta AWS de verdade. `init`/`plan`/`apply` fazem chamadas
  reais à AWS — não são comandos offline. Use `--dry-run` para validar a
  lógica do driver sem nenhuma chamada real.
- **Execução manual vs. via subagente.** Mesmo com auto-approve
  documentado como comportamento oficial, rodar este driver fora de
  `--dry-run`/`--help` deve ter autorização explícita do operador por
  chamada — um agente não deve decidir sozinho invocar isso "só para
  testar algo". Essa é a lição direta do incidente registrado na
  memória do projeto, que continua válida independente do auto-approve
  estar ligado.
- **Backend local hoje, S3 real amanhã.** `01-networking-stack-ai` usa
  hoje um `override.tf` (gitignored) forçando backend `local`, porque o
  bucket S3 real ainda não existe. O driver detecta e rotula isso em
  toda execução. Quando a stack migrar para `backend.hcl` (backend
  remoto real), ela passa automaticamente a ser **ignorada** por este
  driver — apply automático nunca roda contra backend remoto,
  independente desta mudança.
- **Plan files ficam fora do repo; docs ficam dentro.** Os `tfplan`
  binários continuam sendo escritos em `mktemp -d`, fora da árvore do
  repositório (não versionados). Já os arquivos de documentação gerados
  em `docs/deployments/<stack>.md` são versionados normalmente — revise
  o diff antes de commitar, pois contêm outputs e ARNs reais da conta
  AWS aplicada.

## Como foi verificado

`--help` e `--dry-run` (com e sem stack explícita) foram rodados após
este ajuste, confirmando que o passo 7 (geração de documentação) aparece
no plano de execução impresso. A execução real completa
(fmt/init/validate/plan/apply/docs) com credenciais AWS reais **não foi
disparada nesta sessão** — precisa de autorização explícita do operador
por chamada, conforme Gotchas acima, e fica para uma próxima invocação
deliberada do driver.
