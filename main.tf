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

module "product_team_a" {
  source = "./modules/product-team" 
  org = var.org 
  team_name = "product-team-a"
  team_members = ["devhulk"]
}

module "azure_networking_team" {
  source = "./modules/admin-team" 
  org = var.org 
  team_name = "azure-networking"
  team_members = ["_devhulk"]
}

module "azure_db_team" {
  source = "./modules/admin-team" 
  org = var.org 
  team_name = "azure-db"
  team_members = ["_devhulk"]
}

module "team_a_prod" {
  source = "./modules/azure-workspace" 
  org = var.org 
  team_name = module.product_team_a.team_name
  team_id = module.product_team_a.team_id
  env = "prod"
  workspace_tags = ["prod", "team:a"]
  vcs_token = var.vcs_token
  team_access = {
    team_id = module.product_team_a.team_id
  }
}

module "azure_networking_prod" {
  source = "./modules/azure-workspace" 
  org = var.org 
  team_name = module.azure_networking_team.team_name
  team_id = module.azure_networking_team.team_id
  env = "prod"
  workspace_tags = ["prod", "team:a"]
  vcs_token = var.vcs_token
  team_access = {
    team_id = module.product_team_a.team_id,
    source_team = module.azure_networking_team.team_id
  }
  workspace_variables = {
    "region" : "East US",
    "team_name" : "team-a",
    "environment" : "prod"
  }
}

resource "tfe_run_trigger" "team_a_networking" {
  workspace_id  = module.team_a_prod.workspace_id
  sourceable_id  = module.azure_networking_prod.workspace_id
}

module "azure_db_prod" {
  source = "./modules/azure-workspace" 
  org = var.org 
  team_name = module.azure_db_team.team_name
  team_id = module.azure_db_team.team_id
  env = "prod"
  workspace_tags = ["prod", "team:a"]
  vcs_token = var.vcs_token
  team_access = {
    team_id = module.product_team_a.team_id,
    source_team = module.azure_db_team.team_id
  }
  workspace_variables = {
    region = "East US",
    team_name = "team-a",
    db = "sql"
    failover_location = "West US"
  }
}

resource "tfe_policy_set" "azure_governance_prod" {
  name          = "azure-governance-prod"
  description   = "Azure Governance Policies"
  organization  = var.org
  policies_path = "policy"
  workspace_ids = [module.team_a_prod.workspace_id,  module.azure_db_prod.workspace_id, module.azure_networking_prod.workspace_id]

  vcs_repo {
    identifier         = "devhulk/azure-governance-demo"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = var.vcs_token
  }
}


# resource "tfe_workspace" "azure_networking" {
#     name = "azure-networking"
#     organization = var.org
#     execution_mode = "remote"
#     tag_names = ["prod", "team:a"]

#     vcs_repo {
#         identifier = "devhulk/azure-networking"
#         branch = "main"
#         oauth_token_id = var.vcs_token
#     }
# }

# resource "tfe_variable" "azure_networking_region" {
#   key          = "region"
#   value        = "East US"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_networking.id
#   description  = "Azure Region"
# }

# resource "tfe_variable" "azure_networking_team_name" {
#   key          = "team_name"
#   value        = "team-a"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_networking.id
#   description  = "Team Name"
# }

# resource "tfe_variable" "azure_networking_environment" {
#   key          = "environment"
#   value        = "production"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_networking.id
#   description  = "Deployment Environment"
# }

# resource "tfe_team_access" "azure_networking_product_a" {

#     team_id      = module.product_team_a.team_id
#     workspace_id = tfe_workspace.azure_networking.id

#     permissions {
#         runs = "read"
#         variables = "none"
#         state_versions = "read"
#         sentinel_mocks = "read"
#         workspace_locking = false
#     }
# }

# resource "tfe_workspace" "azure_db" {
#     name = "azure-db"
#     organization = var.org
#     execution_mode = "remote"
#     tag_names = ["prod", "team:a", "sql"]

#     vcs_repo {
#         identifier = "devhulk/azure-db"
#         branch = "main"
#         oauth_token_id = var.vcs_token
#     }
# }

# resource "tfe_variable" "azure_db_region" {
#   key          = "region"
#   value        = "East US"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_db.id
#   description  = "Azure Region"
# }

# resource "tfe_variable" "azure_db_team_name" {
#   key          = "team_name"
#   value        = "team-a"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_db.id
#   description  = "Team Name"
# }

# resource "tfe_variable" "azure_db_type" {
#   key          = "db"
#   value        = "sql"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_db.id
#   description  = "SQL of MongoDB"
# }

# resource "tfe_variable" "azure_db_failover" {
#   key          = "failover_location"
#   value        = "West US"
#   category     = "terraform"
#   workspace_id = tfe_workspace.azure_db.id
#   description  = "Failover Region"
# }

# resource "tfe_team_access" "azure_db_product_a" {

#     team_id      = module.product_team_a.team_id
#     workspace_id = tfe_workspace.azure_db.id

#     permissions {
#         runs = "read"
#         variables = "none"
#         state_versions = "read"
#         sentinel_mocks = "read"
#         workspace_locking = false
#     }
# }

# resource "tfe_workspace" "product_b" {
#     name = "product-team-b"
#     organization = var.org
#     execution_mode = "remote"
#     tag_names = ["azure", "prod"]

#     vcs_repo {
#         identifier = "devhulk/product-team-b"
#         branch = "main"
#         oauth_token_id = var.vcs_token
#     }
# }

# resource "tfe_run_trigger" "product_b" {
#   workspace_id  = tfe_workspace.product_b.id
#   sourceable_id = tfe_workspace.azure_networking.id
# }


# resource "tfe_team_access" "product_b" {

#     team_id      = tfe_team.product_b.id
#     workspace_id = tfe_workspace.product_b.id

#     permissions {
#         runs = "apply"
#         variables = "write"
#         state_versions = "write"
#         sentinel_mocks = "read"
#         workspace_locking = false
#     }
# }

# resource "tfe_team" "product_b" {
#   name         = "Product Team B"
#   organization = var.org
#   visibility = "organization"
#   organization_access {
#       manage_policies = false
#       manage_policy_overrides = false
#       manage_workspaces = false
#       manage_vcs_settings = false
#   }

# }

# resource "tfe_team_members" "product_b" {
#     team_id = tfe_team.product_b.id
#     usernames = ["devhulk"]
# }


# resource "tfe_team" "product_a" {
#   name         = "Product Team A"
#   organization = var.org
#   visibility = "organization"
#   organization_access {
#       manage_policies = false
#       manage_policy_overrides = false
#       manage_workspaces = false
#       manage_vcs_settings = false
#   }

# }


# resource "tfe_team_members" "product_a" {
#     team_id = tfe_team.product_a.id
#     usernames = ["devhulk"]
# }


# resource "tfe_workspace" "product_a" {
#     name = "product-team-a"
#     organization = var.org
#     execution_mode = "remote"
#     tag_names = ["prod", "team:a"]

#     vcs_repo {
#         identifier = "devhulk/product-team-a"
#         branch = "main"
#         oauth_token_id = var.vcs_token
#     }
# }

# resource "tfe_run_trigger" "product_a" {
#   workspace_id  = tfe_workspace.product_a.id
#   sourceable_id = tfe_workspace.azure_networking.id
# }

# resource "tfe_team_access" "product_a" {

#     team_id      = tfe_team.product_a.id
#     workspace_id = tfe_workspace.product_a.id

#     permissions {
#         runs = "apply"
#         variables = "write"
#         state_versions = "write"
#         sentinel_mocks = "read"
#         workspace_locking = false
#     }
# }