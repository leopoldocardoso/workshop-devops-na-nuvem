# Workshop DevOps na Nuvem 🚀

> 📚 Este conteúdo faz parte do **Workshop DevOps na Nuvem** ministrado por **Kenerry Serain**

Repositório de **Infraestrutura como Código (IaC)** para um ambiente de produção completo na AWS, com EKS (Kubernetes), networking, ECR, e aplicações containerizadas.

## 📋 O que é este projeto?

Este é um **repositório de infraestrutura**, não de aplicação. Contém:

- ✅ **Terraform stacks** numerados e modularizados em `NN-*-stack-ai/`
- ✅ **Manifestos Kubernetes** (Kustomize) para deploy de apps no EKS
- ✅ **Architecture Decision Records (ADRs)** documentando todas as decisões
- ✅ **Dockerfiles** de produção para aplicações (Next.js + .NET)
- ✅ **Regras de convenção** para Terraform e Kubernetes

**Ambiente único:** Produção (`prd`) apenas. Nenhum staging/dev integrado.

---

## 🏗️ Arquitetura

```
AWS (us-east-1)
├── VPC 10.0.0.0/24 (01-networking-stack-ai)
│   ├── 2 subnets públicas
│   ├── 2 subnets privadas
│   └── NAT Gateway (single)
│
├── EKS Cluster (02-eks-stack-ai)
│   ├── Control plane (API endpoint)
│   ├── 1 node group (2x t3.medium, AL2023)
│   ├── KMS encryption (Secrets)
│   └── CloudWatch logs
│
├── ECR Repositories (03-ecr-stack-ai)
│   ├── dvn-workshop/production/frontend:v1.0
│   └── dvn-workshop/production/backend:v1.0
│
└── S3 Backend (00-bootstrap-stack-ai)
    └── prd-bootstrap-tfstate-<account-id>-us-east-1
```

### Aplicações Deployadas

| App | Framework | Porta | Health Check |
|-----|-----------|-------|--------------|
| **Frontend** | Next.js 14 (Node.js 20) | 3000 | `GET /api/health` |
| **Backend** | .NET 8 (C#) | 8080 | `GET /backend/health` |

Ambas com 2 replicas, RollingUpdate, PodDisruptionBudget, e security contexts restritivos.

---

## 🚀 Quick Start

### Pré-requisitos

```bash
# Ferramentas necessárias
- terraform >= 1.0
- kubectl >= 1.28
- kustomize >= 5.0
- aws-cli >= 2.0
- infracost >= 2.0 (para estimativa de custos)

# Credenciais AWS
export AWS_PROFILE=seu-profile
# ou
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

### Fazer Deploy de uma Stack

```bash
# Ver plano de execução (sem fazer nada)
.claude/skills/terraform-deploy/deploy.sh --dry-run 01-networking-stack-ai

# Aplicar uma stack específica
.claude/skills/terraform-deploy/deploy.sh 01-networking-stack-ai

# Aplicar todas as stacks
.claude/skills/terraform-deploy/deploy.sh
```

### Deploy Kubernetes

```bash
# Atualizar kubeconfig local
aws eks update-kubeconfig --region us-east-1 --name prd-eks-us-east-1

# Validar manifestos offline
kustomize build dvn-workshop-kubernetes/

# Fazer deploy
kubectl apply -k dvn-workshop-kubernetes/

# Monitorar rollout
kubectl rollout status deployment/frontend -n dvn-workshop
kubectl rollout status deployment/backend -n dvn-workshop
```

### Acesso Local (Port-forward)

```bash
# Terminal 1: Frontend
kubectl port-forward -n dvn-workshop svc/frontend 3000:80

# Terminal 2: Backend
kubectl port-forward -n dvn-workshop svc/backend 8080:80

# Testar
curl http://localhost:3000/api/health          # {"status":"healthy"}
curl http://localhost:8080/backend/health      # Healthy
curl http://localhost:8080/backend/swagger/index.html  # Swagger UI
```

---

## 📂 Estrutura do Repositório

```
.
├── 00-bootstrap-stack-ai/           # S3 backend state (ADR-0002)
├── 01-networking-stack-ai/          # VPC, subnets, NAT (ADR-0001)
├── 02-eks-stack-ai/                 # EKS cluster, node group (ADR-0003)
├── 03-ecr-stack-ai/                 # ECR repositories (ADR-0004)
│
├── dvn-workshop-kubernetes/         # Kustomize tree para apps
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── pod-disruption-budget.yaml
│   │   └── kustomization.yaml
│   └── backend/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── pod-disruption-budget.yaml
│       └── kustomization.yaml
│
├── dvn-workshop-apps/
│   ├── frontend/youtube-live-app/   # Next.js app + Dockerfile
│   └── backend/YoutubeLiveApp/      # .NET app + Dockerfile
│
├── docs/
│   ├── adr/                         # Architecture Decision Records
│   ├── diagramas/                   # Diagrams (draw.io)
│   └── deployments/                 # Apply logs & outputs
│
├── .claude/
│   ├── agents/                      # Subagent definitions
│   ├── rules/                       # Naming conventions, best practices
│   └── skills/                      # terraform-deploy, terraform-destroy
│
├── CLAUDE.md                        # Guia para Claude Code
├── .mcp.json                        # MCP servers config
└── README.md                        # Este arquivo

```

---

## 📚 Stacks Terraform

### 00-bootstrap-stack-ai (ADR-0002)
**Objetivo:** Criar bucket S3 para estado remoto de Terraform

```bash
cd 00-bootstrap-stack-ai
terraform init
terraform plan
terraform apply
```

**Backend local permanente:** Sem S3 backend (`override.tf` fixo)  
**Custo mensal:** ~$1-2 (S3 storage mínimo)

---

### 01-networking-stack-ai (ADR-0001)
**Objetivo:** VPC, subnets, NAT Gateway, route tables

- VPC: `10.0.0.0/24`
- 2 subnets públicas (`10.0.0.0/26`, `10.0.0.64/26`)
- 2 subnets privadas (`10.0.0.128/26`, `10.0.0.192/26`)
- 1 NAT Gateway (HA não configurado — trade-off aceitável em ADR-0001)

```bash
cd 01-networking-stack-ai
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

**Backend:** S3 remoto (requer `backend.hcl` gitignored)  
**Custo mensal:** ~$35 (NAT Gateway + data processing)

---

### 02-eks-stack-ai (ADR-0003)
**Objetivo:** EKS cluster control plane + node group

- Kubernetes 1.34
- 1 node group: 2x `t3.medium`, autoscaling 2-3
- KMS encryption para Secrets
- CloudWatch logs (90 dias retenção)
- OIDC provider para IRSA (não usado — non-goal do ADR)

```bash
cd 02-eks-stack-ai
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

**Backend:** S3 remoto  
**Custo mensal:** ~$110 (cluster + nodes + data transfer)  
**Importante:** `lifecycle.prevent_destroy` removido em 2026-08-30 para permitir destroy

---

### 03-ecr-stack-ai (ADR-0004)
**Objetivo:** ECR repositories para apps

- `dvn-workshop/production/frontend` (IMMUTABLE_WITH_EXCLUSION)
- `dvn-workshop/production/backend` (IMMUTABLE_WITH_EXCLUSION)
- Políticas de lifecycle: untagged → 7 dias; tagged → top 10 mantidas
- Scan on push, AES256 encryption

```bash
cd 03-ecr-stack-ai
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

**Backend:** S3 remoto  
**Custo mensal:** ~$1-5 (armazenamento de imagens + scan)

---

## 🐳 Build & Push de Imagens

### Usando a skill `docker-ecr-push`

```bash
# Frontend (última tag built é v1.0)
.claude/skills/docker-ecr-push/push.sh \
  659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend:v1.1

# Backend
.claude/skills/docker-ecr-push/push.sh \
  659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend:v1.1
```

**Nota:** A skill faz:
1. Build da imagem (deteta Dockerfile automaticamente)
2. Push para ECR
3. Login ECR automático (via `aws ecr get-login-password`)

---

## 🔄 Workflow de Desenvolvimento

### Para modificações de infraestrutura:

1. **Arquiteto** (`aws-architect`) → cria ADR em `docs/adr/`
2. **DevOps Engineer** (`devops-engineer`) → implementa Terraform
3. **Review + Approve** → terraform plan obrigatório em prd
4. **Deploy** → `.claude/skills/terraform-deploy/deploy.sh`

### Para modificações de manifesto Kubernetes:

1. Editar `dvn-workshop-kubernetes/*/deployment.yaml`
2. Validar: `kustomize build dvn-workshop-kubernetes/`
3. Dry-run: `kubectl apply -k dvn-workshop-kubernetes/ --dry-run=server`
4. Deploy: `kubectl apply -k dvn-workshop-kubernetes/`

---

## 📊 Custo Estimado (Mensal)

```
Networking (VPC, NAT)     ~  $35
EKS Control Plane         ~  $73
Node Group (2x t3.medium) ~  $35
ECR (images storage)      ~   $3
Data Transfer             ~   $5
────────────────────────────────
Total                     ~ $151/mês
```

*Estimativa sem considerar usage-based (data processing, logs).*  
*Usar `infracost scan` para cálculo preciso.*

---

## 🔐 Segurança

### Kubernetes

- ✅ Security context: `runAsNonRoot`, `readOnlyRootFilesystem`
- ✅ Pod security: `allowPrivilegeEscalation: false`, `drop: ["ALL"]`
- ✅ Network policies (não configurado — NAT Gateway é perímetro)
- ✅ RBAC: `automountServiceAccountToken: false`
- ✅ Image scanning: ECR scan on push
- ✅ Probes: readiness + liveness obrigatórias

### AWS

- ✅ KMS encryption para Secrets (envelope encryption)
- ✅ S3 backend: versioned, SSE-S3, no public access
- ✅ VPC: subnets privadas para nodes
- ✅ Security groups: least privilege
- ✅ IAM: roles/policies mínimas por recurso

---

## 📖 Documentação

### Architecture Decision Records

```
docs/adr/
├── ADR-0001-Revision-5-AWS-Networking.md
├── ADR-0002-Terraform-Backend.md
├── ADR-0003-EKS-Cluster.md
├── ADR-0004-ECR-Repositories.md
└── ...
```

**Leia antes de fazer mudanças!** ADRs documentam:
- Contexto e drivers da decisão
- Opções consideradas e por que foram rejeitadas
- Consequências e riscos
- Rollback strategy

### READMEs de Stack

Cada stack tem seu próprio `README.md` com:
- Comandos específicos de deploy/rollback
- Validação pós-deploy
- Troubleshooting

---

## 🆘 Troubleshooting

### kubectl: `dial tcp: lookup ...eks.amazonaws.com: no such host`

O kubeconfig aponta para um endpoint EKS destruído. Atualize:

```bash
aws eks update-kubeconfig --region us-east-1 --name prd-eks-us-east-1
```

### Pods em `ImagePullBackOff`

Verifique se a tag existe no ECR:

```bash
aws ecr describe-images --repository-name dvn-workshop/production/frontend \
  --image-ids imageTag=v1.0
```

Se faltar, faça push:

```bash
.claude/skills/docker-ecr-push/push.sh \
  659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend:v1.0
```

### Terraform state lock

Se um apply falhar e deixar lock:

```bash
# Ver lock
terraform force-unlock <LOCK_ID>
```

### Infracost falha

Se `infracost` não estiver disponível, o deploy continua (apenas warning).  
Instale: `brew install infracost`

---

## 🤝 Contribuindo

### Padrões de código

- Terraform: `snake_case` para identifiers, veja `.claude/rules/terraform-naming-conventions.md`
- Kubernetes: veja `.claude/rules/kubernetes-manifests.md`
- Commits: mensagens descritivas em português/inglês com escopo

### Antes de fazer PR

1. Validar Terraform: `terraform fmt -check` + `terraform validate`
2. Validar Kubernetes: `kustomize build dvn-workshop-kubernetes/`
3. Verificar custo: `infracost scan`
4. Ler ADR relevante

---

## 📞 Suporte

- **Issues:** GitHub Issues
- **Dúvidas sobre ADRs:** veja `docs/adr/`
- **Claude Code setup:** veja `CLAUDE.md`

---

## 📜 Licença

MIT License — veja LICENSE

---

**Última atualização:** 2026-09-21  
**Ambiente:** Production (prd)  
**Região:** us-east-1
