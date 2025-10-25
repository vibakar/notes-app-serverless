data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name         = var.root_domain_name
  private_zone = false
}

data "terraform_remote_state" "auth0" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/auth0/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/bootstrap/terraform.tfstate"
    region = "eu-west-2"
  }
}