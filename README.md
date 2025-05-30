# Infrastructure as Code (IaC) - AWS Services

Este repositório contém as configurações de Terraform para gerenciar a infraestrutura AWS para serviços AWs, utilizando as melhores práticas de automação com GitHub Actions.

## Estrutura do Repositório


```
/01-tfstate #Recursos para o blackend da esteira (s3 / dynamodb etc..)
    /tfstate-bucket #configurações do modulo  
/02-repo    #Recursos relativo ao repositório do ecr
/03-image   #Estrutura para gerar a imagem docker
    /src
    /observability
/04-ecs     #Recursos  para implantar o ecs bem como a comunicação necessária para funcionar (excluindo a vpc)
/environments #variaveis de ambiente para utilizar na esteira

```
# app

Para configurar o pipeline em questão é necessário:

1- fazer clone do repositorio

2- fazer login na aws

3- criar user iam para a pipeline com administrator acess na conta aws

3- configurar as variaveis secrets no repositorio conforme o ambiente desejado conforme o arquivo .github/workflows/ecr.yml

para prd são esses

secrets.TF_AWS_LAB_ID

secrets.TF_AWS_LAB_KEY

4- configurar a variavel de região desejada no arquivo .github/workflows/ecr.yml

5- configurar as variaveis de ambiente para a criação do repositorio/image name do ecr no arquivo .github/workflows/ecr.yml
no momento são esses:

repo_name: labchallenge  #nome do repositorio
image_name: app #nome da imagem
tag_name: v0.2  #tag name 

6- abrir a pasta 01-tfstate

7 -  fazer login na aws

8- executar as intruções conforme o topico no arquivo readme  #primeiro deploy


9- ajustar o blackends definidos nos arquivos"/environments/blackend-prd-xxx.tfvars" que foi criado no passo parte2/01-tfstate

10- ajustar os arquivos /environments/prd-xx.tfvars conforme comentado em cada um dos arquivos

11 - fazer push para executar as pipelines (na primeira execução)

obs: a primeira exeução apenas o repositorio vai ser criado com seus requisitos, na segunda os recursos do ecs devem  ser criados com sucesso

Solução:


-Por escolha de arquitetura / custo foi criado um ambiente usando subnet publica e fargate para não usar nat/vpc endpoint oque tornaria mais caro criar/manter o ambiente

-Foi escrito um ambiente iac pensando em um padrão de organização. mas, é possivel usar em outros tipos de ambiente

-Para monitoramento foi usado cloudwach habilitado junto ao ecs para os containers e logs


terraform init -reconfigure -backend-config=../environments/blackend-prd-01.tfvars
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file=../environments/prd-01.tfvars
terraform apply -auto-approve -lock=false -parallelism=10  -var-file=../environments/prd-01.tfvars
