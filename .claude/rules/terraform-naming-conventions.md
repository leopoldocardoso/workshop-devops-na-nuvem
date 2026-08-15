# Regra: Convenções de Nomenclatura Terraform

**Fonte:** [terraform-best-practices.com/naming](https://www.terraform-best-practices.com/naming)
**Escopo:** aplica-se a todo código Terraform gerado ou modificado neste projeto (stacks em `*-ai/`, módulos, environments).
**Consumido por:** `devops-engineer` (implementação) e `aws-architect` (ao definir a seção 9 "Naming Convention & Tagging" de um ADR, quando o ADR também prescrever estrutura de arquivos).

Esta regra combina as convenções gerais da comunidade Terraform com decisões específicas deste projeto (marcadas como **[projeto]**). Onde houver conflito, a regra do projeto prevalece.

---

## 1. Princípio geral de identificadores

- Use `_` (underscore) — nunca `-` (dash) — em nomes de `resource`, `data`, `variable`, `output`, `local` e módulos. Dash é reservado para nomes de arquivo (seção 2).
- Prefira minúsculas e números. UTF-8 é tecnicamente suportado, mas não deve ser usado em identificadores.
- Lembre-se: essas regras valem para os identificadores do Terraform. O nome do recurso real na AWS (tag `Name`, etc.) segue a naming convention de negócio já definida na seção 9 dos ADRs (`{env}-{app}-{service}-{region}`), que é independente desta regra.

---

## 2. Nomenclatura de arquivos `*.tf` **[projeto]**

Cada arquivo representa um domínio de recursos. Use o padrão `<dominio>.tf` para o arquivo "raiz" do domínio e `<dominio>.<sub-dominio>.tf` (sub-domínio em kebab-case) para desdobramentos daquele domínio em arquivos separados.

```
main.tf                     # sempre presente — ver regra abaixo
vpc.tf                      # aws_vpc + adoção dos objetos default (SG/NACL)
vpc.public-subnets.tf       # sub-redes públicas
vpc.private-subnets.tf      # sub-redes privadas
vpc.route-tables.tf         # route tables e associations
vpc.nat-gateway.tf          # NAT Gateway + EIP
vpc.flow-logs.tf            # VPC Flow Logs (log group, IAM role/policy, aws_flow_log)
variables.tf                # declaração de variáveis (sem valores — ver seção 4)
variables.values.tf         # OU terraform.tfvars — ver seção 4
outputs.tf
locals.tf
data.tf
providers.tf
versions.tf
backend.tf
```

Regras:

- **Sempre crie um `main.tf`.** Mesmo quando o conteúdo principal está fatiado em arquivos por domínio (`vpc.tf`, `vpc.public-subnets.tf`, ...), o `main.tf` deve existir como ponto de entrada: cabeçalho da stack, chamadas de `module` de mais alto nível (quando houver), ou um comentário indicando onde cada domínio está implementado. Não remova `main.tf` só porque o restante virou arquivos nomeados por domínio.
- Não repita o tipo de recurso no nome do arquivo (ex.: não crie `vpc.aws_subnet.public.tf`; use `vpc.public-subnets.tf`).
- Um novo domínio (ex.: `eks`, `rds`) segue o mesmo padrão: `eks.tf`, `eks.node-groups.tf`, `eks.irsa.tf` etc.
- Arquivos transversais (`variables.tf`, `outputs.tf`, `locals.tf`, `data.tf`, `providers.tf`, `versions.tf`, `backend.tf`) não usam o padrão de domínio — mantêm o nome único de sempre.

---

## 3. Nomenclatura de Resources e Data Sources

- **Não redundante:** o nome não repete o tipo do recurso.
  Correto: `resource "aws_route_table" "public"`
  Incorreto: `resource "aws_route_table" "public_route_table"`
- **Substantivo no singular**, mesmo quando o recurso usa `count`/`for_each` para gerar múltiplas instâncias — o bloco descreve *um* recurso do conjunto, não a coleção.
  Correto: `resource "aws_subnet" "public"` (com `for_each`)
- Use `this` quando não houver nome mais descritivo, ou quando o arquivo/módulo tiver apenas um recurso daquele tipo (ex.: `resource "aws_vpc" "this"`, já em uso em `vpc.tf`).
- **Ordem dos argumentos** dentro do bloco:
  1. `count` ou `for_each`, seguido de linha em branco
  2. demais argumentos
  3. `tags` (penúltimo bloco)
  4. `depends_on` e `lifecycle` por último
- Prefira expressões booleanas a `length(...) > 0` em condições de `count`.

---

## 4. Nomenclatura e organização de Variáveis

### 4.1 Agrupe em objetos por domínio **[projeto]**

Evite variáveis "soltas" quando elas descrevem o mesmo domínio. Agrupe em uma única `variable` do tipo `object(...)` com um atributo por propriedade, em vez de uma variável por propriedade.

Evite:

```hcl
variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
```

Prefira:

```hcl
variable "vpc" {
  description = "Configuração agregada da VPC: nome, CIDR e sub-redes públicas/privadas."
  type = object({
    name = string
    cidr = string
    public_subnets = list(object({
      name              = string
      cidr_block        = string
      availability_zone = string
    }))
    private_subnets = list(object({
      name              = string
      cidr_block        = string
      availability_zone = string
    }))
  })
  nullable = false

  validation {
    condition     = can(cidrhost(var.vpc.cidr, 0))
    error_message = "vpc.cidr deve ser um bloco CIDR IPv4 válido."
  }
}
```

Uso no código: `var.vpc.name`, `var.vpc.cidr`, `var.vpc.public_subnets`, etc.

Regras de agrupamento:

- Agrupe por domínio de recurso (`vpc`, `nat_gateway`, `flow_logs`), não por tipo Terraform.
- Variáveis verdadeiramente independentes e reaproveitadas por múltiplos domínios (ex.: `environment`, `project_name`, `aws_region`) podem permanecer standalone — o agrupamento é para atributos que descrevem um mesmo recurso/conjunto.
- Liste em minúsculas, use nomes no plural para atributos `list`/`map` (ex.: `public_subnets`, não `public_subnet`).
- Evite dupla negativa (`encryption_enabled`, não `encryption_disabled`).
- Use `nullable = false` sempre que o atributo/objeto não deve aceitar `null`.
- Ordem dos elementos dentro do bloco `variable`: `description`, `type`, `nullable`, `validation`. **Nunca `default`** — ver seção 4.2.

### 4.2 Sem `default`: valores em arquivo separado **[projeto]**

`variables.tf` (ou `<dominio>.variables.tf`) só declara a *forma* da variável (`description`, `type`, `validation`) — nunca o argumento `default`.

Os valores efetivos vão em um arquivo `.tfvars` dedicado, versionado por ambiente:

```
environments/dev/terraform.tfvars
environments/hml/terraform.tfvars
environments/prd/terraform.tfvars
```

ou, para uma stack single-environment como as deste projeto hoje, um `terraform.tfvars` na raiz da stack (mantendo o padrão já usado em `01-networking-stack-ai/terraform.tfvars.example`).

```hcl
# terraform.tfvars
vpc = {
  name = "networking"
  cidr = "192.168.1.0/24"
  public_subnets = [
    { name = "public-a", cidr_block = "192.168.1.0/26", availability_zone = "sa-east-1a" },
    { name = "public-b", cidr_block = "192.168.1.64/26", availability_zone = "sa-east-1b" },
  ]
  private_subnets = [
    { name = "private-a", cidr_block = "192.168.1.128/26", availability_zone = "sa-east-1a" },
    { name = "private-b", cidr_block = "192.168.1.192/26", availability_zone = "sa-east-1b" },
  ]
}
```

Motivo: `default` mistura forma e dado dentro do mesmo arquivo versionado como "contrato" da stack; separar em `.tfvars` deixa claro o que é definição (revisão rara) e o que é valor de ambiente (revisão frequente), e viabiliza múltiplos ambientes sem duplicar `variables.tf`.

Exceções permitidas a "sem default": flags puramente técnicas que nunca variam por ambiente e não fazem parte de nenhum objeto de domínio (raro — justifique no código com um comentário curto se ocorrer).

---

## 5. Nomenclatura de Outputs

- Padrão: `{name}_{type}_{attribute}` (ex.: `vpc_id`, `public_subnets_ids`, `nat_gateway_public_ips`).
- Use plural quando o output retorna uma lista/coleção.
- Sempre com `description`.
- Prefira `try(...)` a concatenações/lookups legados para outputs que podem não existir (ex.: recurso condicional via `count`/`for_each`).

---

## 6. Checklist rápido

- [ ] Nenhum identificador (`resource`, `variable`, `output`, `local`) usa `-`.
- [ ] Nome de arquivo segue `<dominio>.tf` ou `<dominio>.<sub-dominio>.tf`; `main.tf` existe.
- [ ] Resource/data source não repete o tipo no nome e está no singular.
- [ ] `count`/`for_each` no topo do bloco; `tags` antes de `depends_on`/`lifecycle`.
- [ ] Variáveis do mesmo domínio agrupadas em um `object(...)` único.
- [ ] Nenhuma `variable` com `default`; valores estão em `.tfvars`.
- [ ] Outputs seguem `{name}_{type}_{attribute}` e têm `description`.
