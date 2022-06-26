resource "azurerm_resource_group" "clax_general_network" {
  name     = "clax_general_network"
  location = "EASTUS"
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

   subnet {
    name           = "database-subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.clax_nsg.id
  }

  subnet {
    name           = "application-subnet"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.clax_nsg.id
  }

   tags = {
    environment = "Development"
    company = "elitesolutionsit"
    ManagedWith = "terraform"
  }
}
resource "azurerm_route_table" "clax_rt" {
  name                          = "clax_rt"
  location                      = azurerm_resource_group.clax_general_network.location
  resource_group_name           = azurerm_resource_group.clax_general_network.name
  disable_bgp_route_propagation = false
}
 
    