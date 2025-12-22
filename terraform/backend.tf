terraform {
  backend "s3" {
    bucket         = "paktha-terraform-state"
    key            = "ecs/strapi/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
