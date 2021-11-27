variable "org" {
  description = "TFC/E org name"
  type        = string
}

variable "team_name" {
  description = "Name of team being created"
  type        = string
}

variable "team_members" {
  description = "list of team members"
  type        = list
}

variable "workspace_tags" {
  description = "workspace tags"
  type        = list
}

variable "vcs_token" {
  description = "vcs oAuth token for github"
  type        = string
}


