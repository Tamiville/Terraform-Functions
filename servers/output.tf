output "virtual_machine_public_ip_address" {
  value = data.azurerm_virtual_machine.existinglinuxvm.public_ip_address
}
