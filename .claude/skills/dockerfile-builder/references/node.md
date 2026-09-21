# Node.js / Next.js

## Onde procurar porta e health endpoint

- Porta: variável `PORT` em `.env`/`docker-compose.yml`, ou o argumento de
  `app.listen(...)`/`server.listen(...)` no código, ou `-p` no script
  `start` do `package.json`. Next.js usa `3000` por padrão.
- Health endpoint: procure uma rota literal `health`/`healthz` (Express:
  `app.get('/health', ...)`; Next.js App Router:
  `app/api/health/route.(js|ts)`; Next.js Pages Router:
  `pages/api/health.(js|ts)`). Se não existir nenhuma, pergunte ao usuário
  se quer que uma rota mínima seja criada (retornando 200) — sem isso o
  HEALTHCHECK não tem o que testar.

## Next.js com `output: 'standalone'`

Confira `next.config.mjs`/`next.config.js` por `output: 'standalone'`. Esse
modo gera um `server.js` autocontido em `.next/standalone` com só as
dependências realmente usadas em runtime — é o que permite a imagem final
não carregar `node_modules` inteiro. Se a config não tiver `output:
'standalone'`, ou adicione essa linha (confirme com o usuário — é uma
mudança no app, não só no Dockerfile) ou caia para o template "Node.js
genérico" abaixo.

```dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# a imagem oficial node:alpine já traz o usuário non-root "node" (uid 1000)
COPY --from=builder /app/public ./public
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1
CMD ["node", "server.js"]
```

## Node.js genérico (Express/Fastify/etc., sem `output: standalone`)

Instale só dependências de produção na imagem final (`npm ci --omit=dev`) —
nunca copie o `node_modules` completo da build stage se ela também instalou
devDependencies para rodar build/testes.

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]
```

## Pegadinhas

- Se a app usa bindings nativos (ex.: `sharp`, `bcrypt` compilado) e falha em
  Alpine por causa do `musl`, use `node:20-slim` (Debian) em vez de forçar
  Alpine — documente com um comentário curto o motivo.
- `npm ci`, nunca `npm install`, em build reprodutível — exige
  `package-lock.json` versionado.
