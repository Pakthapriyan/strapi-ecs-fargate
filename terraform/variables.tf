variable "aws_region" {
  default = "eu-north-1"
}

variable "ecr_image_uri" {
  description = "ECR image URI with tag"
}

variable "app_keys" {
  default = "dummy1,dummy2"
}

variable "api_token_salt" {
  default = "dummy_salt"
}

variable "admin_jwt_secret" {
  default = "dummy_admin"
}
