output "alb_dns_name" {
  description = "ALB Domain name"
  value       = aws_lb.app_alb.dns_name
}

output "frontend_app_url" {
  description = "Frontend application url"
  value       = aws_route53_record.www_frontend.name
}

output "backend_api_url" {
  description = "Backend application url"
  value       = aws_route53_record.backend.name
}

output "api_gateway_url" {
  description = "Invoke URL for the Notes API"
  value       = "${aws_apigatewayv2_api.notes_api.api_endpoint}/${aws_apigatewayv2_stage.notes_stage.name}"
}