variable "aws_region" {
  default = "eu-north-1"
}

variable "ecr_image" {
  description = "ECR image URI"
}

variable "app_keys" {}
variable "api_token_salt" {}
variable "admin_jwt_secret" {}
