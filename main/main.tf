locals {
  resource_group_name = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  network_security_group_name = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  route_table_name = "${var.naming_prefix}-${random_integer.name_suffix.result}"
}

resource "random_integer" "name_suffix" {
  min = 10000
  max = 99999
}


# RESOURCE GROUP #

resource "azurerm_resource_group" "vnetRG" {
  name     = local.resource_group_name
  location = var.location
}


# VNET #

resource "azurerm_network_security_group" "nsg1" {
  location            = var.vnet_location
  name                = local.network_security_group_name
  resource_group_name = azurerm_resource_group.vnetRG.name
}

resource "azurerm_route_table" "rt1" {
  location            = var.vnet_location
  name                = local.route_table_name
  resource_group_name = azurerm_resource_group.vnetRG.name
}


resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  address_space       = ["10.21.21.0/24"]  # Set your desired address space
  location            = azurerm_resource_group.vnetRG.location
  resource_group_name = azurerm_resource_group.vnetRG.name
  tags = {
    owner = "peter.colley"
  }
}


resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name = azurerm_resource_group.vnetRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.22.0/24"]  # Set your desired subnet address range
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name = azurerm_resource_group.vnetRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.23.0/24"]  # Set your desired subnet address range
}
