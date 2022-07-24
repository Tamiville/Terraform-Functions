data "azurerm_virtual_network" "vnet" {
  name                = local.existingvnet
  resource_group_name = local.existingvnetrg
}

