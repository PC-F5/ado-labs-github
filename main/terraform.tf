##################################################################################
# TERRAFORM CONFIG
##################################################################################
terraform {
  required_providers {
    #
    # this version is required for the palo alto module
    # but it's going to require that the init has the -upgrade arguement
    #
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "=3.70.0"    
    # }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    key = "app.terraform.tfstate"
  }
}


##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  features {}
}
