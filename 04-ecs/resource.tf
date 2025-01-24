
#modelo nat gw
resource "aws_nat_gateway" "us-east-1a" {
  connectivity_type = "private"
  subnet_id         = data.aws_subnets.endpoint-us-east-1a.ids[0]
  #secondary_private_ip_address_count = 1
  tags = var.tags
}

resource "aws_nat_gateway" "us-east-1b" {
  connectivity_type = "private"
  subnet_id         = data.aws_subnets.endpoint-us-east-1b.ids[0]
  #secondary_private_ip_address_count = 1
  tags = var.tags
}

resource "aws_nat_gateway" "us-east-1c" {
  connectivity_type = "private"
  subnet_id         = data.aws_subnets.endpoint-us-east-1c.ids[0]
  #secondary_private_ip_address_count = 1
  tags = var.tags
}


  resource "aws_security_group" "vpc_acesso" {
  name   = "vpc_acesso"
  vpc_id =  data.aws_vpc.selected.id 

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #[data.aws_vpc.vpc.cidr_block]  #["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block] # [data.aws_vpc.vpc.cidr_block] 
  }
  tags = var.tags
}


##securanca public
  resource "aws_security_group" "acesso_service" {
  name   = "acesso_services"
  vpc_id =  data.aws_vpc.selected.id 

  # access from the VPC
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #["0.0.0.0/0"]
  }
  tags = var.tags
}



resource "aws_cloudwatch_log_group" "example" {
  name = var.cluster_name
}


# Definir uma função de IAM para o ECS
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Anexar políticas à função IAM
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_kms_key" "example" {
  description             = "example"
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.example.id
  policy = jsonencode({
    Id = "ECSClusterFargatePolicy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "*"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow generate data key access for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example"
            ]
          }
        }
        Resource = "*"
      },
      {
        Sid    = "Allow grant creation permission for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:CreateGrant"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example"
            ]
          }
          "ForAllValues:StringEquals" = {
            "kms:GrantOperations" = [
              "Decrypt"
            ]
          }
        }
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}
