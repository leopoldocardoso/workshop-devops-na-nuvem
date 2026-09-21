#!/usr/bin/env bash
# Builda e faz push de uma ou mais imagens Docker para o Amazon ECR, a
# partir SOMENTE da URI completa de destino de cada imagem. A pasta local
# a buildar e descoberta pelo ultimo segmento do path do repositorio ECR
# (ex.: ".../dvn-workshop/production/frontend" -> dvn-workshop-apps/frontend/).
#
# Uso: build-and-push.sh <uri-ecr> [<uri-ecr> ...]
# Cada <uri-ecr> no formato: <conta>.dkr.ecr.<regiao>.amazonaws.com/<repo>[:<tag>]
# (":<tag>" e opcional, default "latest").
set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "uso: build-and-push.sh <uri-ecr> [<uri-ecr> ...]" >&2
  exit 2
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "FALHA: docker CLI nao encontrado neste ambiente." >&2
  exit 2
fi
if ! command -v aws >/dev/null 2>&1; then
  echo "FALHA: aws CLI nao encontrado neste ambiente (necessario para autenticar no ECR)." >&2
  exit 2
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
APPS_ROOT="${REPO_ROOT}/dvn-workshop-apps"

declare -A LOGGED_IN_REGISTRIES
OVERALL_EXIT=0

for URI in "$@"; do
  echo "=================================================================="
  echo "==> Processando ${URI}"

  REGISTRY="${URI%%/*}"
  REST="${URI#*/}"
  if [[ "$REST" == *:* ]]; then
    REPO_PATH="${REST%:*}"
    TAG="${REST##*:}"
  else
    REPO_PATH="$REST"
    TAG="latest"
    URI="${URI}:${TAG}"
  fi
  LAST_SEGMENT="${REPO_PATH##*/}"

  REGION="$(printf '%s' "$REGISTRY" | sed -n 's/.*\.dkr\.ecr\.\([a-z0-9-]*\)\.amazonaws\.com$/\1/p')"
  if [ -z "$REGION" ]; then
    echo "FALHA (${URI}): nao consegui extrair a regiao de '${REGISTRY}' (esperado <conta>.dkr.ecr.<regiao>.amazonaws.com)." >&2
    OVERALL_EXIT=1
    continue
  fi

  echo "==> Resolvendo pasta local para o repositorio '${REPO_PATH}' (segmento '${LAST_SEGMENT}')..."
  if [ ! -d "${APPS_ROOT}/${LAST_SEGMENT}" ]; then
    echo "FALHA (${URI}): pasta ${APPS_ROOT}/${LAST_SEGMENT}/ nao existe." >&2
    OVERALL_EXIT=1
    continue
  fi

  MATCHES=()
  while IFS= read -r -d '' dockerfile; do
    MATCHES+=("$(dirname "$dockerfile")")
  done < <(find "${APPS_ROOT}/${LAST_SEGMENT}" -mindepth 2 -maxdepth 2 -iname Dockerfile -print0 2>/dev/null)

  if [ "${#MATCHES[@]}" -eq 0 ]; then
    echo "FALHA (${URI}): nenhum Dockerfile encontrado em ${APPS_ROOT}/${LAST_SEGMENT}/*/Dockerfile. Rode a skill dockerfile-builder nessa app primeiro." >&2
    OVERALL_EXIT=1
    continue
  fi
  if [ "${#MATCHES[@]}" -gt 1 ]; then
    echo "FALHA (${URI}): mais de uma pasta com Dockerfile em ${APPS_ROOT}/${LAST_SEGMENT}/ (${MATCHES[*]}) - ambiguo, nao vou adivinhar qual buildar." >&2
    OVERALL_EXIT=1
    continue
  fi
  APP_DIR="${MATCHES[0]}"
  echo "    -> ${APP_DIR}"

  if [ -z "${LOGGED_IN_REGISTRIES[$REGISTRY]:-}" ]; then
    echo "==> Autenticando no ECR (${REGISTRY}, regiao ${REGION})..."
    if ! aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY" >/dev/null 2>&1; then
      echo "FALHA (${URI}): login no ECR falhou (verifique credenciais AWS e permissao ecr:GetAuthorizationToken)." >&2
      OVERALL_EXIT=1
      continue
    fi
    LOGGED_IN_REGISTRIES[$REGISTRY]=1
  fi

  echo "==> docker build --platform linux/amd64 -t ${URI} ${APP_DIR}"
  if ! docker build --platform linux/amd64 -t "$URI" "$APP_DIR"; then
    echo "FALHA (${URI}): docker build falhou (ver log acima)." >&2
    OVERALL_EXIT=1
    continue
  fi

  echo "==> docker push ${URI}"
  if ! docker push "$URI"; then
    echo "FALHA (${URI}): docker push falhou. Se o erro for 'repository does not exist', o repositorio ECR ainda nao foi criado via Terraform (esta skill nunca cria repositorios) - rode a stack correspondente primeiro." >&2
    OVERALL_EXIT=1
    continue
  fi

  DIGEST="$(aws ecr describe-images --region "$REGION" --repository-name "$REPO_PATH" --image-ids imageTag="$TAG" --query 'imageDetails[0].imageDigest' --output text 2>/dev/null)"
  SIZE="$(docker images "$URI" --format '{{.Size}}')"
  echo "OK: ${URI}"
  echo "    tamanho local: ${SIZE}"
  echo "    digest confirmado no ECR: ${DIGEST:-<nao confirmado>}"
done

echo "=================================================================="
exit $OVERALL_EXIT
