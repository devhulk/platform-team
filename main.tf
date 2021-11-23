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



resource "tfe_team" "cloud" {
  name         = "Cloud Engineering"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = true
      manage_policy_overrides = true
      manage_workspaces = true
      manage_vcs_settings = true
  }

}

resource "tfe_team" "networking" {
  name         = "Networking"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = true
      manage_policy_overrides = true
      manage_workspaces = true
      manage_vcs_settings = true
  }

}

resource "tfe_team" "product_a" {
  name         = "Product Team A"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = false
      manage_policy_overrides = false
      manage_workspaces = false
      manage_vcs_settings = false
  }

}

resource "tfe_team" "product_b" {
  name         = "Product Team B"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = false
      manage_policy_overrides = false
      manage_workspaces = false
      manage_vcs_settings = false
  }

}

// resource "tfe_oauth_client" "main" {
//     organization = var.org
//     api_url          = "https://api.github.com"
//     http_url         = "https://github.com"
//     oauth_token      = var.vcs_token
//     service_provider = "github"
// }

resource "tfe_workspace" "product_a" {
    name = "Product A"
    organization = var.org
    execution_mode = "remote"
    tag_names = ["Product Team A"]

    vcs_repo {
        identifier = "devhulk/product-team-a"
        branch = "main"
        oauth_token = var.vcs_token
    }
}

resource "tfe_workspace" "product_b" {
    name = "Product B"
    organization = var.org
    execution_mode = "remote"
    tag_names = ["Product Team B"]

    vcs_repo {
        identifier = "devhulk/product-team-b"
        branch = "main"
        oauth_token = var.vcs_token
    }
}