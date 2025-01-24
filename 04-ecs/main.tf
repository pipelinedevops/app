
# Criar um cluster ECS
resource "aws_ecs_cluster" "example" {
  name = var.cluster_name #"example-ecs-cluster"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.example.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.example.name
      }
    }
  }

  tags = var.tags
    depends_on = [
    aws_kms_key_policy.example
  ]
}


# Criar um serviço ECS
resource "aws_ecs_service" "example" {
  name            = var.ecs_servicename #"example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 2
  launch_type     = "FARGATE" #"FARGATE" "EC2" "EXTERNAL"
  #availability_zone_rebalancing  = ENABLED
  deployment_maximum_percent = 100 #minimo 100
  deployment_minimum_healthy_percent = 50

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  network_configuration {
    subnets         = ["${data.aws_subnets.endpoint-us-east-1a.ids[0]}", "${data.aws_subnets.endpoint-us-east-1b.ids[0]}", "${data.aws_subnets.endpoint-us-east-1c.ids[0]}"] # IDs das sub-redes existentes
    security_groups = [
      aws_security_group.vpc_acesso.id,
      aws_security_group.acesso_service.id
    ]                       # ID do grupo de segurança existente
  }


  tags = var.tags

    depends_on = [
    aws_ecs_cluster.example,
    aws_security_group.acesso_service,
    aws_security_group.acesso_service

  ]
}


# Configurar uma definição de tarefa ECS
resource "aws_ecs_task_definition" "example" {
  family                   = var.imagename #"example-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # 0.25 vCPU
  memory                   = "512"  # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "applab" #"nginx"
      image     = "${var.imagename}:latest" #"nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]
      /*
       mountPoints = [
        {
          sourceVolume  = "volume"
          containerPath = "/usr/share/nginx/html"
        }
      ],
      */
    }
  ])


depends_on = [
    aws_ecs_cluster.example
  ]
  
}