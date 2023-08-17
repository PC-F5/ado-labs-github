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


resource "azurerm_resource_group" "vnet" {
  name     = local.resource_group_name
  location = var.location
}

# VNET #

resource "azurerm_network_security_group" "nsg1" {
  location            = var.vnet_location
  name                = local.network_security_group_name
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_route_table" "rt1" {
  location            = var.vnet_location
  name                = local.route_table_name
  resource_group_name = azurerm_resource_group.vnet.name
}

module "vnet" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.vnet.name
  use_for_each        = var.use_for_each
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  vnet_location       = var.vnet_location

  nsg_ids = {
    subnet1 = azurerm_network_security_group.nsg1.id
  }

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }

  subnet_delegation = {
    subnet2 = {
      "Microsoft.Sql.managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }

  route_tables_ids = {
    subnet1 = azurerm_route_table.rt1.id
  }

  tags = {
    for tag in var.tags : tag => tag
  }
  
  subnet_enforce_private_link_endpoint_network_policies = {
    subnet2 = true
  }

  subnet_enforce_private_link_service_network_policies = {
    subnet3 = true
  }
}