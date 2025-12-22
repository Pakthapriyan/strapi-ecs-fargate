
#  VPC & SUBNETS


data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# SECURITY GROUP


data "aws_security_group" "strapi" {
  name   = "paktha-strapi-sg"
  vpc_id = data.aws_vpc.default.id
}


# EXISTING IAM ROLES


data "aws_iam_role" "ecs_execution_role" {
  name = "paktha-ecs-execution-role"
}

data "aws_iam_role" "ecs_task_role" {
  name = "paktha-ecs-task-role"
}


# ECS CLUSTER


resource "aws_ecs_cluster" "strapi" {
  name = "paktha-strapi-cluster"
}


# ECS TASK DEFINITION

resource "aws_ecs_task_definition" "strapi" {
  family                   = "paktha-strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = data.aws_iam_role.ecs_execution_role.arn
  task_role_arn      = data.aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.ecr_image_uri
      essential = true

      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs/strapi"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:1337 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}



# ECS SERVICE


resource "aws_ecs_service" "strapi" {
  name            = "paktha-strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [data.aws_security_group.strapi.id]
    assign_public_ip = true
  }
}

