terraform {
  backend "s3" {
    bucket  = "paktha-strapi-state"
    key     = "ecs/strapi/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
    use_lockfile = true
  }
}
