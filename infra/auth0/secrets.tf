resource "aws_secretsmanager_secret" "auth0" {
  name        = "${var.app_name}/auth0/app-config"
  description = "This secret stores AUTH0 credentials for application to use"
}

resource "aws_secretsmanager_secret_version" "auth0" {
  secret_id = aws_secretsmanager_secret.auth0.id
  secret_string = jsonencode({
    AUTH0_DOMAIN    = local.auth0_config.domain
    AUTH0_CLIENT_ID = auth0_client.notes_app.client_id
    AUTH0_AUDIENCE  = auth0_resource_server.notes_api.identifier
  })
}