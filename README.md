# Task #1 – Strapi Local Setup & Exploration
## Objective

Understand Strapi fundamentals, project structure, and admin panel operations.

Steps Completed

Cloned the official Strapi repository

https://github.com/strapi/strapi


Installed dependencies and ran Strapi locally

Explored the Strapi project folder structure

Started the Strapi Admin Panel

Created a sample Content Type

Verified CRUD operations via Admin UI

Pushed local setup to a personal GitHub repository

Documented all steps in README.md

Recorded a Loom video walkthrough

Deliverables

GitHub Repository with Strapi setup

README documentation

Loom video demonstrating setup and admin usage

Pull Request raised after repository access was provided

🐳 Task #2 – Dockerizing the Strapi Application
Objective

Containerize Strapi for portability and consistency.

Steps Completed

Created a Dockerfile for Strapi

Built the Docker image locally

Ran Strapi container on local machine

Verified application accessibility on port 1337

Key Outcome

Strapi successfully runs as a standalone Docker container.

🐳 Task #3 – Multi-Container Dockerized Environment
Objective

Run Strapi in a production-like Docker environment with networking and reverse proxy.

Architecture

Docker Network: strapi-net

Containers:

PostgreSQL (database)

Strapi (application)

Nginx (reverse proxy)

Steps Completed

Created a user-defined Docker network

Deployed PostgreSQL with environment variables:

POSTGRES_USER

POSTGRES_PASSWORD

POSTGRES_DB

Configured Strapi to connect to PostgreSQL via env vars

Added Nginx as a reverse proxy

Configured nginx.conf:

Host port 80 → Nginx

Proxy / → Strapi 1337

Ensured all containers run on the same network

Final Result

Strapi Admin Dashboard accessible at:

http://localhost/admin


Complete documentation + Loom video recorded

📘 Task #4 – Docker Deep Dive (Documentation)
Topics Covered

Why Docker exists (problem statement)

Virtual Machines vs Docker

Docker Architecture

Docker Engine

Containerd

runc

Docker Daemon & CLI

Dockerfile deep dive (line-by-line explanation)

Essential Docker commands

Docker networking concepts

Volumes & data persistence

Docker Compose fundamentals

Deliverable

A clear, beginner-to-advanced Docker documentation suitable for real-world DevOps usage

☁️ Task #5 – Deploy Strapi on AWS EC2 using Terraform & Docker
Objective

Provision infrastructure and deploy Strapi fully via Terraform.

Steps Completed

Dockerized Strapi application

Built and pushed image to Docker Hub / AWS ECR

Used Terraform to:

Provision EC2 instance

Configure Security Groups

Use user data to:

Install Docker

Authenticate to registry

Pull Strapi image

Run container automatically

Verified deployment using EC2 Public IP

Key Principle

✅ No manual SSH steps – everything automated via Terraform.

🔁 Task #6 – CI/CD Automation with GitHub Actions + Terraform
Objective

Implement CI/CD pipelines for automated builds and deployments.

CI Pipeline (ci.yml)

Trigger: push to main

Steps:

Build Docker image

Tag image

Push to Docker Hub / ECR

Expose image tag as workflow output

CD Pipeline (terraform.yml)

Trigger: workflow_dispatch

Steps:

Terraform init

Terraform plan

Terraform apply

Pull new image on EC2

Deploy updated container

Result

End-to-end automated pipeline from code → production

Deployment verified via EC2 Public IP

🚢 Task #7 – ECS Fargate Deployment via GitHub Actions
Objective

Deploy Strapi on ECS Fargate, fully automated via GitHub Actions.

Steps Completed

Created a new repository

GitHub Actions workflow to:

Build & tag Docker image

Push to registry

Register new ECS task definition revision

Update ECS service to use latest image

No manual AWS console interaction

Result

ECS service updates driven only by GitHub Actions

📊 Task #8 – ECS Fargate + CloudWatch Monitoring
Objective

Add observability and monitoring.

Implementations

Created CloudWatch Log Group:

/ecs/strapi


Configured ECS Task Definition with:

awslogs log driver

Stream prefix ecs/strapi

Enabled ECS metrics:

CPU Utilization

Memory Utilization

Task Count

Network In / Out

(Optional) CloudWatch Dashboards & Alarms

Outcome

Centralized logs

Production-ready monitoring visibility

🔵🟢 Task #10 – Blue/Green Deployment with ECS + CodeDeploy
Objective

Zero-downtime deployments using Blue/Green strategy.

Architecture

ECS Fargate Cluster & Service

Application Load Balancer (ALB)

Two Target Groups:

Blue

Green

AWS CodeDeploy for ECS

Key Configurations

Deployment Strategy:

CodeDeployDefault.ECSCanary10Percent5Minutes

Automatic rollback enabled

Old task termination after success

ALB Security Group:

HTTP (80)

HTTPS (443)

ECS Security Group:

Allow traffic from ALB on port 1337

ALB Listener switches traffic between Blue & Green

Result

Safe, automated, rollback-enabled deployments

Production-grade deployment strategy

✅ Final Outcome

✔ Local Development
✔ Dockerized Application
✔ Automated Infrastructure (Terraform)
✔ CI/CD Pipelines (GitHub Actions)
✔ EC2 & ECS Deployments
✔ Monitoring & Logging
✔ Blue/Green Zero-Downtime Releases
