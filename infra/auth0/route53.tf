resource "aws_route53_record" "auth0" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "login.${var.app_name}.${var.root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [auth0_custom_domain.login.verification[0].methods[0].record]
}