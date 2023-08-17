#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "Australia East"
}

variable "vnet_location" {
  type    = string
  default = "Australia East"
}

variable "naming_prefix" {
  type    = string
  default = "origintest"
}

variable "use_for_each" {
  type    = bool
  default = true
}

variable "tags" {
  type    = list(string)
  default = ["Environment:Dev", "CostCenter:IT"]
}
