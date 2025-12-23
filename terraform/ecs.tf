################################
# DEFAULT VPC & SUBNETS
################################

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

################################
# SECURITY GROUPS
################################

# EXISTING ALB SECURITY GROUP (DO NOT CREATE)
data "aws_security_group" "alb" {
  name   = "paktha-strapi-alb-sg"
  vpc_id = data.aws_vpc.default.id
}

# ECS Task Security Group (CREATED & MANAGED)
resource "aws_security_group" "ecs" {
  name   = "paktha-strapi-ecs-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################
# IAM ROLES (EXISTING)
################################

data "aws_iam_role" "ecs_execution_role" {
  name = "paktha-ecs-execution-role"
}

data "aws_iam_role" "ecs_task_role" {
  name = "paktha-ecs-task-role"
}

################################
# ECS CLUSTER
################################

resource "aws_ecs_cluster" "strapi" {
  name = "paktha-strapi-cluster"
}

################################
# ALB (USES EXISTING SG)
################################

resource "aws_lb" "strapi" {
  name               = "paktha-strapi-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.alb.ids
  security_groups    = [data.aws_security_group.alb.id]
}

################################
# TARGET GROUPS (BLUE / GREEN)
################################

resource "aws_lb_target_group" "blue" {
  name        = "paktha-strapi-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path    = "/admin"
    matcher = "200-399"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "paktha-strapi-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path    = "/admin"
    matcher = "200-399"
  }
}

################################
# ALB LISTENER (POINT TO BLUE)
################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.strapi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

################################
# ECS TASK DEFINITION
################################

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
    }
  ])
}

################################
# ECS SERVICE (CODEDEPLOY CONTROLLED)
################################

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
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.http]
}
