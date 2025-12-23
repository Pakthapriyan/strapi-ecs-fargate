variable "aws_region" {
  default = "ap-south-1"
}


variable "ecr_image_uri" {
  description = "ECR image URI with tag"
  type        = string
}

variable "app_keys" {
  description = "Strapi APP_KEYS"
  type        = string
  default     = "dummy1,dummy2"
}

variable "api_token_salt" {
  description = "Strapi API token salt"
  type        = string
  default     = "dummy_salt"
}
variable "admin_jwt_secret" {
  description = "Strapi admin JWT secret"
  type        = string
  default     = "dummy_admin"
}
variable "jwt_secret" {
  description = "JWT secret for users-permissions plugin"
  type        = string
  default     = "dummy_jwt_secret_change_me"
}
variable "codedeploy_role_arn" {
  description = "IAM role ARN for CodeDeploy ECS"
  type        = string
}
