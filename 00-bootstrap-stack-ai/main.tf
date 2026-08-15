############################################################################
# main.tf
#
# Ponto de entrada da stack 00-bootstrap-stack-ai (ADR-0002).
#
# Esta stack nao usa blocos `module` (ADR-0002 Secao 4, Opcao A / Secao 6.3)
# — todos os recursos sao nativos do provider hashicorp/aws, organizados em
# arquivos por dominio (regra .claude/rules/terraform-naming-conventions.md,
# Secao 2). Este arquivo nao declara recursos; serve apenas como indice de
# onde cada dominio esta implementado:
#
#   versions.tf                          -> Terraform CLI + provider
#                                            hashicorp/aws.
#   override.tf                          -> backend LOCAL PERMANENTE
#                                            (gitignored). Nenhum backend.tf
#                                            com bloco `backend "s3"` existe
#                                            nesta stack — decisao D3 do ADR,
#                                            evita autorreferencia.
#   providers.tf                         -> provider "aws" + default_tags.
#   variables.tf                         -> variaveis de input (sem default).
#   data.tf                              -> data source de Account ID.
#   locals.tf                            -> naming, nome do bucket, tags
#                                            comuns.
#   state-bucket.tf                      -> aws_s3_bucket + ownership
#                                            controls (BucketOwnerEnforced).
#   state-bucket.versioning.tf           -> aws_s3_bucket_versioning.
#   state-bucket.encryption.tf           -> criptografia padrao SSE-S3
#                                            (AES256).
#   state-bucket.public-access-block.tf  -> bloqueio total de acesso
#                                            publico.
#   state-bucket.policy.tf               -> bucket policy (deny sem TLS,
#                                            deny PUT sem SSE, deny fora da
#                                            conta).
#   state-bucket.lifecycle.tf            -> expiracao de versoes antigas +
#                                            abort de multipart upload
#                                            incompleto.
#   outputs.tf                           -> outputs consumidos por stacks
#                                            consumidoras (01-, futuras).
############################################################################
