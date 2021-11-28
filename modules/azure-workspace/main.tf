
resource "tfe_workspace" "product_team" {
    name = "${var.team_name}-${var.env}"
    organization = var.org
    execution_mode = "remote"
    tag_names = var.workspace_tags
    queue_all_runs = false
    allow_destroy_plan = true

    vcs_repo {
        identifier = "devhulk/${var.team_name}"
        branch = var.env == "prod" ? "main" : var.env
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_team_access" "product_team" {

    team_id      = var.team_id
    workspace_id = tfe_workspace.product_team.id

    permissions {
        runs = "apply"
        variables = "write"
        state_versions = "write"
        sentinel_mocks = "read"
        workspace_locking = false
    }
}

resource "tfe_variable" "var" {
  for_each = var.workspace_variables
  key          = "${each.key}"
  value        = "${each.value}"
  category     = "terraform"
  workspace_id = tfe_workspace.product_team.id
  description  = ""
}

