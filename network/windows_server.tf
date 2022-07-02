resource "azurerm_resource_group" "clax_general_resources" {
  name     = "clax_general_resources"
  location = "centralus"
}

resource "azurerm_network_interface" "claxdev_nic" {
  name                = "claxdev_nic"
  location            = azurerm_resource_group.clax_general_resources.location
  resource_group_name = azurerm_resource_group.clax_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.claxdev_pip.id
  }
}

resource "azurerm_public_ip" "claxdev_pip" {
  name                = "claxdev_pip"
  location            = azurerm_resource_group.clax_general_resources.location
  resource_group_name = azurerm_resource_group.clax_general_resources.name
  allocation_method   = "Static"

  tags = local.common_tags
}

resource "azurerm_windows_virtual_machine" "windows_server" {
  name                = join("-", ["windows", "server"])
  location            = azurerm_resource_group.clax_general_resources.location
  resource_group_name = azurerm_resource_group.clax_general_resources.name
  size                = "Standard_DS1"
  admin_username      = "claxadminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.claxdev_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}