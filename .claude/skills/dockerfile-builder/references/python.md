# Python (Flask / FastAPI / Django / genérico)

## Onde procurar porta e health endpoint

- Porta: `PORT`/`--bind`/`--port` em `Procfile`, `gunicorn`/`uvicorn` command
  line, ou `app.run(port=...)`. Padrão comum: `8000` (Django/gunicorn) ou
  `8080`.
- Health endpoint: procure rota `/health`/`/healthz` (Flask: `@app.route`;
  FastAPI: `@app.get`; Django: geralmente em `urls.py` apontando pra uma view
  dedicada, ou `django-health-check` instalado). Se não achar nenhuma,
  pergunte ao usuário antes de inventar uma.

## Gerenciador de dependências

Detecte qual está em uso antes de escolher o comando de instalação:

- `requirements.txt` → `pip install --no-cache-dir -r requirements.txt`
- `pyproject.toml` + `poetry.lock` → Poetry (`poetry export` para gerar um
  `requirements.txt` no build stage, ou `poetry install --only main
  --no-root`)
- `pyproject.toml` + `uv.lock` → `uv` (mais rápido; `uv sync --frozen
  --no-dev`)

## Template (pip + requirements.txt, caso mais comum)

Use um virtualenv dentro do build stage e copie só ele para o runtime —
evita levar o compilador C e headers de dev (necessários para compilar
alguma dependência nativa) para a imagem final.

```dockerfile
FROM python:3.12-alpine AS builder
WORKDIR /app
RUN apk add --no-cache gcc musl-dev libffi-dev
COPY requirements.txt .
RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.12-alpine AS runner
WORKDIR /app
RUN addgroup -S app && adduser -S -G app app
COPY --from=builder /venv /venv
COPY . .
ENV PATH="/venv/bin:$PATH"
USER app
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8000/health || exit 1
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
```

Ajuste o `CMD` final ao framework real: `uvicorn main:app --host 0.0.0.0
--port 8000` para FastAPI, `gunicorn myproject.wsgi:application -b
0.0.0.0:8000` para Django.

## Pegadinhas

- Sempre `--no-cache-dir` no `pip install` — cache do pip não serve pra nada
  numa imagem que não vai rodar `pip install` de novo, só ocupa espaço.
- `apk add --no-cache gcc musl-dev ...` fica só no build stage; a imagem
  final não recebe compilador nenhum.
- Se alguma dependência não compila em Alpine/musl (raro, mas acontece com
  pacotes científicos como `numpy`/`pandas` em versões antigas), caia para
  `python:3.12-slim` e documente o motivo com um comentário curto.
