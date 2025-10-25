variable "aws_region" {
  description = "AWS region to provision resources"
  type        = string
  default     = "eu-west-2"
}

# application name without space or special character
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "notes-app-serverless"
}

variable "root_domain_name" {
  description = "The root domain name for the application"
  type        = string
  default     = "vibakar.com"
}

variable "frontend_image" {
  description = "Container image for the frontend service"
  type        = string
  default     = "vibakar/notes-app-frontend:latest"
}