resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.app_name}.${var.root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app_alb.dns_name]
}

resource "aws_route53_record" "www_frontend" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.frontend_domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app_alb.dns_name]
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.backend_domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app_alb.dns_name]
}