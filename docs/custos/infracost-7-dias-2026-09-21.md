# Estimativa de custo — 7 dias (01-, 02-, 03-)

> Fonte: `infracost scan` (v2.16.2) rodado da raiz do repo em 2026-09-21, sobre o
> código Terraform + `terraform.tfvars` de cada stack, em `us-east-1`, preços de
> lista on-demand (USD). O Infracost reporta custo **mensal** com base em
> 730 h/mês; os valores abaixo foram convertidos para **7 dias = 168 h**
> (fator 168/730 ≈ 0,2301 para itens cobrados por mês, ×168 para itens por hora).
> Não inclui componentes cobrados por uso (ver "O que não está incluído").

## Resumo

| Stack | Mensal (Infracost) | **7 dias** | Principal componente |
|---|---:|---:|---|
| `01-networking-stack-ai` | $32,85 | **$7,56** | NAT Gateway (1x) |
| `02-eks-stack-ai` | $138,74 | **$31,93** | Control plane EKS + 2x `t3.medium` |
| `03-ecr-stack-ai` | $0,00 | **$0,00** (~$0,01 com as imagens atuais) | Storage ECR (por GB) |
| **Total** | **$171,59** | **$39,49** | |

`00-bootstrap-stack-ai` (bucket S3 do state) também está no ar e é estimada em
$0/mês pelo Infracost (storage/requests desprezíveis para arquivos de state).

## Detalhe por recurso

### `01-networking-stack-ai`

| Recurso | Componente | Preço | Quantidade (7 d) | **7 dias** |
|---|---|---:|---:|---:|
| `aws_nat_gateway.this["us-east-1a"]` | NAT gateway (hora) | $0,045/h | 168 h | **$7,56** |

Os demais 21 recursos (VPC, subnets, route tables, IGW, EIP associado ao NAT,
flow logs/IAM/log group) não têm custo fixo.

### `02-eks-stack-ai`

| Recurso | Componente | Preço | Quantidade (7 d) | **7 dias** |
|---|---|---:|---:|---:|
| `aws_eks_cluster.this` | EKS cluster (control plane, hora) | $0,10/h | 168 h | **$16,80** |
| `aws_eks_node_group.this` | 2x `t3.medium` on-demand (Linux) | $0,0416/h | 336 h (2 × 168) | **$13,98** |
| `aws_eks_node_group.this` | Storage gp2, 2 × 20 GB | $0,10/GB-mês | 40 GB × 168/730 | **$0,92** |
| `aws_kms_key.secrets` | Customer master key | $1,00/mês | 1 × 168/730 | **$0,23** |
| | | | **Subtotal** | **$31,93** |

Os demais 8 recursos (IAM roles/attachments, OIDC provider, KMS alias, log
group) não têm custo fixo.

### `03-ecr-stack-ai`

| Recurso | Componente | Preço | Quantidade (7 d) | **7 dias** |
|---|---|---:|---:|---:|
| `aws_ecr_repository.backend` | Storage | $0,10/GB-mês | ~0,047 GB × 168/730 | ~$0,001 |
| `aws_ecr_repository.frontend` | Storage | $0,10/GB-mês | ~0,051 GB × 168/730 | ~$0,001 |

O Infracost estima $0 porque não conhece o volume armazenado; com as duas
imagens `v1.0` publicadas em 2026-09-21 (~47 MB + ~51 MB comprimidos), o
custo real de 7 dias fica abaixo de um centavo. Lifecycle policies são gratuitas.

## O que não está incluído

Componentes cobrados por uso, que dependem do tráfego/atividade da semana:

- **NAT Gateway — processamento de dados:** $0,045/GB que passa pelo NAT
  (pulls de imagem, atualizações de pacotes dos nós, chamadas dos pods à
  internet). Costuma ser o item variável mais relevante desta topologia.
- **EKS — logs do control plane no CloudWatch** (`api`, `audit`,
  `authenticator`, `controllerManager`, `scheduler`, retenção 90 d): ~$0,50/GB
  ingerido + $0,03/GB-mês armazenado.
- **VPC Flow Logs no CloudWatch:** mesma tarifa de ingestão/armazenamento.
- **ECR — transferência de dados** para pulls de fora da região (pulls dos nós
  EKS na mesma região via NAT são cobrados pelo NAT, não pelo ECR).
- **KMS — requisições** ($0,03 / 10 mil) para encriptação de secrets do cluster.
- **Extended support do EKS:** não se aplica — o cluster está em Kubernetes
  1.34 (suporte padrão). A política FinOps do Infracost que alerta sobre isso
  em `02-eks-stack-ai` é um falso positivo.

## Como reproduzir

```bash
# da raiz do repo — descobre as 4 stacks e seus terraform.tfvars automaticamente
infracost scan
infracost inspect --group-by resource   # custo mensal por recurso
infracost inspect --json                # números sem arredondamento
```

Conversão mensal → 7 dias: `custo_mensal × 168 / 730`.
