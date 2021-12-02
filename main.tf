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
   depends_on = [module.product_team_a]
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
   depends_on = [module.product_team_a]
   env = "prod"
   state_consumers = [module.team_a_prod.workspace_id]
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
   depends_on = [module.product_team_a]
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