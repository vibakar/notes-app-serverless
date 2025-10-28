resource "aws_apigatewayv2_api" "notes_api" {
  name          = "${var.app_name}-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each = aws_lambda_function.notes

  api_id                 = aws_apigatewayv2_api.notes_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = each.value.invoke_arn
  payload_format_version = "2.0"
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

resource "aws_apigatewayv2_route" "routes" {
  for_each = local.lambdas

  api_id             = aws_apigatewayv2_api.notes_api.id
  route_key          = "${each.value.method} ${each.value.route}"
  target             = format("integrations/%s", aws_apigatewayv2_integration.lambda_integration[each.key].id)
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.auth0_jwt.id
}

resource "aws_apigatewayv2_stage" "notes_stage" {
  api_id      = aws_apigatewayv2_api.notes_api.id
  name        = "api"
  auto_deploy = true
}