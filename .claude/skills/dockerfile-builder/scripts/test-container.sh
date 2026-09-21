#!/usr/bin/env bash
# Sobe um container já buildado, faz polling do endpoint de health até
# responder ou o timeout estourar, e SEMPRE para+remove o container ao sair
# (sucesso, falha ou erro) — nunca deixa container de teste órfão.
#
# Uso: test-container.sh <imagem> <porta-host> <porta-container> <health-path> [timeout-s]
set -uo pipefail

IMAGE="${1:?uso: test-container.sh <imagem> <porta-host> <porta-container> <health-path> [timeout-s]}"
HOST_PORT="${2:?porta-host obrigatoria}"
CONTAINER_PORT="${3:?porta-container obrigatoria}"
HEALTH_PATH="${4:-/}"
TIMEOUT="${5:-60}"

CONTAINER_ID=""

cleanup() {
  if [ -n "$CONTAINER_ID" ]; then
    echo "==> Parando e removendo container de teste ${CONTAINER_ID:0:12}..."
    docker stop "$CONTAINER_ID" >/dev/null 2>&1 || true
    docker rm "$CONTAINER_ID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

echo "==> Subindo container a partir de ${IMAGE}..."
CONTAINER_ID=$(docker run -d -p "${HOST_PORT}:${CONTAINER_PORT}" "$IMAGE") || exit 2

URL="http://localhost:${HOST_PORT}${HEALTH_PATH}"
echo "==> Aguardando ${URL} responder (timeout ${TIMEOUT}s)..."

elapsed=0
interval=2
while true; do
  status="$(docker inspect -f '{{.State.Running}}' "$CONTAINER_ID" 2>/dev/null || echo "false")"
  if [ "$status" != "true" ]; then
    echo "FALHA: o container saiu antes do endpoint de health responder. Logs:"
    docker logs "$CONTAINER_ID" 2>&1 || true
    exit 1
  fi

  http_code="$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$URL" 2>/dev/null)"
  curl_exit=$?
  if [ $curl_exit -ne 0 ] || [ -z "$http_code" ]; then
    http_code="000"
  fi
  if [ "$http_code" != "000" ] && [ "$http_code" -lt 500 ]; then
    echo "OK: ${URL} respondeu HTTP ${http_code} em ~${elapsed}s."
    echo "--- Status do HEALTHCHECK do Docker (se definido no Dockerfile) ---"
    docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}(sem HEALTHCHECK definido na imagem){{end}}' "$CONTAINER_ID" 2>/dev/null || true
    exit 0
  fi

  if [ "$elapsed" -ge "$TIMEOUT" ]; then
    echo "FALHA: timeout de ${TIMEOUT}s aguardando ${URL} responder (ultimo status: ${http_code}). Logs:"
    docker logs "$CONTAINER_ID" 2>&1 || true
    exit 1
  fi

  sleep "$interval"
  elapsed=$((elapsed + interval))
done
