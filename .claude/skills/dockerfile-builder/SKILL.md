---
name: dockerfile-builder
description: >
  Gera um Dockerfile de produção para uma aplicação já existente numa pasta
  deste repo, a partir da análise automática da linguagem/framework contido
  nela. Use sempre que o usuário pedir para "criar um Dockerfile", "dockerizar"
  ou "containerizar" uma app/serviço, revisar/otimizar um Dockerfile existente,
  ou apontar para uma pasta como dvn-workshop-apps/backend/... ou
  dvn-workshop-apps/frontend/... pedindo para "buildar imagem" — mesmo que não
  mencionem explicitamente "boas práticas" ou "multi-stage". Produz builds
  multi-stage, imagem final Alpine (ou equivalente mínima quando Alpine não
  servir), usuário non-root/rootless, HEALTHCHECK, e — quando o Docker CLI
  estiver disponível no ambiente — builda a imagem, sobe o container, testa o
  endpoint de health de verdade e derruba o container automaticamente ao final
  (sucesso ou falha), sem deixar containers órfãos.
---

# dockerfile-builder

Gera Dockerfiles enxutos e seguros para apps deste repo (ou de qualquer pasta
que o usuário apontar), e valida o resultado subindo o container de verdade.

## Fluxo de trabalho

1. **Receber a pasta da app.** É o único input obrigatório. Porta e endpoint
   de health são opcionais — se não vierem, tente inferir (passo 3); se não
   conseguir com confiança, pergunte em vez de adivinhar (ver "Quando
   perguntar" abaixo).

2. **Detectar linguagem/framework** pelos arquivos-marcadores na raiz da
   pasta (ou no primeiro nível abaixo dela, se a raiz só tiver `src/`):

   | Marcador                                   | Linguagem/framework      | Referência                    |
   |---------------------------------------------|---------------------------|--------------------------------|
   | `package.json` com dep `next`                | Next.js                   | `references/node.md`           |
   | `package.json` (sem `next`)                  | Node.js genérico           | `references/node.md`           |
   | `requirements.txt` / `pyproject.toml`        | Python                    | `references/python.md`         |
   | `go.mod`                                     | Go                        | `references/go.md`             |
   | `pom.xml` / `build.gradle(.kts)`             | Java (Maven/Gradle)       | `references/java.md`           |
   | `*.csproj` / `*.sln`                         | .NET                      | `references/dotnet.md`         |
   | só HTML/CSS/JS estático, sem os acima        | site estático             | `references/static-nginx.md`   |

   Se houver mais de um marcador na mesma pasta (monorepo/múltiplos
   serviços), não escolha sozinho — pergunte qual pasta/serviço é o alvo.

3. **Detectar entrypoint, porta e endpoint de health** lendo o código-fonte,
   não só o nome do framework — cada `references/<lang>.md` explica onde
   procurar (ex.: `.NET` → `MapHealthChecks(...)` em `Program.cs`; Node/Next
   → uma rota `api/health` ou similar; Spring Boot → Actuator
   `/actuator/health`). Isso importa porque o HEALTHCHECK do Dockerfile e o
   teste do passo 6 dependem de acertar essa porta/rota — um valor chutado
   quebra o teste silenciosamente (o container sobe, mas o healthcheck nunca
   fecha).

4. **Escrever o Dockerfile** na raiz da pasta da app, seguindo o template da
   referência da linguagem detectada e os princípios da seção abaixo. Se não
   existir `.dockerignore` na pasta, crie um também (evita copiar
   `node_modules`, `.git`, `bin/obj`, `__pycache__`, `.env`, etc. para dentro
   do contexto de build).

5. **Não sobrescreva um Dockerfile existente sem avisar.** Se já houver um
   Dockerfile na pasta, mostre o diff proposto e confirme antes de substituir
   — pode ter sido escrito à mão por um motivo que a análise automática não
   capturou.

6. **Testar de verdade, se o Docker CLI estiver disponível** (`command -v
   docker`). Buildar sem testar deixa passar Dockerfiles que "parecem certos"
   mas falham no primeiro `docker run` (porta errada, usuário sem permissão
   de escrita onde o app precisa escrever, healthcheck apontando pro path
   errado). Passos:

   ```bash
   docker build -t <tag-temporaria> <pasta-da-app>
   .claude/skills/dockerfile-builder/scripts/test-container.sh \
     <tag-temporaria> <porta-host> <porta-container> <health-path> [timeout-s]
   ```

   O script sobe o container, espera o health endpoint responder (ou o
   timeout estourar), reporta o resultado e **sempre** para e remove o
   container ao final — inclusive em caso de falha ou erro do script (usa
   `trap ... EXIT`), então nunca fica container de teste esquecido rodando.
   Se o teste falhar, leia os logs impressos pelo script, ajuste o Dockerfile
   e repita — não reporte sucesso sem essa etapa ter passado.

   Se o Docker CLI não estiver disponível no ambiente, diga isso
   explicitamente ao usuário em vez de alegar que testou.

7. **Reportar ao usuário**: caminho do Dockerfile gerado, tamanho da imagem
   final (`docker images <tag> --format '{{.Size}}'`), e o resultado do teste
   de health (passou/falhou, com o motivo se falhou).

## Princípios de imagem pequena e segura (valem para toda linguagem)

- **Multi-stage sempre**: um stage de build (SDK/toolchain completo) e um
  stage final de runtime que só recebe os artefatos compilados/instalados —
  nunca o toolchain de build vai para a imagem final.
- **Base Alpine por padrão** (`node:XX-alpine`, `python:X.Y-alpine`,
  `golang:X.Y-alpine`, `eclipse-temurin:XX-jre-alpine`,
  `mcr.microsoft.com/dotnet/aspnet:X.0-alpine`). Alpine usa `musl` em vez de
  `glibc` — se uma dependência nativa da app exigir `glibc` (raro, mas
  acontece com algumas libs Python/Node com bindings C), documente isso no
  Dockerfile com um comentário curto e caia para a variante `-slim`
  (Debian) em vez de forçar Alpine.
- **Sempre fixe a versão da imagem base** (`node:20-alpine`, nunca
  `node:alpine` ou `node:latest`) — reprodutibilidade de build.
- **Non-root / rootless**: use o usuário non-root já embutido na imagem
  oficial quando existir (`node` no `node:alpine`, `USER $APP_UID` nas
  imagens `aspnet` do .NET 8+), ou crie um (`addgroup -S app && adduser -S
  -G app app` em Alpine) quando a imagem base rodar como root por padrão
  (`nginx`, `python`, `golang` runtime scratch/distroless). O `USER` deve
  ser a última coisa antes do `CMD`/`ENTRYPOINT`.
- **Copie só o necessário** da build stage para a runtime stage — nunca
  `COPY . .` da build stage inteira; copie artefato por artefato
  (`--from=builder /app/dist ./dist`, etc.) para não vazar código-fonte,
  cache de package manager ou dependências de build para a imagem final.
- **HEALTHCHECK sempre presente**, testando o endpoint de health real da
  app (não `CMD true`, que sempre "passa" e não verifica nada). Alpine já
  traz `wget` via BusyBox — prefira `wget --spider` a instalar `curl` extra,
  a menos que a app já precise de `curl` em runtime por outro motivo.
- **Ordene os `COPY`/`RUN` para aproveitar cache**: copie primeiro os
  arquivos de manifesto de dependências (`package.json`+lock,
  `requirements.txt`, `go.mod`+`go.sum`, `*.csproj`) e rode o
  install/restore antes de copiar o resto do código-fonte — isso evita
  reinstalar dependências a cada mudança de código.
- **`.dockerignore`** cobrindo `.git`, artefatos de build locais
  (`node_modules`, `bin/`, `obj/`, `__pycache__/`, `.venv/`, `dist/` quando
  gerado dentro do container), segredos (`.env*`) e arquivos de IDE.

## Quando perguntar em vez de assumir

- Porta de escuta ou endpoint de health não aparecem em nenhum arquivo
  (nem config, nem código) — chutar aqui faz o healthcheck falhar de forma
  enganosa (parece bug no Dockerfile, mas é só o path errado).
- Mais de um serviço/linguagem na mesma pasta apontada.
- A app claramente precisa de estado persistente em runtime (grava arquivo,
  precisa de volume) — isso muda o `USER`/permissões de diretório e vale
  confirmar antes de travar tudo como somente-leitura.
- Já existe um Dockerfile na pasta — confirme antes de sobrescrever
  (passo 5).

Fora esses casos, prossiga com os defaults descritos acima sem parar para
confirmar cada detalhe — a maior parte de uma app comum (porta declarada em
config, health endpoint padrão do framework) dá pra inferir com segurança.

## Referências por linguagem

Leia a referência correspondente antes de escrever o Dockerfile — cada uma
tem o template completo (build stage + runtime stage), onde procurar
porta/health endpoint nessa linguagem, e as pegadinhas específicas dela.

- `references/node.md` — Node.js genérico e Next.js (`output: standalone`)
- `references/python.md` — Python (pip/poetry, Flask/FastAPI/Django)
- `references/go.md` — Go (binário estático, runtime `scratch`/`distroless`)
- `references/java.md` — Java (Maven/Gradle, Spring Boot)
- `references/dotnet.md` — .NET (ASP.NET Core)
- `references/static-nginx.md` — site estático servido por `nginx`

## Script de teste

`scripts/test-container.sh <imagem> <porta-host> <porta-container>
<health-path> [timeout-s=60]` — builda não é responsabilidade do script (isso
fica no passo 6 acima); o script só sobe o container já buildado, faz polling
do health endpoint até responder 2xx/3xx ou o timeout estourar, imprime os
logs do container em caso de falha, e sempre limpa (`docker stop` + `docker
rm`) ao sair, com ou sem sucesso.
