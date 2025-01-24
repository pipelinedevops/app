data "aws_vpc" "selected" {
  #id = var.vpc_id #filtro se houver
}


data "aws_subnets" "endpoint-us-east-1a" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1a"] # insert values here
  }
}

data "aws_subnets" "endpoint-us-east-1b" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1b"] # insert values here
  }
}

data "aws_subnets" "endpoint-us-east-1c" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1c"] # insert values here
  }
}


data "aws_ecr_image" "service_image" {
  repository_name = var.reponame #"my/service"
  image_tag       = var.imagetag  #"latest"
}

data "aws_caller_identity" "current" {}
