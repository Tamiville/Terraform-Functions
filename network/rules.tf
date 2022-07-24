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

resource "azurerm_network_security_rule" "DB" {
  name                        = "DB"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "SSH" {
  name                        = "SSH"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "HTTP" {
  name                        = "HTTP"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "AppgwRule" {
  name                        = "AppgwRule"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = var.source_address_prefix_appgw
  destination_address_prefix  = var.destination_address_prefix_appgw
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "Internet" {
  name                        = "Internet"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.source_address_prefix_appgw
  destination_address_prefix  = var.destination_address_prefix_appgw
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "All-Traffic-Outbound" {
  name                        = "All-Traffic-Outbound"
  priority                    = 107
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.source_address_prefix_appgw
  destination_address_prefix  = var.destination_address_prefix_appgw
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}

resource "azurerm_network_security_rule" "All-Traffic-Inbound" {
  name                        = "All-Traffic-Intbound"
  priority                    = 108
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.source_address_prefix_appgw
  destination_address_prefix  = var.destination_address_prefix_appgw
  resource_group_name         = azurerm_resource_group.clax_general_network.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}
