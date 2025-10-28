locals {
  acm_certificate_domain_name = "${var.app_name}.${var.root_domain_name}"
  backend_domain_name         = "api.${var.app_name}.${var.root_domain_name}"
  lambda_config = {
    runtime = "nodejs18.x"
  }
  auth0 = {
    audience : ["https://notes-api-serverless.com"],
    issuer = "https://login.notes-app-serverless.vibakar.com/"
  }
}