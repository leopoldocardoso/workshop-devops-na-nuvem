# Java (Maven/Gradle, Spring Boot)

## Onde procurar porta e health endpoint

- Porta: `server.port` em `application.properties`/`application.yml`.
  Padrão Spring Boot: `8080`.
- Health endpoint: se `spring-boot-starter-actuator` estiver nas
  dependências (`pom.xml`/`build.gradle`), o endpoint é
  `/actuator/health` por padrão (confira se
  `management.endpoints.web.exposure.include` inclui `health` — em algumas
  configs vem restrito). Sem Actuator, procure um `@RestController` com uma
  rota `/health` manual; se não achar nenhuma, pergunte.

## Template (Maven, Spring Boot)

Use `dependency:go-offline`/`mvn package` no build stage com o wrapper do
projeto (`./mvnw`) quando existir, para não depender de uma versão de Maven
instalada fora do container.

```dockerfile
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app
RUN addgroup -S app && adduser -S -G app app
COPY --from=builder /app/target/*.jar app.jar
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Para Gradle, troque o build stage por `gradle:8-jdk21-alpine` com `./gradlew
build -x test` e ajuste o `COPY` do jar para
`build/libs/*.jar`.

## Pegadinhas

- `eclipse-temurin:*-jre-alpine` (só JRE) no runtime, nunca `*-jdk-alpine` —
  o JDK completo (compilador, ferramentas de build) só é necessário no
  build stage.
- `--start-period` maior aqui (20s+) porque a JVM tem cold start mais lento
  que runtimes interpretados — um `--start-period` curto faz o Docker
  marcar o container como unhealthy antes da JVM sequer terminar de subir.
- `-DskipTests`/`-x test` no build de imagem: testes já devem ter rodado no
  CI antes do build da imagem; rodar de novo aqui só deixa o build mais
  lento sem ganho.
