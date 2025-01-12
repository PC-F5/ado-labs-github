# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
#   features {}
# }

locals {
  resource_group_name         = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  network_security_group_name = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  route_table_name            = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  lb_name                     = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  pip_name                    = "${var.naming_prefix}-${random_integer.name_suffix.result}"
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


# NETWORK SECURITY GROUP #

resource "azurerm_network_security_group" "nsg1" {
  name                = "TestSecurityGroup1"
  location            = azurerm_resource_group.vnetRG.location
  resource_group_name = azurerm_resource_group.vnetRG.name

  # security_rule {
  #   name                       = "test123"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  tags = {
    environment = "Test"
  }

  lifecycle {
    prevent_destroy = true
  }
}


# USER DEFINED ROUTES #

resource "azurerm_route_table" "rt1" {
  name                          = "TestRouteTable"
  location                      = azurerm_resource_group.vnetRG.location
  resource_group_name           = azurerm_resource_group.vnetRG.name
  disable_bgp_route_propagation = false

  # route {
  #   name           = "route1"
  #   address_prefix = "10.1.0.0/16"
  #   next_hop_type  = "VnetLocal"
  # }

  tags = {
    environment = "Test"
  }

  lifecycle {
    prevent_destroy = true
  }
}


# VNET #

resource "azurerm_virtual_network" "vnet" {
  name                = "TestVnet"
  address_space       = ["99.0.0.0/16"] # Set your desired address space
  location            = azurerm_resource_group.vnetRG.location
  resource_group_name = azurerm_resource_group.vnetRG.name
  tags = {
    owner = "peter.colley"
  }

  lifecycle {
    prevent_destroy = true
  }
}


# SUBNETS #

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.vnetRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["99.0.1.0/24"] # Set your desired subnet address range

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.vnetRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["99.0.2.0/24"] # Set your desired subnet address range

  lifecycle {
    prevent_destroy = true
  }
}


# LOAD BALANCER

resource "azurerm_public_ip" "azlb" {
  allocation_method       = var.allocation_method
  location                = azurerm_resource_group.vnetRG.location
  name                    = local.pip_name
  resource_group_name     = azurerm_resource_group.vnetRG.name
  domain_name_label       = var.pip_domain_name_label
  idle_timeout_in_minutes = var.pip_idle_timeout_in_minutes
  ip_tags                 = var.pip_ip_tags
  ip_version              = var.pip_ip_version
  public_ip_prefix_id     = var.pip_public_ip_prefix_id
  reverse_fqdn            = var.pip_reverse_fqdn
  sku                     = var.pip_sku
  sku_tier                = var.pip_sku_tier
  # availability_zone       = var.pip_availability_zone

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_lb" "lb1" {
  location            = azurerm_resource_group.vnetRG.location
  resource_group_name = azurerm_resource_group.vnetRG.name
  name                = local.lb_name
  sku                 = var.lb_sku
  sku_tier            = var.lb_sku_tier

  tags = {
    owner = "peter.colley"
  }

  frontend_ip_configuration {
    name                          = var.frontend_name
    private_ip_address            = var.frontend_private_ip_address
    private_ip_address_allocation = var.frontend_private_ip_address_allocation
    private_ip_address_version    = var.frontend_private_ip_address_version
    public_ip_address_id          = azurerm_public_ip.azlb.id
    subnet_id                     = azurerm_subnet.subnet1.id
    zones                         = var.frontend_ip_zones
  }

  lifecycle {
    precondition {
      condition     = var.frontend_subnet_name == null || var.frontend_subnet_name == "" || var.frontend_subnet_id == null || var.frontend_subnet_id == ""
      error_message = "frontend_subnet_name or frontend_vent_name cannot exist if frontend_subnet_id exists."
    }
    prevent_destroy = true
  }
}



# PALO ALTO PAN-OS

resource "azurerm_palo_alto_next_generation_firewall_virtual_network_panorama" "panos1" {
  name                    = "TestPanosFirewall"
  resource_group_name     = azurerm_resource_group.vnetRG.name
  location                = azurerm_resource_group.vnetRG.location
  panorama_base64_config  = "e2RnbmFtZTogY25nZnctYXotZXhhbXBsZSwgdHBsbmFtZTogY25nZnctZXhhbXBsZS10ZW1wbGF0ZS1zdGFjaywgZXhhbXBsZS1wYW5vcmFtYS1zZXJ2ZXI6IDE5Mi4xNjguMC4xLCB2bS1hdXRoLWtleTogMDAwMDAwMDAwMDAwMDAwLCBleHBpcnk6IDIwMjQvMDcvMzF9Cg=="

  network_profile {
    public_ip_address_ids = [azurerm_public_ip.azlb.id]

    vnet_configuration {
      virtual_network_id  = azurerm_virtual_network.vnet.id
      trusted_subnet_id   = azurerm_subnet.subnet1.id
      untrusted_subnet_id = azurerm_subnet.subnet2.id
    }
  }
}


# # get a ref to our existing vnet
# data "azurerm_virtual_network" "existing_vnet" {
#   name                = "TestVnet"
#   resource_group_name = "origintest-17493"
# }

# # deploy subnet to our discovered vnet
# resource "azurerm_subnet" "subnet3" {
#   name                 = "subnet3"
#   resource_group_name  = data.azurerm_virtual_network.existing_vnet.resource_group_name
#   virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
#   address_prefixes     = ["99.0.3.0/24"] # Set your desired subnet address range
# }
