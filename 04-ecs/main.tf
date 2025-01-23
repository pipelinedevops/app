
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
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678", "subnet-87654321"] # IDs das sub-redes existentes
    security_groups = ["sg-12345678"]                       # ID do grupo de segurança existente
  }

  tags = var.tags

    depends_on = [
    aws_ecs_cluster.example
  ]
}


# Configurar uma definição de tarefa ECS
resource "aws_ecs_task_definition" "example" {
  family                   = "example-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # 0.25 vCPU
  memory                   = "512"  # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])


depends_on = [
    aws_ecs_cluster.example
  ]
  
}
