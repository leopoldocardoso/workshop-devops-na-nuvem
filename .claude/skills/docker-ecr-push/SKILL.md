---
name: docker-ecr-push
description: Builda e faz push de imagens Docker para o Amazon ECR neste repo, recebendo apenas a URI completa de destino de cada imagem (uma ou várias de uma vez) — sem precisar informar a pasta local, que é descoberta automaticamente. Use sempre que o usuário pedir para "buildar e enviar pro ECR", "publicar a imagem no registry", "fazer push da imagem", colar uma ou mais URIs de imagem ECR (formato `<conta>.dkr.ecr.<região>.amazonaws.com/<repo>[:<tag>]`), ou pedir para preparar as imagens de frontend/backend antes de um deploy no EKS — mesmo que não mencionem "Docker" ou "ECR" explicitamente, só o destino. Não cria repositórios ECR (isso é IaC/Terraform, fora do escopo desta skill) — assume que já existem.
---

# docker-ecr-push

Builda a imagem Docker de uma app já existente neste repo e publica no Amazon
ECR, usando só a URI final de destino como input. Não pede a pasta local —
descobre sozinha.

## Input esperado

Uma ou mais URIs completas de imagem ECR, no formato:

```
<conta>.dkr.ecr.<região>.amazonaws.com/<repositório>[:<tag>]
```

Exemplos (padrão deste repo, ver `docs/adr/ADR-0004-ecr-stack.md`):

```
659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend:v1
659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend:v1
```

Se `:<tag>` for omitido, usa `latest`.

## Como a pasta local é descoberta

O **último segmento do path do repositório** ECR (ex.: `frontend` em
`dvn-workshop/production/frontend`) é usado para procurar em
`dvn-workshop-apps/<último-segmento>/*/Dockerfile`. Isso funciona porque a
convenção deste repo já organiza as apps assim:

```
dvn-workshop-apps/
├── backend/YoutubeLiveApp/Dockerfile
└── frontend/youtube-live-app/Dockerfile
```

Ou seja, `.../dvn-workshop/production/frontend` → builda
`dvn-workshop-apps/frontend/youtube-live-app/`. Se essa pasta não existir,
não tiver Dockerfile, ou tiver mais de uma subpasta com Dockerfile (ambíguo),
o script falha explicitamente para aquela URI em vez de adivinhar — quando
isso acontecer, pergunte ao usuário qual pasta é a correta ou rode a skill
`dockerfile-builder` na app antes.

## Fluxo de trabalho

1. **Confirme que os repositórios ECR de destino já existem** antes de
   chamar o script — esta skill nunca cria repositório ECR (isso é decisão
   de infraestrutura registrada em ADR e implementada via Terraform, não
   ClickOps/CLI ad-hoc). Se o `docker push` falhar com "repository does not
   exist", é exatamente esse o motivo — não tente contornar criando o
   repositório você mesmo; aponte o usuário para a stack/ADR responsável.

2. **Rode o script** com uma ou mais URIs (uma chamada só cobre todas):

   ```bash
   .claude/skills/docker-ecr-push/scripts/build-and-push.sh \
     659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend:v1 \
     659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend:v1
   ```

   Para cada URI, o script:
   - extrai a região do próprio registry (`<conta>.dkr.ecr.<região>.amazonaws.com`) — não precisa de flag de região separada;
   - autentica no ECR uma única vez por registry (`aws ecr get-login-password | docker login`), mesmo que várias URIs usem o mesmo registry;
   - builda com `docker build --platform linux/amd64` (mesma garantia de arquitetura usada nos Dockerfiles deste repo — EKS roda em `t3.medium`/x86_64);
   - faz `docker push`;
   - confirma o digest publicado via `aws ecr describe-images` (não confia só no exit code do push).

3. **Leia a saída linha a linha** — o script processa todas as URIs mesmo se uma falhar (não para no primeiro erro), e reporta `OK`/`FALHA` por URI no final. Exit code não-zero só se pelo menos uma URI falhou.

4. **Reporte ao usuário**: para cada imagem, sucesso/falha, tamanho da imagem, e o digest confirmado no ECR (ou o motivo da falha, sem tentar mascarar ou contornar).

## Pré-requisitos

- `docker` e `aws` CLI disponíveis no ambiente (o script verifica e falha
  explicitamente, sem fingir sucesso, se algum estiver ausente).
- Credenciais AWS configuradas com permissão de `ecr:GetAuthorizationToken`,
  `ecr:BatchCheckLayerAvailability`, `ecr:PutImage`, `ecr:InitiateLayerUpload`,
  `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload` no(s) repositório(s) alvo.
- O Dockerfile da app já deve existir e buildar com sucesso (use a skill
  `dockerfile-builder` primeiro se ainda não existir).
