resource "aws_lambda_function" "notes" {
  for_each      = local.lambdas
  function_name = "${var.app_name}-${each.value.name}"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = local.lambda_config.runtime
  handler       = each.value.handler
  s3_bucket     = data.terraform_remote_state.bootstrap.outputs.artefact_bucket
  s3_key        = var.lambda_s3_key

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}