# Site estático (HTML/CSS/JS puro, sem framework de servidor)

Use quando a pasta não tiver nenhum marcador de linguagem de backend
(sem `package.json` com script de servidor, sem `.csproj`, `go.mod`,
`requirements.txt`, `pom.xml`) — só arquivos já prontos para servir
(`index.html` na raiz, ou um `dist/`/`build/` já gerado por um processo
externo ao Dockerfile).

## Onde procurar porta e health endpoint

- Porta: sempre `80` (padrão nginx) a menos que o usuário peça outra.
- Health endpoint: sites estáticos normalmente não têm rota de health
  dedicada — o teste de "está de pé" é servir qualquer arquivo estático real
  (ex.: a própria `index.html` ou um arquivo dummy `healthz.txt`). Não
  invente um endpoint dinâmico que o nginx não consegue servir sem config
  extra.

## Template

nginx não roda como root de forma nativa nas imagens padrão, mas a
distribuição oficial tem uma variante `nginx-unprivileged` mantida
justamente para isso — prefira ela a montar um `nginx.conf` customizado do
zero para rodar em porta baixa como non-root.

```dockerfile
FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY --chown=nginx:nginx . /usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/index.html || exit 1
```

Não é preciso `USER` explícito — a imagem `nginx-unprivileged` já roda como
usuário non-root por padrão e já escuta em `8080` (não `80`, que é porta
privilegiada).

## Pegadinhas

- Se a pasta tiver um passo de build separado (ex.: um site gerado por
  Hugo/Jekyll/Vite fora deste fluxo), o Dockerfile só deve empacotar o
  resultado já buildado — não tente reimplementar o pipeline de build
  estático dentro do Dockerfile a menos que o usuário peça.
- Confirme que não sobra nenhum arquivo sensível (`.env`, chaves, arquivos
  de config de build) na pasta antes de copiar tudo para dentro da imagem —
  gere/edite o `.dockerignore` para excluir isso.
