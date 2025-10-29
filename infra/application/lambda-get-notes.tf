resource "aws_lambda_function" "get_notes_lambda" {
  function_name = "${var.app_name}-get-notes"
  role          = aws_iam_role.get_notes_lambda_role.arn
  runtime       = local.lambda_config.runtime
  handler       = "backend/handlers/getNotes.handler"
  s3_bucket     = data.terraform_remote_state.environment.outputs.artefact_bucket
  s3_key        = var.lambda_s3_key

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}

resource "aws_apigatewayv2_integration" "get_notes_lambda_integration" {
  api_id                 = local.apigateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.get_notes_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_notes_lambda_get_route" {
  api_id             = local.apigateway.id
  route_key          = "GET /v1/notes"
  target             = "integrations/${aws_apigatewayv2_integration.get_notes_lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.auth0_jwt.id
}

resource "aws_iam_role" "get_notes_lambda_role" {
  name = "${var.app_name}-get-notes-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "get_notes_lambda_basic_policy" {
  role       = aws_iam_role.get_notes_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "get_notes_lambda" {
  statement_id  = "AllowInvokeGetNotesLambda"
  action        = "lambda:InvokeFunction"
  function_name = "${var.app_name}-get-notes"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${local.apigateway.execution_arn}/*/*"
}