resource "aws_lambda_function" "update_note_lambda" {
  function_name = "${var.app_name}-update-note"
  role          = aws_iam_role.update_note_lambda_role.arn
  runtime       = local.lambda_config.runtime
  handler       = "backend/handlers/updateNote.handler"
  s3_bucket     = data.terraform_remote_state.bootstrap.outputs.artefact_bucket
  s3_key        = var.lambda_s3_key

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}

resource "aws_apigatewayv2_integration" "update_note_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.notes_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.update_note_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "update_note_lambda_put_route" {
  api_id             = aws_apigatewayv2_api.notes_api.id
  route_key          = "PUT /v1/notes/{id}"
  target             = "integrations/${aws_apigatewayv2_integration.update_note_lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.auth0_jwt.id
}

resource "aws_iam_role" "update_note_lambda_role" {
  name = "${var.app_name}-update-note-lambda-role"

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

resource "aws_iam_role_policy_attachment" "update_note_lambda_basic_policy" {
  role       = aws_iam_role.update_note_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "update_note_lambda" {
  statement_id  = "AllowInvokeUpdateNoteLambda"
  action        = "lambda:InvokeFunction"
  function_name = "${var.app_name}-update-note"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.notes_api.execution_arn}/*/*"
}