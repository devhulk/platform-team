variable "org" {
  description = "TFC/E org name"
  type        = string
}

variable "team_name" {
  description = "Name of team being created"
  type        = string
}

variable "team_access" {
  description = "teams to be given access"
  type        = map(string)
  default = {}
}

variable "workspace_tags" {
  description = "workspace tags"
  type        = list
}

variable "vcs_token" {
  description = "vcs oAuth token for github"
  type        = string
}

variable "team_id" {
  description = "id of the team to be granted workspace access"
  type        = string
}
variable "env" {
  description = "env mapped to workspace name based on mapped git branch (main | dev | prod)"
  type        = string
}

variable "workspace_variables" {
  description = "map containing workspace vars"
  type = map(string)
  default = {}
}


