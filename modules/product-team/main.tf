
resource "tfe_team" "product_team" {
  name         = "${var.team_name}"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = false
      manage_policy_overrides = false
      manage_workspaces = false
      manage_vcs_settings = false
  }

}


resource "tfe_team_members" "product_team" {
    team_id = tfe_team.product_team.id
    usernames = var.team_members
}

resource "tfe_workspace" "product_team" {
    name = "${var.team_name}"
    organization = var.org
    execution_mode = "remote"
    tag_names = var.workspace_tags

    vcs_repo {
        identifier = "devhulk/product-team-a"
        branch = "main"
        oauth_token_id = var.vcs_token
    }
}

resource "tfe_team_access" "product_team" {

    team_id      = tfe_team.product_team.id
    workspace_id = tfe_workspace.product_team.id

    permissions {
        runs = "apply"
        variables = "write"
        state_versions = "write"
        sentinel_mocks = "read"
        workspace_locking = false
    }
}
