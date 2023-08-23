# add a new subnet to an existing vnet

# get a ref to our existing vnet
data "azurerm_virtual_network" "existing_vnet" {
  name                = "TestVnet"
  resource_group_name = "origintest-67419"
}

# deploy subnet to our discovered vnet
resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = data.azurerm_virtual_network.existing_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes     = ["99.0.3.0/24"] # Set your desired subnet address range
}
