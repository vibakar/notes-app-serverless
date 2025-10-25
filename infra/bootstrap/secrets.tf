resource "aws_secretsmanager_secret" "auth0" {
  name        = "${var.app_name}/auth0/pipeline-config"
  description = "This secret stores AUTH0 credentials for pipeline to use"
}

# Creates a placeholder secret container, update the secret value manually
resource "aws_secretsmanager_secret_version" "auth0" {
  secret_id = aws_secretsmanager_secret.auth0.id
  secret_string = jsonencode({
    AUTH0_DOMAIN        = "<<PLACEHOLDER>>"
    AUTH0_CLIENT_ID     = "<<PLACEHOLDER>>"
    AUTH0_CLIENT_SECRET = "<<PLACEHOLDER>>"
  })
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "docker" {
  name        = "${var.app_name}/docker/credentials"
  description = "This secret stores docker credentials to push/pull images"
}

# Creates a placeholder secret container, update the secret value manually
resource "aws_secretsmanager_secret_version" "docker" {
  secret_id = aws_secretsmanager_secret.docker.id
  secret_string = jsonencode({
    username = "<<PLACEHOLDER>>"
    password = "<<PLACEHOLDER>>"
  })
  lifecycle {
    ignore_changes = [secret_string]
  }
}