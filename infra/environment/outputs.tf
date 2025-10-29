output "alb_dns_name" {
  description = "ALB Domain name"
  value       = aws_lb.app_alb.dns_name
}

output "frontend_app_url" {
  description = "Frontend application url"
  value       = aws_route53_record.www_frontend.name
}

output "certificate_arn" {
  description = "Arn of the certificate"
  value       = aws_acm_certificate.app_cert.arn
}

output "apigateway" {
  description = "Details of apigateway"
  value = {
    id            = aws_apigatewayv2_api.notes_api.id,
    execution_arn = aws_apigatewayv2_api.notes_api.execution_arn
  }
}

output "artefact_bucket" {
  description = "S3 bucket for storing artefact"
  value = aws_s3_bucket.artefact_bucket.arn
}