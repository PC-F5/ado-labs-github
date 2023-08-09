#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "australiaeast"
}

variable "naming_prefix" {
  type    = string
  default = "terraformtest"
}

variable "github_repository" {
  type    = string
  default = "ado-labs-github"
}