############################################################################
# locals.tf
#
# ADR-0006 (Secao 9 / 13.1 passo 3): ambiente fixo, tags comuns, sizing dos
# componentes do ArgoCD e o `values` do chart (incluindo a Application
# renderizada via `extraObjects` — D2/Opcao C).
#
# Mesmo padrao de 00-/01-/02-/03- (Revisao 5 do ADR-0001): ambiente unico
# "prd", fixo como local — nao existe variable "environment".
############################################################################

locals {
  # Ambiente unico desta stack. Nao e um input.
  environment = "prd"

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0006 Secao 9). Aplicadas via default_tags do
  # provider aws (providers.tf). Esta stack NAO cria recursos AWS hoje —
  # as tags existem para o caso de algum recurso AWS ser adicionado.
  #
  # ATENCAO: 'Owner' e 'CostCenter' abaixo sao placeholders e DEVEM ser
  # sobrescritos via var.tags (terraform.tfvars) antes do apply real
  # (ADR-0006 Premissa 15 prescreve "Leopoldo Peixoto Cardoso" /
  # "workshop-devops-na-nuvem", os mesmos valores ja materializados em
  # 02-/03-). Ver README.md.
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "AJUSTAR-time-responsavel"
      CostCenter         = "AJUSTAR-centro-de-custo"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "confidential"
      StackName          = "05-argocd-stack-ai"
    },
    var.tags
  )

  # --------------------------------------------------------------------
  # Sizing dos componentes (ADR-0006 D3/Opcao A: instalacao nao-HA, com
  # `requests`/`limits` explicitos e modestos em todos os componentes, para
  # caber no node group de 2x t3.medium que ja hospeda 4 pods de aplicacao).
  #
  # Os valores abaixo sao decisao de IMPLEMENTACAO — o ADR exige que
  # existam e sejam modestos, sem prescrever numeros. Nao sao input de
  # ambiente (nao variam por ambiente: so existe "prd"), por isso ficam
  # aqui e nao em terraform.tfvars. Ajuste com dados reais de
  # `kubectl top pods -n argocd` apos a primeira semana.
  # --------------------------------------------------------------------
  argocd_resources = {
    controller = {
      requests = { cpu = "100m", memory = "256Mi" }
      limits   = { cpu = "500m", memory = "1Gi" }
    }
    repo_server = {
      requests = { cpu = "100m", memory = "192Mi" }
      limits   = { cpu = "500m", memory = "512Mi" }
    }
    server = {
      requests = { cpu = "50m", memory = "128Mi" }
      limits   = { cpu = "300m", memory = "256Mi" }
    }
    redis = {
      requests = { cpu = "50m", memory = "64Mi" }
      limits   = { cpu = "200m", memory = "256Mi" }
    }
    application_set = {
      requests = { cpu = "50m", memory = "64Mi" }
      limits   = { cpu = "200m", memory = "256Mi" }
    }
  }

  # --------------------------------------------------------------------
  # syncPolicy da Application (ADR-0006 D5/Opcao A).
  #
  # O bloco `automated` so e renderizado quando ao menos um dos flags esta
  # ligado. Isso viabiliza a "primeira sync controlada" exigida pelo passo
  # 6 da Secao 13.1: criar a Application com `automated_prune` e
  # `automated_self_heal` = false, inspecionar o diff na UI e so entao
  # habilitar os dois em um segundo apply.
  #
  # Sem `CreateNamespace=true` (D5): o namespace `dvn-workshop` e um objeto
  # do proprio Kustomize (dvn-workshop-kubernetes/namespace.yaml).
  # --------------------------------------------------------------------
  argocd_application_sync_policy = (
    var.argocd_application.automated_prune || var.argocd_application.automated_self_heal
    ) ? {
    automated = {
      prune    = var.argocd_application.automated_prune
      selfHeal = var.argocd_application.automated_self_heal
    }
  } : {}

  # --------------------------------------------------------------------
  # Application GitOps (ADR-0006 Secao 5 e D2/Opcao C) — renderizada pelo
  # MESMO release que instala o ArgoCD, via `extraObjects`. Nao existe um
  # segundo helm_release nem o chart `argocd-apps`.
  #
  # `source.repoURL` e HTTPS PUBLICO e SEM CREDENCIAL (D6/Opcao D): nenhum
  # Secret de repositorio e criado no namespace argocd. A validacao em
  # variables.tf rejeita a forma `git@`.
  #
  # DELIBERADAMENTE SEM o finalizer `resources-finalizer.argocd.argoproj.io`:
  # com ele, deletar a Application cascatearia a delecao dos workloads de
  # `dvn-workshop` (ADR-0006 Secao 12, item 4). Sem finalizer, remover a
  # Application deixa os objetos de aplicacao rodando.
  # --------------------------------------------------------------------
  argocd_application_manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = var.argocd_application.name
      namespace = var.argocd.namespace
    }

    spec = {
      project = "default"

      source = {
        repoURL        = var.argocd_application.repo_url
        path           = var.argocd_application.path
        targetRevision = var.argocd_application.target_revision
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_application.destination_namespace
      }

      syncPolicy = local.argocd_application_sync_policy
    }
  }

  # --------------------------------------------------------------------
  # `values` do chart argo-cd.
  #
  # Chaves conferidas LINHA A LINHA contra o values.yaml da versao fixada
  # do chart (argo-cd 10.9.2, appVersion v3.5.3), baixado de
  # raw.githubusercontent.com/argoproj/argo-helm em 2026-09-22 — conforme
  # exigido pelo passo 3 da Secao 13.1 ("nao presumir, ler o chart da
  # versao fixada"):
  #
  #   dex.enabled            -> existe (default true)  -> desligado aqui
  #   notifications.enabled  -> existe (default true)  -> desligado aqui
  #   redis-ha.enabled       -> existe (default false) -> mantido false
  #   redis.enabled          -> existe (default true)  -> mantido true
  #   server.service.type    -> existe (default ClusterIP)
  #   controller/repoServer/server/redis/applicationSet.resources -> existem
  #   extraObjects           -> existe (default [])
  #
  # DIVERGENCIA CONHECIDA (reportada ao Planner, NAO resolvida por conta
  # propria): a chave `applicationSet.enabled` NAO EXISTE no chart 10.9.2 —
  # o ApplicationSet controller passou a ser parte fixa do chart e seu
  # Deployment nao tem condicional de habilitacao. A intencao do ADR
  # (Premissa 13 / D3/A: "economiza pods num cluster de 2 nos") e preservada
  # aqui pelo unico mecanismo disponivel na versao fixada: `replicas = 0`
  # quando `applicationset_enabled = false` — o Deployment existe, mas nao
  # sobe pod algum. Se o Planner preferir outro tratamento, e mudanca de
  # ADR, nao de codigo.
  # --------------------------------------------------------------------
  argocd_values = yamlencode({
    # CRDs instalados pelo proprio release (default do chart: install=true,
    # keep=true). `keep=true` significa que um `terraform destroy` NAO
    # remove os CRDs do ArgoCD — comportamento documentado no README.
    crds = {
      install = true
      keep    = true
    }

    # Componentes opcionais desligados (ADR-0006 Premissa 13 / D3/A).
    dex = {
      enabled = var.argocd.dex_enabled
    }

    notifications = {
      enabled = var.argocd.notifications_enabled
    }

    # Ver DIVERGENCIA CONHECIDA acima: nao existe applicationSet.enabled
    # no chart 10.9.2.
    applicationSet = {
      replicas  = var.argocd.applicationset_enabled ? 1 : 0
      resources = local.argocd_resources.application_set
    }

    # Instalacao NAO-HA (D3/Opcao A): replica unica por componente e Redis
    # single (subchart redis-ha desligado).
    "redis-ha" = {
      enabled = var.argocd.ha_enabled
    }

    controller = {
      replicas  = 1
      resources = local.argocd_resources.controller
    }

    repoServer = {
      replicas  = 1
      resources = local.argocd_resources.repo_server
    }

    server = {
      replicas  = 1
      resources = local.argocd_resources.server

      # D4/Opcao A: Service ClusterIP; acesso a UI por
      # `kubectl port-forward`, tunelado pelo endpoint publico restrito da
      # API do cluster. Nenhum LoadBalancer/NodePort/Ingress.
      service = {
        type = var.argocd.server_service_type
      }
    }

    redis = {
      enabled   = true
      resources = local.argocd_resources.redis
    }

    # Application declarada dentro do proprio release (D2/Opcao C). Lista
    # vazia enquanto `argocd_application.enabled = false` (passo 3 da
    # Secao 13.1: instalar o ArgoCD primeiro, validar conectividade Git e
    # so entao criar a Application).
    extraObjects = var.argocd_application.enabled ? [local.argocd_application_manifest] : []
  })
}
