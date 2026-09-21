FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:8.0-alpine AS builder
WORKDIR /src
COPY *.csproj .
RUN dotnet restore -r linux-x64
COPY . .
RUN dotnet publish -c Release -o /app --no-restore -r linux-x64 --self-contained false

FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runner
WORKDIR /app
COPY --from=builder /app .
USER $APP_UID
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/backend/health || exit 1
ENTRYPOINT ["dotnet", "YoutubeLiveApp.dll"]
