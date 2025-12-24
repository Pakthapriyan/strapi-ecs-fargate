variable "aws_region" {
  default = "ap-south-1"
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
