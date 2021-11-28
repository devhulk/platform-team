
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
