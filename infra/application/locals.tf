locals {
  apigateway = {
    id : data.terraform_remote_state.environment.outputs.apigateway.id,
    execution_arn : data.terraform_remote_state.environment.outputs.apigateway.execution_arn
  }
  lambda_config = {
    runtime = "nodejs18.x"
  }
  auth0 = {
    audience : ["https://notes-api-serverless.com"],
    issuer = "https://login.notes-app-serverless.vibakar.com/"
  }
}