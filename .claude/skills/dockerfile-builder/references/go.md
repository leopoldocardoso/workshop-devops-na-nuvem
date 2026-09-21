# Go

## Onde procurar porta e health endpoint

- Porta: argumento de `http.ListenAndServe(":XXXX", ...)` ou variável de
  ambiente lida no `main.go` (`os.Getenv("PORT")`).
- Health endpoint: procure `http.HandleFunc("/health", ...)` ou rota
  equivalente no router usado (`chi`, `gin`, `echo`, `gorilla/mux`). Go tem
  poucas convenções universais aqui — se não achar, pergunte.

## Template

Go compila para um binário estático, então a imagem final pode ser
`scratch` ou `alpine` — `alpine` é preferível por padrão porque traz um
shell e `wget` (útil para o HEALTHCHECK e para debug com `docker exec`);
`scratch` é menor ainda mas exige `CMD` no formato exec e nenhum jeito de
rodar HEALTHCHECK via shell (só binário nativo), então normalmente não vale
a troca a menos que o usuário peça o menor tamanho possível.

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server .

FROM alpine:3.19 AS runner
WORKDIR /app
RUN apk add --no-cache ca-certificates && \
    addgroup -S app && adduser -S -G app app
COPY --from=builder /app/server .
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1
CMD ["./server"]
```

## Pegadinhas

- `CGO_ENABLED=0` é o que garante um binário estático que roda em Alpine sem
  depender de `glibc`. Se a app usa cgo de verdade (ex.: `sqlite3` via
  `mattn/go-sqlite3`), não dá pra desligar CGO — nesse caso use
  `golang:1.22-alpine` também como runtime (mantendo `musl`) em vez de
  `alpine:3.19` puro, ou troque para `-slim`/Debian se a dependência exigir
  `glibc`.
- `ca-certificates` é necessário no runtime se a app faz chamadas HTTPS de
  saída (client TLS) — Alpine puro não vem com certificados CA.
- `-ldflags="-s -w"` remove símbolos de debug do binário, reduzindo tamanho;
  não afeta o comportamento em produção.
