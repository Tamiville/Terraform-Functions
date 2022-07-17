resource "azurerm_network_interface" "clax_linux_nic" {
  name                = join("-", [local.server, "linux", "nic"])
  location            = local.buildregion
  resource_group_name = azurerm_resource_group.clax_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.backendnetwork.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.clax_linux_pip.id
  }
}

resource "azurerm_public_ip" "clax_linux_pip" {
  name                = join("-", [local.server, "linux", "pip"])
  resource_group_name = azurerm_resource_group.clax_general_resources.name
  location            = local.buildregion
  allocation_method   = "Static"

  tags = local.common_tags
}


resource "azurerm_linux_virtual_machine" "Linux_vm" {
  name                = join("-", [local.server, "linux", "vm"])
  resource_group_name = azurerm_resource_group.clax_general_resources.name
  location            = local.buildregion
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.clax_linux_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.path_to_publickey)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}