resource "aws_ecs_cluster" "strapi" {
  name = "paktha-strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "paktha-strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = null
  task_role_arn      = null

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.ecr_image
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
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

resource "aws_ecs_service" "strapi" {
  name            = "paktha-strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups = [aws_security_group.strapi.id]
  }
}
