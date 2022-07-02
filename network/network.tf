resource "azurerm_resource_group" "clax_general_network" {
  name     = "clax_general_network"
  location = "centralus"
}

resource "azurerm_network_security_group" "clax_nsg" {
  name                = "clax_nsg"
  location            = azurerm_resource_group.clax_general_network.location
  resource_group_name = azurerm_resource_group.clax_general_network.name
}

resource "azurerm_virtual_network" "clax_vnet" {
  name                = "clax_vnet"
  location            = azurerm_resource_group.clax_general_network.location
  resource_group_name = azurerm_resource_group.clax_general_network.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  tags = {
    environment = "Development"
    company     = "elitesolutionsit"
    ManagedWith = "terraform"
  }
}
resource "azurerm_route_table" "clax_rt" {
  name                          = "clax_rt"
  location                      = azurerm_resource_group.clax_general_network.location
  resource_group_name           = azurerm_resource_group.clax_general_network.name
  disable_bgp_route_propagation = false
}

resource "azurerm_subnet" "database_subnet" {
  name                 = "database_subnet"
  resource_group_name  = azurerm_resource_group.clax_general_network.name
  virtual_network_name = azurerm_virtual_network.clax_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_subnet" "application_subnet" {
  name                 = "application_subnet"
  resource_group_name  = azurerm_resource_group.clax_general_network.name
  virtual_network_name = azurerm_virtual_network.clax_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
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
  source_address_prefix       = "82.76.59.177/32"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}