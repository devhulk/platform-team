
resource "tfe_team" "product_team" {
  name         = "${var.team_name}"
  organization = var.org
  visibility = "organization"
  organization_access {
      manage_policies = true
      manage_policy_overrides = true
      manage_workspaces = true
      manage_vcs_settings = true
  }

}


resource "tfe_team_members" "product_team" {
    team_id = tfe_team.product_team.id
    usernames = var.team_members
}
