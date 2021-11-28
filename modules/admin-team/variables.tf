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