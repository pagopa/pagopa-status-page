
locals {
  env_secrets = {
    "AZURE_CLIENT_ID" : data.azurerm_user_assigned_identity.identity_cd_01.client_id,
  }
}

###############
# ENV Secrets #
###############

# resource "github_actions_environment_secret" "github_environment_runner_secrets" {
#   for_each        = local.env_secrets
#   repository      = local.github.repository
#   environment     = var.env
#   secret_name     = each.key
#   plaintext_value = each.value
# }

#################
# ENV Variables #
#################




#############################
# Secrets of the Repository #
#############################


# resource "github_actions_secret" "repo_secrets" {
#   for_each        = local.env_secrets
#   repository      = local.github.repository
#   secret_name     = each.key
#   plaintext_value = each.value
# }

output "vpc_id" {
  description = "AZURE_CLIENT_ID"
  value       =data.azurerm_user_assigned_identity.identity_cd_01.client_id
}