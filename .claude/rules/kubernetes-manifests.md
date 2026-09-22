# Regra: Manifestos Kubernetes para Workloads

**Fonte:** [Kubernetes — Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/), [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/), [Specifying a Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
**Escopo:** aplica-se a todo manifesto Kubernetes (YAML puro, Kustomize ou template Helm) gerado ou modificado neste projeto, em especial os deploys das apps de `dvn-workshop-apps/` no cluster de `02-eks-stack-ai`.
**Consumido por:** `devops-engineer` (geração/revisão de manifests) e `aws-architect` (ao prescrever topologia de workloads em um ADR).

Esta regra combina as convenções da comunidade Kubernetes com decisões específicas deste projeto (marcadas como **[projeto]**). Onde houver conflito, a regra do projeto prevalece.

---

## 1. Conjunto mínimo de objetos por workload **[projeto]**

Todo workload HTTP implantado neste projeto é entregue como um **conjunto indivisível** de objetos. Gerar um `Deployment` sem os demais é uma entrega incompleta e deve ser tratada como erro de implementação, não como "a fazer depois".

| Objeto                  | Obrigatório | Observação                                                              |
|-------------------------|-------------|-------------------------------------------------------------------------|
| `Deployment`            | sim         | `replicas >= 2` (seção 3)                                               |
| `Service` (`NodePort`)  | sim         | um por `Deployment`, mesmo `selector` (seção 4)                          |
| `PodDisruptionBudget`   | sim         | um por `Deployment`, mesmo `selector` (seção 5)                          |
| `readinessProbe`        | sim         | em todo container do `Deployment` (seção 6)                             |
| `livenessProbe`         | sim         | em todo container do `Deployment` (seção 6)                             |
| `resources`             | sim         | `requests` e `limits` em todo container (seção 7)                        |

Organização de arquivos: um diretório por workload, um arquivo por objeto, nomeado pelo kind em kebab-case, mais um `kustomization.yaml` que os lista na ordem abaixo:

```
dvn-workshop-kubernetes/
  namespace.yaml              # namespace compartilhado do projeto (dvn-workshop)
  kustomization.yaml          # raiz: lista namespace + um diretório por app
  <app>/
    deployment.yaml
    service.yaml
    pod-disruption-budget.yaml
    kustomization.yaml
```

---

## 2. Labels padronizadas **[projeto]**

Todo objeto (`Deployment`, `Service`, `PodDisruptionBudget`, e o `template.metadata` dos Pods) carrega **exatamente este conjunto** de labels em `metadata.labels`. Nenhuma pode ser omitida; labels adicionais são permitidas, mas nunca substituem estas.

| Label                              | Valor                                                     | Exemplo                       |
|------------------------------------|-----------------------------------------------------------|-------------------------------|
| `app.kubernetes.io/name`           | nome da aplicação (kebab-case, estável entre versões)     | `frontend`                    |
| `app.kubernetes.io/instance`       | `<name>-<environment>`                                    | `frontend-prd`                |
| `app.kubernetes.io/version`        | tag da imagem publicada no ECR (mesma de `image:`)        | `v1.0`                        |
| `app.kubernetes.io/component`      | papel no sistema                                          | `web`, `api`                  |
| `app.kubernetes.io/part-of`        | nome do projeto/produto                                   | `dvn-workshop`                |
| `app.kubernetes.io/managed-by`     | ferramenta que aplica o manifesto                         | `kustomize`, `helm`, `kubectl`|
| `environment`                      | ambiente — hoje sempre `prd` (ADR-0001 Rev. 5)            | `prd`                         |

Regras:

- **Selectors usam apenas as labels imutáveis:** `app.kubernetes.io/name` e `app.kubernetes.io/instance`. Nunca inclua `app.kubernetes.io/version` em `spec.selector.matchLabels` — `selector` de `Deployment` é imutável, e uma nova versão da imagem forçaria a recriação do objeto.
- `app.kubernetes.io/version` **muda a cada rollout** e deve ser igual à tag usada em `spec.template.spec.containers[].image`. Nunca `latest` (ver seção 8). **[projeto]** Essa label **não é escrita nos manifestos**: é injetada pelo `kustomization.yaml` da app (transformer `labels` com `includeSelectors: false`, `includeTemplates: true`), ao lado do transformer `images` que define a tag — ver seção 8. Assim tag e versão vivem no mesmo arquivo e o transformer nunca toca o `selector`.
- Os valores de `app.kubernetes.io/part-of` e `environment` espelham, respectivamente, as tags `Project`/`StackName` e `Environment` usadas nas stacks Terraform, para que a correlação entre recursos AWS e objetos Kubernetes seja direta.

Exemplo canônico (sem `app.kubernetes.io/version`, que vem do `kustomization.yaml`):

```yaml
metadata:
  name: frontend
  namespace: dvn-workshop
  labels:
    app.kubernetes.io/name: frontend
    app.kubernetes.io/instance: frontend-prd
    app.kubernetes.io/component: web
    app.kubernetes.io/part-of: dvn-workshop
    app.kubernetes.io/managed-by: kustomize
    environment: prd
```

---

## 3. Deployment: mínimo de duas réplicas **[projeto]**

- `spec.replicas` é **sempre `>= 2`**. Uma réplica única não sobrevive a drain de nó, upgrade de node group nem a um `livenessProbe` falho — inaceitável num cluster que só tem `prd` como ambiente.
- Estratégia de rollout explícita, para que o número de réplicas disponíveis nunca caia abaixo do PDB durante um deploy:

  ```yaml
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  ```

- Distribua as réplicas entre nós/AZs. O cluster de `02-eks-stack-ai` tem um node group de 2 nós, então use `topologySpreadConstraints` com `whenUnsatisfiable: ScheduleAnyway` (não `DoNotSchedule`, que deixaria pods `Pending` se um nó estiver fora):

  ```yaml
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: kubernetes.io/hostname
      whenUnsatisfiable: ScheduleAnyway
      labelSelector:
        matchLabels:
          app.kubernetes.io/name: frontend
          app.kubernetes.io/instance: frontend-prd
  ```

- `revisionHistoryLimit` definido (ex.: `3`) para permitir `kubectl rollout undo` sem acumular ReplicaSets.

---

## 4. Service do tipo NodePort **[projeto]**

- **Todo `Deployment` gera exatamente um `Service` do tipo `NodePort`**, com o mesmo `name`, `namespace`, labels (seção 2) e `selector` do `Deployment`.
- Motivo: o cluster **não tem AWS Load Balancer Controller nem Ingress** (ADR-0003 §14, non-goal). `NodePort` é o único tipo que expõe o workload para fora do cluster sem depender de um controller ausente — um `LoadBalancer` ficaria eternamente `<pending>`.
- Não fixe `nodePort:` manualmente; deixe o cluster alocar dentro do range padrão (30000–32767). Isso evita colisão entre workloads e mantém o manifesto portável.
- `port` e `targetPort` nomeados, com `targetPort` referenciando o `containerPort` **pelo nome** (`http`), não pelo número — assim uma mudança de porta no container não exige editar o Service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: dvn-workshop
  labels: { ...seção 2... }
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: frontend
    app.kubernetes.io/instance: frontend-prd
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
```

- Lembre-se de que o tráfego chega pelos nós do node group, que vivem nas **subnets privadas** de `01-networking-stack-ai`. O NodePort é alcançável de dentro da VPC (e pelo Security Group do node group); expor à internet é decisão de arquitetura (ADR), não de manifesto.

---

## 5. PodDisruptionBudget **[projeto]**

- **Todo `Deployment` gera exatamente um `PodDisruptionBudget`** (`policy/v1`), com o mesmo `name`, `namespace`, labels e `selector`.
- Use `minAvailable: 1` como padrão para `replicas: 2`. Só use `maxUnavailable` quando `replicas >= 3` e o ADR justificar. Nunca defina `minAvailable` igual a `replicas` — isso torna o drain de nó impossível e bloqueia upgrades do node group.
- Se `replicas` for ajustado, revise o PDB no mesmo commit.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: frontend
  namespace: dvn-workshop
  labels: { ...seção 2... }
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: frontend
      app.kubernetes.io/instance: frontend-prd
```

---

## 6. Probes: readiness e liveness obrigatórias **[projeto]**

- **Todo container** do `Deployment` declara `readinessProbe` **e** `livenessProbe`. Omitir qualquer uma é bloqueante.
- As probes usam o **mesmo endpoint de health do `HEALTHCHECK` do Dockerfile** da aplicação, para que a definição de "saudável" seja única entre imagem e cluster. Hoje:

  | App      | Dockerfile                                         | Porta | Endpoint          |
  |----------|----------------------------------------------------|-------|-------------------|
  | frontend | `dvn-workshop-apps/frontend/youtube-live-app/`     | 3000  | `/api/health`     |
  | backend  | `dvn-workshop-apps/backend/YoutubeLiveApp/`        | 8080  | `/backend/health` |

  Se um Dockerfile mudar o endpoint, o manifesto muda junto — não invente um caminho.

- Prefira `httpGet` para apps HTTP. `exec` só quando não houver endpoint HTTP; `tcpSocket` só como último recurso (não detecta app travada com socket aberto).
- Os dois probes têm **thresholds diferentes**: readiness reage rápido (tira o pod do Service), liveness é tolerante (reinicia o container — ação destrutiva). Uma liveness agressiva demais transforma lentidão em crash loop.
- Quando a app demora para subir (JIT do .NET, build inicial do Next.js), adicione `startupProbe` para cobrir o cold start em vez de inflar `initialDelaySeconds` da liveness.

Valores de referência (ajuste com dados reais, mas nunca abaixo destes limites de tolerância na liveness):

```yaml
readinessProbe:
  httpGet:
    path: /api/health
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
livenessProbe:
  httpGet:
    path: /api/health
    port: http
  initialDelaySeconds: 15
  periodSeconds: 20
  timeoutSeconds: 3
  failureThreshold: 3
startupProbe:                 # opcional — ver acima
  httpGet:
    path: /api/health
    port: http
  periodSeconds: 5
  failureThreshold: 12        # até 60s de cold start
```

---

## 7. Recursos e segurança do container

- `resources.requests` e `resources.limits` em **todo** container (CPU e memória). Sem `requests` o scheduler não consegue distribuir a carga entre os 2 nós `t3.medium`; sem `limits` de memória um vazamento derruba o nó inteiro.
- `securityContext` alinhado ao Dockerfile (que já roda non-root):

  ```yaml
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000                   # UID numérico obrigatório — ver abaixo
    allowPrivilegeEscalation: false   # obrigatório — ver abaixo
    readOnlyRootFilesystem: true      # relaxe só se a app comprovadamente escreve em disco
    capabilities:
      drop: ["ALL"]
  ```

- **`runAsNonRoot: true` exige `runAsUser` numérico. [projeto]** O kubelet só valida `runAsNonRoot` quando conhece o UID; se a imagem declara `USER` por nome (`USER node`, `USER $APP_UID`), o pod falha com `container has runAsNonRoot and image has non-numeric user, cannot verify user is non-root`. Fixe no `securityContext` do Pod o UID real do usuário da imagem — hoje: `1000` (`node`, imagens `node:*-alpine` do frontend) e `1654` (`$APP_UID`, imagens `mcr.microsoft.com/dotnet/aspnet:8.0` do backend) — e adicione `runAsGroup` igual e `seccompProfile.type: RuntimeDefault`. Se o Dockerfile trocar de imagem-base ou de usuário, o manifesto muda junto.
- `automountServiceAccountToken: false` no Pod — nenhum workload de aplicação deste projeto fala com a API do Kubernetes (IRSA/RBAC por workload é non-goal do ADR-0003 §14).
- **Privilege escalation nunca é permitida. [projeto]** `allowPrivilegeEscalation: false` é obrigatório em **todo** container (incluindo `initContainers` e sidecars) e não admite exceção nem justificativa em ADR. Pelo mesmo motivo, são proibidos: `privileged: true`, `capabilities.add` (em especial `SYS_ADMIN`, `NET_ADMIN`, `NET_RAW`), `hostPID`/`hostIPC`/`hostNetwork: true` e `runAsUser: 0`. Um manifesto que precise de qualquer um desses itens não é um workload de aplicação — é infraestrutura de cluster e deve voltar para o `aws-architect` como bloqueio, não ser gerado.
- **Volumes sempre somente leitura. [projeto]** Quando for necessário montar um volume (`ConfigMap`, `Secret`, `projected`, `hostPath`, PVC), todo `volumeMounts[]` declara `readOnly: true`. Isso é coerente com `readOnlyRootFilesystem: true`: o container não escreve em lugar nenhum por padrão.
  - `hostPath` é proibido para workloads de aplicação — mesmo `readOnly: true` expõe o filesystem do nó. Se um requisito exigir, é bloqueio para o `aws-architect`.
  - A única exceção admitida é um `emptyDir` para escrita efêmera (cache, `/tmp`) exigida pela app quando `readOnlyRootFilesystem: true` estiver ativo — nesse caso, o mount **pode** ser gravável, deve ter `sizeLimit` definido e um comentário no manifesto explicando o motivo. Nenhum outro tipo de volume pode ser montado gravável.
  - Exceções já mapeadas para as apps deste projeto (não invente outras sem comprovar a escrita com a app rodando):

    | App      | Mount gravável (`emptyDir`) | Motivo                                                        |
    |----------|-----------------------------|---------------------------------------------------------------|
    | frontend | `/app/.next/cache`          | Next.js standalone grava cache do image optimizer / ISR       |
    | backend  | `/tmp`                      | runtime .NET usa `/tmp` (arquivos temporários, diagnostics IPC)|

  ```yaml
  volumeMounts:
    - name: app-config
      mountPath: /app/config
      readOnly: true
    - name: tmp                      # exceção: cache efêmero do Next.js, exigido por readOnlyRootFilesystem
      mountPath: /tmp
  volumes:
    - name: app-config
      configMap:
        name: frontend
    - name: tmp
      emptyDir:
        sizeLimit: 64Mi
  ```

- `containerPort` sempre **nomeado** (`name: http`) — é o nome que o `Service` e as probes referenciam.
- Segredos **nunca** em `Secret` versionado em git; use External Secrets Operator ou Secrets Manager CSI Driver (guardrail já existente do `devops-engineer`). Configuração não sensível vai em `ConfigMap` referenciado por `envFrom`.

---

## 8. Imagens **[projeto]**

- **A imagem é gerenciada pelo `kustomization.yaml` da app, nunca escrita no `deployment.yaml`.** O `Deployment` referencia apenas o nome lógico da app (`image: frontend`); o `kustomization.yaml` da app resolve registry, repositório e tag via transformer `images`, e injeta a label `app.kubernetes.io/version` com o mesmo valor via transformer `labels`:

  ```yaml
  # dvn-workshop-kubernetes/frontend/kustomization.yaml
  images:
    - name: frontend
      newName: <conta>.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend
      newTag: v1.0

  labels:
    - pairs:
        app.kubernetes.io/version: v1.0
      includeSelectors: false   # nunca no selector (imutável)
      includeTemplates: true    # sim no template do Pod
  ```

  Promover uma versão = `kustomize edit set image frontend=<repo>:vX.Y` (dentro de `dvn-workshop-kubernetes/frontend/`) **e** atualizar `app.kubernetes.io/version` no mesmo arquivo, no mesmo commit. O diff de um rollout fica restrito a um único arquivo por app; `deployment.yaml` só muda quando muda a spec do workload.
- `newName` sempre aponta para um dos repositórios criados por `03-ecr-stack-ai` (`<conta>.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/<frontend|backend>`), com **tag de versão explícita** em `newTag` (`v1.0`). Nunca `latest` — é a única tag mutável pelo filtro de exclusão do ECR e não permite rollback determinístico. Nunca use `digest:` no lugar de `newTag` sem também manter `newTag`, senão a label de versão perde o vínculo com a imagem.
- **A tag referenciada em `newTag` precisa existir no ECR antes do `kubectl apply`.** Gerar o manifesto não publica imagem: confira com `aws ecr describe-images --repository-name dvn-workshop/production/<app> --image-ids imageTag=<tag>` e, se faltar, o push (skill `docker-ecr-push`) vem antes do deploy. Um `apply` com tag inexistente deixa o rollout preso em `ImagePullBackOff` — e, com `maxUnavailable: 0`, as réplicas antigas continuam servindo, então o erro pode passar despercebido.
- `imagePullPolicy: IfNotPresent` (a tag é imutável no ECR, então não há motivo para `Always`).
- `newTag` e o valor de `app.kubernetes.io/version` (seção 2) são **o mesmo valor**, lado a lado no `kustomization.yaml` — atualize os dois no mesmo commit.

---

## 9. Configuração da aplicação

- Só crie `ConfigMap`/`envFrom` quando a app **lê** a configuração: verifique `process.env.*` (Node), `builder.Configuration`/`Environment.GetEnvironmentVariable` (.NET) ou equivalente antes de inventar variáveis. As duas apps atuais (`dvn-workshop-apps/`) não leem nenhuma variável de ambiente nem chamam uma à outra — por isso seus manifestos não têm `ConfigMap`. Variáveis de runtime da plataforma (`NODE_ENV`, `PORT`, `ASPNETCORE_ENVIRONMENT`, `ASPNETCORE_HTTP_PORTS`) podem ir direto em `env:` do container.

---

## 10. Namespace

- Nenhum workload no namespace `default`. Use um namespace por projeto (`dvn-workshop`) e declare-o no manifesto (`metadata.namespace`) — não dependa do contexto do `kubectl`.
- Se o workload criar o próprio namespace (`namespace.yaml`), ele leva as mesmas labels da seção 2 (exceto `app.kubernetes.io/version` e `component`).

---

## 11. Validação antes de entregar

Todo manifesto gerado passa por, no mínimo:

1. `kustomize build dvn-workshop-kubernetes/` — estrutura/Kustomize válidos (roda offline).
2. `kustomize build dvn-workshop-kubernetes/ | kubectl apply --dry-run=client -f -` — schema válido. **Atenção:** mesmo `--dry-run=client` faz discovery de API no cluster do contexto atual. Como o cluster de `02-eks-stack-ai` já foi destruído e recriado, o kubeconfig local costuma apontar para um endpoint EKS que não resolve mais (`dial tcp: lookup ...eks.amazonaws.com: no such host`); nesse caso, o erro **não é do manifesto** — rode `aws eks update-kubeconfig --region us-east-1 --name <cluster>` primeiro, ou valide offline com `kubeconform -strict` (não instalado hoje).
3. `kubectl apply --dry-run=server ...` quando houver acesso ao cluster — valida admission e `apiVersion` real.
4. Conferência manual do checklist da seção 12.

Aplicar de verdade no cluster (`kubectl apply` sem `--dry-run`) segue as mesmas regras de autorização explícita em sessão dos guardrails do `devops-engineer` — o manifesto ser válido não autoriza o deploy.

---

## 12. Checklist rápido

- [ ] `Deployment` + `Service` (`NodePort`) + `PodDisruptionBudget` gerados juntos, mesmo `name`/`namespace`/`selector`.
- [ ] 6 labels da seção 2 escritas em todos os objetos e no `template` do Pod; `app.kubernetes.io/version` só no `kustomization.yaml` (transformer `labels`, `includeSelectors: false`).
- [ ] `selector.matchLabels` usa só `app.kubernetes.io/name` + `app.kubernetes.io/instance` (nunca `version`).
- [ ] `replicas >= 2`, `RollingUpdate` com `maxUnavailable: 0`, `topologySpreadConstraints` definido.
- [ ] `Service.type: NodePort`, sem `nodePort` fixo, `targetPort` pelo nome da porta.
- [ ] PDB com `minAvailable: 1` (ou justificado no ADR), nunca igual a `replicas`.
- [ ] `readinessProbe` **e** `livenessProbe` em todo container, apontando para o endpoint do `HEALTHCHECK` do Dockerfile.
- [ ] `resources.requests`/`limits` e `securityContext` non-root em todo container, com `runAsUser` numérico igual ao usuário da imagem e `automountServiceAccountToken: false`.
- [ ] `allowPrivilegeEscalation: false` em todo container (incl. `initContainers`); sem `privileged`, `capabilities.add`, `host*` ou `runAsUser: 0`.
- [ ] Todo `volumeMounts[]` com `readOnly: true`; sem `hostPath`; único mount gravável admitido é `emptyDir` com `sizeLimit` e comentário.
- [ ] `deployment.yaml` com `image: <app>` (nome lógico); registry/repo/tag só no transformer `images` do `kustomization.yaml`, tag explícita (nunca `latest`), igual a `app.kubernetes.io/version`.
- [ ] `metadata.namespace` explícito, nunca `default`.
- [ ] Nenhum `Secret` com dados reais versionado.
- [ ] Tag de `newTag` confirmada no ECR (`aws ecr describe-images`) antes de qualquer `apply` real.
- [ ] `kustomize build` e `kubectl apply --dry-run=client` passaram (com kubeconfig apontando para o cluster atual).
