
resource "tfe_team" "admin_team" {
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


resource "tfe_team_members" "admin_team" {
    team_id = tfe_team.admin_team.id
    usernames = var.team_members
}
