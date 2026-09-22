# dvn-workshop-kubernetes

Manifestos Kubernetes das apps de `dvn-workshop-apps/` para o cluster EKS de `02-eks-stack-ai`, gerados conforme `.claude/rules/kubernetes-manifests.md`.

| App      | Imagem (ECR, `03-ecr-stack-ai`)                              | Porta | Health            |
|----------|--------------------------------------------------------------|-------|-------------------|
| frontend | `.../dvn-workshop/production/frontend:v1.0`                  | 3000  | `/api/health`     |
| backend  | `.../dvn-workshop/production/backend:v1.0`                   | 8080  | `/backend/health` |

Cada app entrega `Deployment` (2 réplicas) + `Service` `NodePort` + `PodDisruptionBudget` (`minAvailable: 1`), no namespace `dvn-workshop`.

## Pré-requisitos

- Imagens `:v1.0` publicadas no ECR (skill `docker-ecr-push`).

## Promover uma nova versão

A imagem e a label `app.kubernetes.io/version` são definidas **só** no `kustomization.yaml` de cada app (transformers `images` e `labels`); `deployment.yaml` referencia apenas o nome lógico (`image: frontend`). Para subir `v1.1` do frontend:

```bash
cd dvn-workshop-kubernetes/frontend
kustomize edit set image frontend=659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend:v1.1
sed -i 's/app.kubernetes.io\/version: v1.0/app.kubernetes.io\/version: v1.1/' kustomization.yaml
kustomize build .. | grep -E 'image:|app.kubernetes.io/version'   # conferir
```
- Contexto `kubectl` apontando para o cluster de `02-eks-stack-ai` (`aws eks update-kubeconfig --region us-east-1 --name <cluster>`).

## Validar

```bash
kustomize build dvn-workshop-kubernetes/ | kubectl apply --dry-run=server -f -
```

## Aplicar

```bash
kubectl apply -k dvn-workshop-kubernetes/
kubectl -n dvn-workshop rollout status deploy/frontend deploy/backend
kubectl -n dvn-workshop get svc   # NodePort alocado pelo cluster (30000–32767)
```

Os NodePorts ficam acessíveis apenas de dentro da VPC (nós em subnets privadas, ADR-0001). Exposição pública é decisão de ADR, não deste diretório.

## Rollback

```bash
kubectl -n dvn-workshop rollout undo deploy/<app>
```
