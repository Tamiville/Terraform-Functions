resource "azurerm_resource_group" "clax_general_network" {
  name     = var.clax_general_network
  location = var.location
}


resource "azurerm_network_security_group" "clax_nsg" {
  name                = var.clax_nsg
  location            = azurerm_resource_group.clax_general_network.location
  resource_group_name = azurerm_resource_group.clax_general_network.name
}

resource "azurerm_virtual_network" "clax_vnet" {
  name                = var.clax_vnet
  location            = azurerm_resource_group.clax_general_network.location
  resource_group_name = azurerm_resource_group.clax_general_network.name
  address_space       = var.address_space
  

  tags = local.common_tags
}

resource "azurerm_route_table" "clax_rt" {
  name                          = var.clax_rt
  location                      = azurerm_resource_group.clax_general_network.location
  resource_group_name           = azurerm_resource_group.clax_general_network.name
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "route" {
  name                = "route1"
  resource_group_name = azurerm_resource_group.clax_general_network.name
  route_table_name    = azurerm_route_table.clax_rt.name
  address_prefix      = "10.0.0.0/16"
  next_hop_type       = "VnetLocal"
}

resource "azurerm_subnet" "database_subnet" {
  name                 = var.database_subnet
  resource_group_name  = azurerm_resource_group.clax_general_network.name
  virtual_network_name = azurerm_virtual_network.clax_vnet.name
  address_prefixes     = var.address_prefixes_database
}


resource "azurerm_subnet" "application_subnet" {
  name                 = var.application_subnet
  resource_group_name  = azurerm_resource_group.clax_general_network.name
  virtual_network_name = azurerm_virtual_network.clax_vnet.name
  address_prefixes     = var.address_prefixes_application
}

resource "azurerm_subnet_route_table_association" "claxdev_rt_assoc_database" {
  subnet_id      = azurerm_subnet.database_subnet.id
  route_table_id = azurerm_route_table.clax_rt.id
}

resource "azurerm_subnet_route_table_association" "claxdev_rt_assoc_application" {
  subnet_id      = azurerm_subnet.application_subnet.id
  route_table_id = azurerm_route_table.clax_rt.id
}

resource "azurerm_subnet_network_security_group_association" "claxdev_nsg_assoc_database_subnet" {
  subnet_id                 = azurerm_subnet.database_subnet.id
  network_security_group_id = azurerm_network_security_group.clax_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "claxdev_nsg_assoc_application_subnet" {
  subnet_id                 = azurerm_subnet.application_subnet.id
  network_security_group_id = azurerm_network_security_group.clax_nsg.id
}
