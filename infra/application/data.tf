
data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/bootstrap/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "aws" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/aws/terraform.tfstate"
    region = "eu-west-2"
  }
}