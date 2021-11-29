
resource "tfe_workspace" "product_team" {
    name = "${var.team_name}-${var.env}"
    organization = var.org
    execution_mode = "remote"
    tag_names = var.workspace_tags
    queue_all_runs = false
    allow_destroy_plan = true
    remote_state_consumer_ids = var.state_consumers

    vcs_repo {
        identifier = "devhulk/${var.team_name}"
        branch = var.env == "prod" ? "main" : var.env
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_team_access" "product_team" {

    for_each = var.team_access

    team_id      = each.value
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

