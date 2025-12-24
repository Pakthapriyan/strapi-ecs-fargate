################################
# VPC
################################
resource "aws_vpc" "strapi" {
  cidr_block           = "10.50.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "paktha-strapi-vpc"
  }
}

################################
# INTERNET GATEWAY
################################
resource "aws_internet_gateway" "strapi" {
  vpc_id = aws_vpc.strapi.id

  tags = {
    Name = "paktha-strapi-igw"
  }
}

################################
# PUBLIC SUBNETS
################################
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.strapi.id
  cidr_block              = "10.50.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "paktha-strapi-public-a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.strapi.id
  cidr_block              = "10.50.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "paktha-strapi-public-b"
    Tier = "public"
  }
}

################################
# ROUTE TABLE (PUBLIC)
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.strapi.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi.id
  }

  tags = {
    Name = "paktha-strapi-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

################################
# SECURITY GROUPS
################################
resource "aws_security_group" "alb" {
  name   = "paktha-strapi-alb-sg"
  vpc_id = aws_vpc.strapi.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name   = "paktha-strapi-ecs-sg"
  vpc_id = aws_vpc.strapi.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
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
# ALB
################################
resource "aws_lb" "strapi" {
  name               = "paktha-strapi-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "blue" {
  name        = "paktha-strapi-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.strapi.id
  target_type = "ip"

  health_check {
    path                = "/admin"
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "paktha-strapi-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.strapi.id
  target_type = "ip"

  health_check {
    path                = "/admin"
    matcher             = "200-399"
  }
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
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" }
      ]
    }
  ])
}

################################
# ECS SERVICE (CODEDEPLOY)
################################
resource "aws_ecs_service" "strapi" {
  name            = "paktha-strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.http]

  lifecycle {
    ignore_changes = [
      task_definition,
      network_configuration,
      load_balancer
    ]
  }
}
