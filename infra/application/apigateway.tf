resource "aws_apigatewayv2_api" "notes_api" {
  name          = "${var.app_name}-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "auth0_jwt" {
  api_id           = aws_apigatewayv2_api.notes_api.id
  name             = "${var.app_name}-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = local.auth0.audience
    issuer   = local.auth0.issuer
  }
}

resource "aws_apigatewayv2_stage" "notes_stage" {
  api_id      = aws_apigatewayv2_api.notes_api.id
  name        = "api"
  auto_deploy = true
}