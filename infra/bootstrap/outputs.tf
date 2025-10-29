output "docker_secret" {
  description = "The secret containing docker credentials for the application"
  value = {
    arn : aws_secretsmanager_secret.docker.arn
    name : aws_secretsmanager_secret.docker.name
  }
}

output "artefact_bucket" {
  description = "Bucket for storing artefacts"
  value       = aws_s3_bucket.artefact_bucket.bucket
}