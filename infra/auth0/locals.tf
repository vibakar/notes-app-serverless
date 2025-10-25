locals {
  auth0_config = {
    domain     = "https://login.notes-app-serverless.vibakar.com"
    identifier = "https://notes-api-serverless.com"
    callbacks = [
      "http://localhost",
      "http://localhost:5173",
      "https://www.${var.app_name}.${var.root_domain_name}"
    ]
    allowed_logout_urls = [
      "http://localhost",
      "http://localhost:5173",
      "https://www.${var.app_name}.${var.root_domain_name}"
    ]
    web_origins = [
      "http://localhost",
      "http://localhost:5173",
      "https://www.${var.app_name}.${var.root_domain_name}"
    ]
  }
}
