---
name: terraform-destroy
description: >
  Roda o pipeline (fmt, init, validate, plan -destroy) para uma ou todas
  as stacks numeradas (NN-*-stack*/) deste repo, mostra o plano de
  destruicao e, POR PADRAO, PARA — so executa `terraform destroy
  -auto-approve` de verdade se a flag --auto-approve for passada
  explicitamente na chamada. Atualiza docs/deployments/<stack>.md com o
  registro do destroy. Use quando pedirem para destruir, desprovisionar,
  desmontar ou dar destroy em uma stack (e.g. "destroi
  01-networking-stack-ai", "mostra o plano de destroy de todas as
  stacks"). Ao contrario do terraform-deploy, nunca destroi
  automaticamente — cada execucao que efetivamente destroi exige
  --auto-approve explicito nessa chamada. Stacks com backend remoto real
  (backend.hcl) sao ignoradas por padrao; --allow-remote-apply libera o
  pipeline para elas (preview ainda depende de --auto-approve para
  destruir de fato).
---

# terraform-destroy

Este projeto não é um app com GUI/CLI/servidor — é infraestrutura como
código. "Destruir" aqui significa remover os recursos reais gerenciados
por uma stack Terraform. O driver programático é
`.claude/skills/terraform-destroy/destroy.sh` (caminhos abaixo são
relativos à raiz do repo).

## O que este skill faz

Para cada stack alvo com backend local (`override.tf` presente):
`terraform fmt -check` → `init` → `validate` → `plan -destroy` → print do
plano de destruição → **para aqui, por padrão**. Só executa `terraform
destroy -auto-approve` se `--auto-approve` for passado explicitamente
nesta chamada — nunca por padrão, mesmo em execução real (fora de
`--dry-run`). Stacks com backend remoto real (`backend.hcl` presente) são
ignoradas por padrão — nunca sofrem nem o preview do plano — a menos que
`--allow-remote-apply` seja passado explicitamente (ver Gotchas).

Este comportamento é o **inverso deliberado** do `terraform-deploy`
(que aplica com `-auto-approve` automaticamente): destroy é destrutivo e
irreversível, e o `CLAUDE.md` deste repo exige confirmação explícita em
sessão para qualquer `terraform destroy`, mesmo que um ADR o mencione.

## Como rodar

```bash
# 1) sanity-check sem tocar terraform/aws (sempre seguro, sem autorização extra)
.claude/skills/terraform-destroy/destroy.sh --dry-run

# 2) preview real do plano de destruição (fmt/init/validate/plan -destroy) —
#    credenciais AWS reais, mas NADA é destruído; para antes do destroy
.claude/skills/terraform-destroy/destroy.sh                        # todas as stacks (backend local)
.claude/skills/terraform-destroy/destroy.sh 01-networking-stack-ai  # uma stack específica

# 3) destroy de verdade — exige autorização explícita do operador para
#    ESTA chamada especificamente, por stack
.claude/skills/terraform-destroy/destroy.sh --auto-approve 01-networking-stack-ai

# 4) idem, mas também contra stack com backend remoto real (backend.hcl) —
#    exige as duas flags explícitas nesta chamada
.claude/skills/terraform-destroy/destroy.sh --allow-remote-apply --auto-approve 01-networking-stack-ai
```

Saída, por stack: um banner `[BACKEND: LOCAL/override.tf]` ou
`[BACKEND: REMOTE-S3/backend.hcl]` (só aparece com `--allow-remote-apply`),
o resultado de cada etapa, o print do plano de destruição e, se
`--auto-approve` estiver ativo, o log do destroy e o caminho do registro
atualizado em `docs/deployments/`.

Códigos de saída: `0` = todas as stacks alvo tiveram o plano
gerado/mostrado (destruídas ou não, conforme `--auto-approve`), nada a
destruir, ou ignoradas (backend remoto, sem `--allow-remote-apply`) —
nenhuma falhou; `1` = alguma stack falhou em
fmt/init/validate/plan/destroy; `2` = erro de uso (terraform ausente,
stack inexistente/fora do padrão `NN-*-stack*/`, nenhuma stack
encontrada).

## Documentação gerada

Após um `destroy` real (com `--auto-approve`), o driver **prepende** um
registro em `docs/deployments/<stack>.md` (não sobrescreve o arquivo
inteiro):

- Timestamp (UTC) e identidade AWS (conta/ARN) que executou o destroy.
- Versão do Terraform usada.
- Log completo do `terraform destroy`.
- `terraform state list` pós-destroy (deve ficar vazio, salvo drift).
- O conteúdo anterior do arquivo (último registro de deploy) é preservado
  abaixo, sob "Histórico anterior", em vez de apagado.

Sem `--auto-approve`, nenhum arquivo de documentação é tocado — só o
plano é mostrado no terminal.

## Pré-requisitos

Os mesmos do `terraform-deploy`: Terraform CLI no PATH, credenciais AWS
configuradas no ambiente, e (para stacks com `backend.hcl`) o bucket S3
do backend real já existente.

## O que este skill explicitamente NÃO faz

- Não destrói nada sem `--auto-approve` explícito nesta chamada — mesmo
  em execução real, o comportamento padrão é só mostrar o plano.
- Não roda nada (nem preview) contra stack com backend remoto real
  (`backend.hcl`) sem `--allow-remote-apply`.
- Não sobrescreve/apaga o histórico de deploy em `docs/deployments/` —
  só prepende o registro de destroy.
- Não ordena dependências entre stacks (ex.: destruir `02-compute` antes
  de `01-networking` da qual depende) nem roda em paralelo.
- Não opera fora de diretórios `NN-*-stack*/` na raiz do repo.

## Gotchas

- **Por que o default é o oposto do `terraform-deploy`.** O
  `terraform-deploy` aplica com `-auto-approve` automaticamente por
  decisão explícita do operador (2026-08-01, documentada no próprio
  skill). Destroy é uma classe de risco diferente — irreversível, remove
  recursos de produção — e o `CLAUDE.md` deste repo lista
  explicitamente "no `terraform destroy` ... sem confirmação explícita em
  sessão, mesmo que o ADR mencione" como guardrail do `devops-engineer`.
  Este skill aplica a mesma régua: preview sempre livre, destroy real
  sempre atrás de uma flag explícita por chamada.
- **`--auto-approve` não é persistente e não deve ser adicionada por um
  agente por conta própria** "para destravar" um destroy — exige
  autorização explícita do operador para aquela chamada específica, por
  stack. Isso vale mesmo se um ADR ou uma tarefa anterior já mencionou
  destruir a stack.
- **Credenciais reais, conta real.** Mesmo em modo preview (sem
  `--auto-approve`), `init`/`plan -destroy` fazem chamadas reais à AWS
  (embora não destrutivas). Use `--dry-run` para validar a lógica do
  driver sem nenhuma chamada real.
- **Backend local ou S3 real — `--allow-remote-apply` decide.** Igual ao
  `terraform-deploy`: por padrão, qualquer stack com `backend.hcl`
  continua ignorada por este driver, inclusive para preview. A flag
  precisa ser passada explicitamente nesta chamada; combiná-la com
  `--auto-approve` destrói de fato o backend remoto — dupla
  confirmação deliberada para o caso de maior risco (produção).
- **Plan files ficam fora do repo; docs ficam dentro.** Os `tfplan`
  binários são escritos em `mktemp -d`, fora da árvore do repositório.
  O registro em `docs/deployments/<stack>.md` é versionado normalmente —
  revise o diff antes de commitar.

## Como foi verificado

`--help` e `--dry-run` (com e sem `--auto-approve`/`--allow-remote-apply`)
devem ser rodados após qualquer alteração neste driver para confirmar que
o comportamento padrão continua sendo "mostrar o plano e parar". A
execução real de `--auto-approve` (destroy de verdade) não foi disparada
na criação deste skill — precisa de autorização explícita do operador por
chamada, conforme Gotchas acima.
