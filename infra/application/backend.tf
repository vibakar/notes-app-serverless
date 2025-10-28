terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-648378716943"
    key    = "notes-app-serverless/application/terraform.tfstate"
    region = "eu-west-2"
  }
}