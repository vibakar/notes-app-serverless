output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "frontend_app_url" {
  value = aws_route53_record.www_frontend.name
}

output "backend_api_url" {
  value = aws_route53_record.backend.name
}