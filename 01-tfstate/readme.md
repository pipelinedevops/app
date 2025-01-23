# Infrastructure as Code (IaC) - AWS Services

Este repositório contém as configurações de Terraform para gerenciar a infraestrutura AWS para serviços como AWS Glue, AWS Step Functions, e AWS EventBridge, entre outros, utilizando as melhores práticas de automação com GitHub Actions.

## Estrutura do Repositório

A estrutura do repositório é organizada por serviço e ambiente, facilitando a gestão e a escalabilidade das configurações:

```
/terraform
  /01-tfstate #root
    /tfstate-bucket #configurações do modulo  
```


objetivo:

cria bucket para state
criar chave kms para criptografia
criar dynamodb

#executar a primeira vez localmente propria estação

-atualizando o state: 
terraform init

terraform apply -refresh-only -auto-approve