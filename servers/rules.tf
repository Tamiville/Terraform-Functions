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
  resource_group_name         = azurerm_resource_group.clax_general_resources.name
  network_security_group_name = azurerm_network_security_group.clax_nsg.name
}