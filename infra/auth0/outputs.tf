output "auth0_client_id" {
  description = "The Auth0 Client ID for the application"
  value       = auth0_client.notes_app.client_id
  sensitive   = true
}

output "auth0_audience" {
  description = "The Auth0 Audience for the application"
  value       = auth0_resource_server.notes_api.identifier
  sensitive   = true
}

output "auth0_secret" {
  description = "The secret containing auth0 credentials for the application"
  value = {
    arn : aws_secretsmanager_secret.auth0.arn
    name : aws_secretsmanager_secret.auth0.name
  }
  sensitive = true
}