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


resource "tfe_team_members" "product_a" {
    team_id = tfe_team.product_a.id
    usernames = ["devhulk"]
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

resource "tfe_team_members" "product_b" {
    team_id = tfe_team.product_b.id
    usernames = ["devhulk"]
}

resource "tfe_workspace" "product_a" {
    name = "product-team-a"
    organization = var.org
    execution_mode = "remote"
    tag_names = ["prod", "team:a"]

    vcs_repo {
        identifier = "devhulk/product-team-a"
        branch = "main"
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_run_trigger" "product_a" {
  workspace_id  = tfe_workspace.product_a.id
  sourceable_id = tfe_workspace.azure_networking.id
}

resource "tfe_team_access" "product_a" {

    team_id      = tfe_team.product_a.id
    workspace_id = tfe_workspace.product_a.id

    permissions {
        runs = "apply"
        variables = "write"
        state_versions = "write"
        sentinel_mocks = "read"
        workspace_locking = false
    }
}

// resource "tfe_workspace" "product_b" {
//     name = "product-team-b"
//     organization = var.org
//     execution_mode = "remote"
//     tag_names = ["azure", "prod"]

//     vcs_repo {
//         identifier = "devhulk/product-team-b"
//         branch = "main"
//         oauth_token_id = var.vcs_token
//     }
// }

// resource "tfe_run_trigger" "product_b" {
//   workspace_id  = tfe_workspace.product_b.id
//   sourceable_id = tfe_workspace.azure_networking.id
// }


// resource "tfe_team_access" "product_b" {

//     team_id      = tfe_team.product_b.id
//     workspace_id = tfe_workspace.product_b.id

//     permissions {
//         runs = "apply"
//         variables = "write"
//         state_versions = "write"
//         sentinel_mocks = "read"
//         workspace_locking = false
//     }
// }

resource "tfe_workspace" "azure_networking" {
    name = "azure-networking"
    organization = var.org
    execution_mode = "remote"
    tag_names = ["prod", "team:a"]

    vcs_repo {
        identifier = "devhulk/azure-networking"
        branch = "main"
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_variable" "azure_networking_region" {
  key          = "region"
  value        = "East US"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_networking.id
  description  = "Azure Region"
//   hcl = true
}

resource "tfe_variable" "azure_networking_team_name" {
  key          = "team_name"
  value        = "PlatformEngineering"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_networking.id
  description  = "Team Name"
//   hcl = true
}

resource "tfe_variable" "azure_networking_environment" {
  key          = "environment"
  value        = "production"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_networking.id
  description  = "Deployment Environment"
//   hcl = true
}

resource "tfe_team_access" "azure_networking_product_a" {

    team_id      = tfe_team.product_a.id
    workspace_id = tfe_workspace.azure_networking.id

    permissions {
        runs = "read"
        variables = "none"
        state_versions = "read"
        sentinel_mocks = "read"
        workspace_locking = false
    }
}

resource "tfe_workspace" "azure_db" {
    name = "azure-db"
    organization = var.org
    execution_mode = "remote"
    tag_names = ["prod", "team:a", "sql"]

    vcs_repo {
        identifier = "devhulk/azure-db"
        branch = "main"
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_variable" "azure_db_region" {
  key          = "region"
  value        = "East US"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_db.id
  description  = "Azure Region"
//   hcl = true
}

resource "tfe_variable" "azure_db_team_name" {
  key          = "team_name"
  value        = "PlatformEngineering"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_db.id
  description  = "Team Name"
//   hcl = true
}

resource "tfe_variable" "azure_db_type" {
  key          = "db"
  value        = "sql"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_db.id
  description  = "SQL of MongoDB"
//   hcl = true
}

resource "tfe_variable" "azure_db_failover" {
  key          = "failover_location"
  value        = "West US"
  category     = "terraform"
  workspace_id = tfe_workspace.azure_db.id
  description  = "Failover Region"
//   hcl = true
}

resource "tfe_team_access" "azure_db_product_a" {

    team_id      = tfe_team.product_a.id
    workspace_id = tfe_workspace.azure_db.id

    permissions {
        runs = "read"
        variables = "none"
        state_versions = "read"
        sentinel_mocks = "read"
        workspace_locking = false
    }
}