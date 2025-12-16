
# NETWORK (DEFAULT VPC)


data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# EXISTING SECURITY GROUP


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
      name  = "strapi"
      image = var.ecr_image_uri

      essential = true

      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret }
      ]
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

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [data.aws_security_group.strapi.id]
    assign_public_ip = true
  }
}
