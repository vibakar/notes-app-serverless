resource "aws_apigatewayv2_api" "notes_api" {
  name          = "${var.app_name}-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "notes_stage" {
  api_id      = aws_apigatewayv2_api.notes_api.id
  name        = "api"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "custom_domain" {
  domain_name = local.backend_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.app_cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [ aws_acm_certificate_validation.this ]
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  api_id      = aws_apigatewayv2_api.notes_api.id
  domain_name = aws_apigatewayv2_domain_name.custom_domain.domain_name
  stage       = aws_apigatewayv2_stage.notes_stage.id
}
