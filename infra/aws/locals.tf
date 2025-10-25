locals {
  acm_certificate_domain_name = "${var.app_name}.${var.root_domain_name}"
  frontend_domain_name        = "www.${var.app_name}.${var.root_domain_name}"
  backend_domain_name         = "api.${var.app_name}.${var.root_domain_name}"
}