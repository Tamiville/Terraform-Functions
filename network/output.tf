output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}
output "virtual_network_name" {
  value = data.azurerm_virtual_network.vnet.name
}

