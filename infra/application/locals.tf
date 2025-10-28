locals {
  acm_certificate_domain_name = "${var.app_name}.${var.root_domain_name}"
  backend_domain_name         = "api.${var.app_name}.${var.root_domain_name}"
  lambdas = {
    createNote  = { method = "POST", route = "/v1/notes", handler = "backend/handlers/createNote.handler", name = "create-note" }
    getNotes    = { method = "GET", route = "/v1/notes", handler = "backend/handlers/getNotes.handler", name = "get-notes" }
    getNoteById = { method = "GET", route = "/v1/notes/{id}", handler = "backend/handlers/getNoteById.handler", name = "get-note-by-id" }
    updateNote  = { method = "PUT", route = "/v1/notes/{id}", handler = "backend/handlers/updateNote.handler", name = "update-note" }
    deleteNote  = { method = "DELETE", route = "/v1/notes/{id}", handler = "backend/handlers/deleteNote.handler", name = "delete-note" }
  }
  lambda_config = {
    runtime = "nodejs18.x"
  }
  auth0 = {
    audience : ["https://notes-api-serverless.com"],
    issuer = "https://login.notes-app-serverless.vibakar.com/"
  }
}