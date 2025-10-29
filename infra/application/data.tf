data "aws_route53_zone" "zone" {
  name         = var.root_domain_name
  private_zone = false
}

data "terraform_remote_state" "environment" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/environment/terraform.tfstate"
    region = "eu-west-2"
  }
}
