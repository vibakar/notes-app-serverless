output "alb_dns_name" {
  description = "ALB Domain name"
  value       = aws_lb.app_alb.dns_name
}

output "frontend_app_url" {
  description = "Frontend application url"
  value       = aws_route53_record.www_frontend.name
}
