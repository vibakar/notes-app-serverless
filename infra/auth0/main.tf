resource "auth0_client" "notes_app" {
  name                = "Notes App Serverless"
  description         = "Application for the Notes App Serverless"
  app_type            = "spa"
  callbacks           = local.auth0_config.callbacks
  allowed_logout_urls = local.auth0_config.allowed_logout_urls
  web_origins         = local.auth0_config.web_origins
  grant_types = [
    "authorization_code",
    "implicit",
    "refresh_token"
  ]
}

resource "auth0_resource_server" "notes_api" {
  name           = "Notes App API"
  identifier     = local.auth0_config.identifier
  signing_alg    = "RS256"
  token_lifetime = 36000
}

resource "auth0_custom_domain" "login" {
  domain = "login.${var.app_name}.${var.root_domain_name}"
  type   = "auth0_managed_certs"
}

resource "auth0_custom_domain_verification" "this" {
  depends_on       = [aws_route53_record.auth0]
  custom_domain_id = auth0_custom_domain.login.id
  timeouts { create = "15m" }
}

resource "auth0_action" "post_login_custom_claims_action" {
  name    = "Post Login Custom Claims"
  runtime = "node18"
  deploy  = true
  # The JavaScript code for the Action
  code = <<-EOT
    /**
     * Handler that will be called during the execution of a PostLogin flow.
     *
     * @param {Event} event - Details about the user and the context in which they are logging in.
     * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
     */
    exports.onExecutePostLogin = async (event, api) => {
      if (event.user.email) {
        api.accessToken.setCustomClaim("email", event.user.email);
      }
      
      if (event.user.name) {
        api.accessToken.setCustomClaim("name", event.user.name);
      }
    };
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3" # The latest version for the post-login trigger
  }
}

# Bind the action to the post-login flow
resource "auth0_trigger_action" "post_login_binding" {
  # The ID of the trigger to bind to
  trigger   = "post-login"
  action_id = auth0_action.post_login_custom_claims_action.id
}