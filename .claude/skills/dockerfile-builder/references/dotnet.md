# .NET (ASP.NET Core)

## Onde procurar porta e health endpoint

- Porta: ASP.NET Core em container escuta em `8080` por padrão (imagens
  `mcr.microsoft.com/dotnet/aspnet` 8.0+ setam `ASPNETCORE_HTTP_PORTS=8080`
  automaticamente) — não use `5000`/`5001` (esses são os defaults de
  `dotnet run` fora de container). Confirme lendo `Program.cs`/
  `appsettings.json` por um `ASPNETCORE_URLS`/`UseUrls` explícito que
  sobrescreva isso.
- Health endpoint: procure `AddHealthChecks()` + `MapHealthChecks("/algum
  path")` em `Program.cs`. **Atenção**: se o `MapHealthChecks` estiver
  dentro de um `app.Map("/prefixo", ...)` (branch de sub-aplicação), o path
  real do health check é `/prefixo` + o path passado a `MapHealthChecks`,
  não só o path passado a `MapHealthChecks` isoladamente — leia o Program.cs
  inteiro, não só a linha do `MapHealthChecks`, para montar a URL correta.
  Sem `AddHealthChecks()`/`MapHealthChecks` no código, pergunte ao usuário
  antes de assumir um path.

## Template

O SDK do .NET não tem imagem Alpine tão leve quanto o runtime, mas o
runtime (`aspnet`) tem — o ganho de tamanho do multi-stage aqui é grande.
Desde o .NET 8, a imagem `aspnet` traz um usuário non-root pronto (`app`,
uid exposto pelo build arg `$APP_UID`); não precisa criar usuário na mão.

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS builder
WORKDIR /src
COPY *.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runner
WORKDIR /app
COPY --from=builder /app .
USER $APP_UID
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1
ENTRYPOINT ["dotnet", "NomeDoAssembly.dll"]
```

Troque `NomeDoAssembly.dll` pelo nome do `.csproj` (sem extensão) — é o nome
do assembly gerado pelo `dotnet publish`. Se houver mais de um `.csproj` na
pasta (solução com múltiplos projetos), o `COPY *.csproj .` /
`dotnet restore` precisam apontar para o projeto web específico
(`ProjetoWeb/ProjetoWeb.csproj`), não para a pasta inteira — confirme com o
usuário qual projeto é o entrypoint HTTP.

## Pegadinhas

- `wget` já vem por padrão nas imagens Alpine (via BusyBox), inclusive nas
  `dotnet/aspnet:*-alpine` — não precisa de `apk add` extra para o
  HEALTHCHECK funcionar.
- `USER $APP_UID` só funciona porque a imagem base `aspnet` alpine já
  declara esse `ARG`/usuário — não tente reusar esse padrão em uma imagem
  Alpine genérica sem criar o usuário manualmente primeiro.
- Se o app precisar gravar em disco em runtime (logs, uploads), garanta que
  o diretório de destino tem permissão de escrita para o usuário non-root
  (`RUN mkdir -p /app/data && chown $APP_UID /app/data` antes do `USER`).
