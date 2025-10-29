resource "aws_apigatewayv2_authorizer" "auth0_jwt" {
  api_id           = data.terraform_remote_state.environment.outputs.apigateway.id
  name             = "${var.app_name}-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = local.auth0.audience
    issuer   = local.auth0.issuer
  }
}
