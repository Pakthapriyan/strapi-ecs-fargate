
# DEFAULT VPC & SUBNETS

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "alb" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}



# EXISTING SECURITY GROUP
data "aws_security_group" "strapi" {
  name   = "paktha-strapi-sg"
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "alb" {
  name   = "paktha-strapi-alb-sg"
  vpc_id = data.aws_vpc.default.id
}
# ALB → ECS RULE
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 1337
  to_port                  = 1337
  protocol                 = "tcp"
  security_group_id         = data.aws_security_group.strapi.id
  source_security_group_id = data.aws_security_group.alb.id
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

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "strapi" {
  cluster_name = aws_ecs_cluster.strapi.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}




# ALB + TARGET GROUP
resource "aws_lb_target_group" "blue" {
  name        = "paktha-strapi-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

resource "aws_lb_target_group" "green" {
  name        = "paktha-strapi-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}


resource "aws_lb" "strapi" {
  name               = "paktha-strapi-alb"
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.alb.id]
  subnets            = data.aws_subnets.alb.ids
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.strapi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
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
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
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

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = data.aws_subnets.alb.ids
    security_groups  = [data.aws_security_group.strapi.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [
    aws_lb_listener.http,
    aws_security_group_rule.alb_to_ecs
  ]
}
