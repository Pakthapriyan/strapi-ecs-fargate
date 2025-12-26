# Task #1 – Strapi Local Setup & Exploration
## Objective

Understand Strapi fundamentals, project structure, and admin panel operations.


Steps Completed

  - Cloned the official Strapi repository
      https://github.com/strapi/strapi
  - Installed dependencies and ran Strapi locally
  
  - Explored the Strapi project folder structure
  
  - Started the Strapi Admin Panel
  
  - Created a sample Content Type
  
  - Verified CRUD operations via Admin UI
  
  - Pushed local setup to a personal GitHub repository


# Task #2 – Dockerizing the Strapi Application
## Objective

  - Containerize Strapi for portability and consistency.

  Steps Completed

  - Created a Dockerfile for Strapi

  - Built the Docker image locally

  - Ran Strapi container on local machine

  - Verified application accessibility on port 1337

  Key Outcome

  - Strapi successfully runs as a standalone Docker container.
  loom video https://www.loom.com/share/22259bfeccd54a4fb574b83e19fa2375

# Task #3 – Multi-Container Dockerized Environment
## Objective

  Run Strapi in a production-like Docker environment with networking and reverse proxy.

## Architecture

    Docker Network: strapi-net

    Containers:

      -PostgreSQL (database)

      -Strapi (application)

      -Nginx (reverse proxy)

## Steps Completed

  - Created a user-defined Docker network

  - Deployed PostgreSQL with environment variables:

    (POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB)

  - Configured Strapi to connect to PostgreSQL via env vars

  - Added Nginx as a reverse proxy

  - Configured nginx.conf:

      Host port 80 → Nginx

      Proxy / → Strapi 1337

  - Ensured all containers run on the same network

## Final Result

  Strapi Admin Dashboard accessible at: http://localhost/admin
  loom video: https://www.loom.com/share/6780b89d788a45f88270ee3d181e2961


# Task #4 – Docker Deep Dive (Documentation)
## Topics Covered

  - Why Docker exists (problem statement)

  - Virtual Machines vs Docker

  - Docker Architecture

  - Docker Engine

  - Containerd

  - Docker Daemon & CLI

  - Dockerfile 

  - Essential Docker commands

  - Docker networking concepts

  - Volumes & data persistence

  - Docker Compose fundamentals

## Deliverable

  A clear, beginner-to-advanced Docker documentation suitable for real-world DevOps usage

## Task #5 – Deploy Strapi on AWS EC2 using Terraform & Docker
# Objective

  Provision infrastructure and deploy Strapi fully via Terraform.

## Steps Completed

  - Dockerized Strapi application

  - Built and pushed image to AWS ECR

  - Used Terraform to:

  - Provision EC2 instance

  - Configure Security Groups

  - Use user data to:

      + Install Docker

      + Authenticate to registry

      + Pull Strapi image

      + Run container automatically

  - Verified deployment using EC2 Public IP

Key Principle

  No manual SSH steps – everything automated via Terraform.
  
loom video https://www.loom.com/share/afb7a18440054f26b1414971782cebb2


# Task #6 – CI/CD Automation with GitHub Actions + Terraform
## Objective

  Implement CI/CD pipelines for automated builds and deployments.

  CI Pipeline (ci.yml)

  Trigger: push to main

  ## Steps:
  
    - Build Docker image
  
    - Tag image
  
    - Push to ECR
  
    - Expose image tag as workflow output

  CD Pipeline (terraform.yml)

  Trigger: workflow_dispatch

  ## Steps:
  
  - Terraform init
  
  - Terraform plan
  
  - Terraform apply
  
  - Pull new image on EC2
  
  - Deploy updated container

## Result
  
  End-to-end automated pipeline from code → production
  
  Deployment verified via EC2 Public IP

loom video https://www.loom.com/share/ea7ccfa7b4034c979266044d90462a58

# Task #7 – ECS Fargate Deployment via GitHub Actions
## Objective

  Deploy Strapi on ECS Fargate, fully automated via GitHub Actions.

  ## Steps Completed

  - Created a new repository
  
  - GitHub Actions workflow to:
  
  - Build & tag Docker image
  
  - Push to registry
  
  - Register new ECS task definition revision
  
  - Update ECS service to use latest image
  
  - No manual AWS console interaction

## Result

  ECS service updates driven only by GitHub Actions

loom video https://www.loom.com/share/bd170eef28274c5c9bfb9ec8a99cdaee

# Task #8 & #9 – ECS Fargate + CloudWatch Monitoring
## Objective

  Add observability and monitoring.

## Implementations

  - Created CloudWatch Log Group:
  
      /ecs/strapi
  
  - Configured ECS Task Definition with:
  
  - awslogs log driver
  
  - Stream prefix ecs/strapi
  
  - Enabled ECS metrics:
    
    + CPU Utilization
    
    + Memory Utilization
    
    + Task Count
    
    + Network In / Out
  
  - CloudWatch Dashboards & Alarms

## Outcome

  Centralized logs
  
  Production-ready monitoring visibility
loom video for task 8 https://www.loom.com/share/39dbaca43670476d94374eff51c03a6e
loom video for task 9 https://www.loom.com/share/50178b12e5044b3ebbf6f2f494fee2fc

# Task #10 – Blue/Green Deployment with ECS + CodeDeploy
## Objective

  Zero-downtime deployments using Blue/Green strategy.

## Architecture

  ECS Fargate Cluster & Service
  
  Application Load Balancer (ALB)
  
  Two Target Groups:
  
  Blue
  
  Green
  
  AWS CodeDeploy for ECS

## Key Configurations

  - Deployment Strategy:
  
    CodeDeployDefault.ECSCanary10Percent5Minutes
  
  - Automatic rollback enabled
  
  - Old task termination after success
  
  - ALB Security Group:
  
      HTTP (80)
      
      HTTPS (443)
  
  - ECS Security Group:
  
  - Allow traffic from ALB on port 1337
  
  - ALB Listener switches traffic between Blue & Green

## Result

  - Safe, automated, rollback-enabled deployments
  
  - Production-grade deployment strategy

# Task #11 – Automated Image Tagging & CodeDeploy Deployment (ECS)
## Objective

  Implement a commit-based deployment strategy for ECS using Amazon ECR + AWS CodeDeploy, ensuring traceability, safe rollouts, and rollback capability.

## Steps Completed

  - Built the Docker image using GitHub Actions
  
  - Tagged the Docker image with the GitHub commit SHA
  
  - Pushed the pre-built image to Amazon ECR
  
  - Dynamically updated the ECS Task Definition with the new image tag
  
  - Triggered AWS CodeDeploy to deploy the updated ECS service
  
  - Enabled deployment monitoring

  - Rollback configured in case of deployment failure
Loom Video: https://www.loom.com/share/52e21b68e19e42b1a25a43287a4b06c6
