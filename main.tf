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


// data "tfe_team" "dev" {
//     name = "dev"
//     organization = var.org
// }


resource "tfe_team" "development" {
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

resource "tfe_team" "product" {
  name         = "Product Development"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = true
      manage_policy_overrides = false
      manage_workspaces = false
      manage_vcs_settings = false
  }

}