terraform {
  required_providers {
    tfe = {
      version = "~> 0.26.0"
    }
  }
}

provider "tfe" {
  version  = "~> 0.26.0"
}

data "tfe_team" "dev" {
    id = "team-QBa4Ff6aehw4kk8t"
    name = "dev"
    organization = var.org
}



resource "tfe_team" "dev" {
  name         = "Development"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = true
      manage_policy_overrides = false
      manage_workspaces = false
      manage_vcs_settings = false
  }

}