data "aws_ecr_image" "service_image" {
  repository_name = var.reponame #"my/service"
  image_tag       = var.tag #"latest"
}

data "aws_caller_identity" "current" {}
