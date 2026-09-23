# 05-argocd-stack-ai — ArgoCD e a Application GitOps do repositório

Stack que instala o **ArgoCD** no cluster `prd-eks-us-east-1` (criado por `02-eks-stack-ai`) e declara **uma** `Application` apontando para `dvn-workshop-kubernetes/` deste repositório, fechando o ciclo GitOps: o commit vira deploy, sem `kubectl apply` manual.

- **ADR de referência:** `docs/adr/ADR-0006-argocd-gitops-eks.md` (**Revisão 3**)
- **Ambiente:** `prd` (único; `local.environment` fixo em `locals.tf`)
- **Região:** `us-east-1`
- **Backend:** S3 (`key = 05-argocd-stack-ai/prd/terraform.tfstate`), configuração parcial via `backend.hcl` (gitignored)

> **Esta stack não manuseia nenhum segredo.** O repositório é **público durante o laboratório** e o ArgoCD clona **anonimamente por HTTPS** (ADR-0006 D6/Opção D). Não há deploy key, PAT, GitHub App nem `Secret` de repositório — se algum desses artefatos aparecer no cluster ou no código, houve desvio da decisão.

---

## 1. O que a stack cria

| Objeto | Onde | Observação |
|---|---|---|
| `helm_release.argocd` | namespace `argocd` | **Único** release da stack. Chart `argo-cd` **`10.9.2`** (versão fixada), repositório `https://argoproj.github.io/argo-helm`. |
| Namespace `argocd` | cluster | Criado pelo próprio release (`create_namespace = true`). |
| `Application` `dvn-workshop` | namespace `argocd` | Renderizada via **`extraObjects` do mesmo release** (D2/Opção C) — não existe o chart `argocd-apps` nem um segundo `helm_release`. |

**Nenhum recurso AWS é criado.** O provider `aws` existe apenas para ler o cluster (`data.aws_eks_cluster`) e para carregar `default_tags` caso algum recurso AWS venha a ser adicionado.

Topologia (ADR-0006 D3/Opção A): instalação **não-HA**, réplica única de `application-controller`, `repo-server`, `server` e `redis`; **Dex e Notifications desligados**; `requests`/`limits` explícitos em todos os componentes; Service do `argocd-server` do tipo **`ClusterIP`** (D4/Opção A) — **nenhum** `LoadBalancer`, `NodePort` ou Ingress.

### Divergência conhecida: `applicationSet`

A chave **`applicationSet.enabled` não existe** no chart `argo-cd` `10.9.2` (conferido no `values.yaml` da versão fixada e nos templates: o Deployment do ApplicationSet controller não tem condicional de habilitação). A intenção do ADR (Premissa 13 / D3/A — "economiza pods num cluster de 2 nós") é preservada pelo único mecanismo disponível nessa versão: **`applicationSet.replicas = 0`** quando `argocd.applicationset_enabled = false`. O Deployment existe no cluster, mas **nenhum pod sobe**. Qualquer tratamento diferente é mudança de ADR, não de código.

---

## 2. Pré-requisitos (bloqueantes)

1. **Cluster vivo e alcançável da máquina que roda o Terraform.** O endpoint da API é público **restrito por CIDR** (`public_access_cidrs`, ADR-0003 D2/A): se o seu IP de saída não estiver na lista, `terraform plan`/`apply` e `kubectl` falham **por timeout**. Isso é erro de CIDR, não de chart — a correção é em `02-eks-stack-ai` e **está fora do escopo desta stack** (reportar ao operador).
2. **Repositório GitHub PÚBLICO** (ADR-0006 Premissa 2). Verificação objetiva, sem credencial:

   ```bash
   git ls-remote https://github.com/leopoldocardoso/workshop-devops-na-nuvem.git | head -1
   curl -s -o /dev/null -w '%{http_code}\n' https://api.github.com/repos/leopoldocardoso/workshop-devops-na-nuvem   # 200 = público
   ```

   Se estiver privado, **parar**: a premissa da decisão D6 não se sustenta e a `Application` cairá em `ComparisonError`. Tornar o repositório público é **ação manual do operador**.
3. `00-bootstrap-stack-ai` aplicado (bucket de state) e `backend.hcl` criado a partir de `backend.hcl.example`.
4. `terraform.tfvars` criado a partir de `terraform.tfvars.example`, com `tags.Owner` e `tags.CostCenter` reais.

---

## 3. Deploy

```bash
cd 05-argocd-stack-ai
terraform fmt -check
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -out=tfplan        # revisão de par obrigatória (ambiente prd, sem ambiente inferior)
terraform apply tfplan
```

Ou, pelo driver (a stack tem `backend.hcl`, logo exige o flag explícito e autorização do operador em sessão):

```bash
.claude/skills/terraform-deploy/deploy.sh --allow-remote-apply 05-argocd-stack-ai
```

### Rollout em três etapas (ADR-0006 §13.1, passos 3 e 6)

O ADR exige uma **primeira sync controlada**, para que o ArgoCD **adote** os objetos já aplicados manualmente em `dvn-workshop` sem recriá-los. Isso é feito por `terraform.tfvars`, sem editar código:

| Etapa | `argocd_application.enabled` | `automated_prune` / `automated_self_heal` | O que acontece |
|---|---|---|---|
| 1 | `false` | — | Instala só o ArgoCD. Validar pods e conectividade Git antes de seguir. |
| 2 | `true` | `false` / `false` | Cria a `Application`. O diff contra o cluster fica visível na UI; **nada é sincronizado sozinho**. |
| 3 | `true` | `true` / `true` | Estado final: `automated` + `prune` + `selfHeal` (D5/Opção A). |

> Cada etapa é um `terraform apply`. Como a `Application` vive dentro do release (D2/C), mudá-la **faz upgrade do release inteiro** e pode reiniciar componentes do ArgoCD — consequência aceita no ADR (§11).

**Após o apply, antes de commitar:** conferir `docs/deployments/05-argocd-stack-ai.md` gerado pelo driver linha a linha (o repositório está público; o driver despeja `terraform output -json`, `terraform state list` e a identidade AWS). Se aparecer qualquer valor sensível, **não commitar** e reportar ao operador.

---

## 4. Pós-instalação

```bash
# Senha inicial do admin (gerada pelo chart)
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo

# UI: túnel pelo endpoint público restrito da API — nenhuma porta nova é exposta
kubectl port-forward -n argocd svc/argocd-server 8080:443
# https://localhost:8080  (usuário: admin)
```

**Trocar a senha do `admin` e remover o Secret inicial** (ADR-0006 §13.1 passo 8):

```bash
argocd login localhost:8080 --username admin --insecure
argocd account update-password
kubectl -n argocd delete secret argocd-initial-admin-secret
```

Validações rápidas:

```bash
kubectl get pods -n argocd                       # todos Running/Ready, nenhum Pending
kubectl get svc -n argocd                        # nenhum LoadBalancer/NodePort
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=repository   # DEVE vir vazio
kubectl get application dvn-workshop -n argocd -o jsonpath='{.status.sync.status} {.status.health.status}{"\n"}'
helm list -n argocd                              # exatamente 1 release: argocd
kubectl top nodes
```

---

## 5. Operação no dia a dia

- **Latência de sync:** o ArgoCD detecta mudanças por **polling (~3 min)**. Não há webhook do GitHub — o `argocd-server` não tem URL pública (ADR-0006 Premissa 3). "Pipeline travada" por 3 minutos é comportamento esperado.
- **Nunca corrija incidente com `kubectl edit`/`kubectl apply`:** com `selfHeal` ligado, a alteração é revertida. O caminho é **commitar no Git** (ou desabilitar `automated` temporariamente na `Application`).
- **Promoção de versão de imagem:** feita pelo CI (ADR-0007/0008), que altera `newTag` + `app.kubernetes.io/version` em `dvn-workshop-kubernetes/<app>/kustomization.yaml`. Esta stack não toca nesses arquivos.

---

## 6. Rollback

1. **Versão de aplicação (caminho normal):** `git revert` do commit de promoção → ArgoCD volta à tag anterior em ~3 min. Exige que a tag anterior ainda exista no ECR (janela de **10 tags**, ADR-0004).
2. **Rollback imediato:** `argocd app rollback dvn-workshop <revision>` — **desabilite `automated` antes**, senão o `selfHeal` reverte o rollback.
3. **Release do ArgoCD ruim (bump de chart ou mudança de `Application` malsucedida):** `terraform apply` com os valores anteriores em `terraform.tfvars`, ou `helm rollback argocd <revision> -n argocd` como medida emergencial (reconciliando o state depois).
4. **Desinstalação completa:** `terraform destroy` **exige autorização explícita do operador em sessão**:

   ```bash
   .claude/skills/terraform-destroy/destroy.sh --allow-remote-apply 05-argocd-stack-ai            # só o plano
   .claude/skills/terraform-destroy/destroy.sh --allow-remote-apply --auto-approve 05-argocd-stack-ai
   ```

   **Antes de destruir:** a `Application` é criada **sem** o finalizer `resources-finalizer.argocd.argoproj.io` justamente para que sua remoção **não cascateie** deleção dos workloads de `dvn-workshop`. Confirme isso (`kubectl get application dvn-workshop -n argocd -o jsonpath='{.metadata.finalizers}'` deve vir vazio) e, na dúvida, desabilite `automated` antes. Os **CRDs do ArgoCD permanecem** no cluster após o destroy (`crds.keep = true`, default do chart).
5. **Volta ao modo manual:** com o ArgoCD removido, `kubectl apply -k dvn-workshop-kubernetes/` continua válido; os workloads seguem rodando durante todo o processo.

---

## 7. Diagnóstico

| Sintoma | Causa provável | Ação |
|---|---|---|
| `Application` em **`ComparisonError`** / `Unknown`, log do `argocd-repo-server` com erro de autenticação no `git fetch` | **O repositório deixou de ser público.** É a premissa quebrada (ADR-0006 Premissa 2), não um defeito de configuração. | Reabrir a **decisão D6 na Opção A** (deploy key SSH read-only) — é **mudança de ADR**, não ajuste de configuração. Enquanto isso, as aplicações em execução continuam servindo; apenas novos deploys congelam. |
| `terraform plan`/`apply` ou `kubectl` com timeout na API do cluster | IP de saída fora de `public_access_cidrs` (mudança de rede/ISP) | Corrigir `endpoint_public_access_cidrs` em `02-eks-stack-ai` — **fora do escopo desta stack**; reportar ao operador. |
| Pods do ArgoCD ou de aplicação em `Pending` | Capacidade dos 2× `t3.medium` esgotada | `kubectl describe node`; escalar o node group para 3 nós é alteração em `02-` — **não fazer por conta própria**, reportar. |
| `repoURL` com `git@github.com:...` | Forma SSH exige Secret de credencial, que esta arquitetura não possui | A validação de `variables.tf` rejeita; use sempre `https://`. |

---

## 8. Encerramento do laboratório (ordem correta)

1. **Destruir a stack `05-`** (e as demais) **enquanto o repositório ainda está público**.
2. Só então **fechar o repositório** (voltar a privado).

Inverter essa ordem deixa a `Application` em `ComparisonError` durante o encerramento. Reverter a visibilidade é **operação fora do escopo do ADR-0006** (§14), e **não desfaz a exposição** do que foi publicado durante a janela pública (§11).

---

## 9. Observações

- A stack é **100% reproduzível por `terraform apply`** — não há passo manual de segredo (ganho da Revisão 3 do ADR-0006). Os únicos passos manuais são a troca da senha do `admin` e a remoção do `argocd-initial-admin-secret`.
- Custo AWS incremental: **~USD 0,50–2,00/mês**, apenas processamento de NAT (polling do Git + pull das imagens do ArgoCD). Sem Load Balancer, sem nós adicionais.
- `terraform.tfvars` e `backend.hcl` são **gitignored**; versionados aqui estão apenas os `*.example`.
