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
  dns_servers         = var.dns_servers


  tags = local.common_tags
}

resource "azurerm_route_table" "clax_rt" {
  name                          = var.clax_rt
  location                      = azurerm_resource_group.clax_general_network.location
  resource_group_name           = azurerm_resource_group.clax_general_network.name
  disable_bgp_route_propagation = false
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

resource "azurerm_network_security_rule" "nsg_RDP_rule" {
  name                        = "nsg_RDP_rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}