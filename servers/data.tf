data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azurerm_subnet" "backendnetwork" {
  name                 = "application_subnet"
  virtual_network_name = local.existingvnet
  resource_group_name  = local.existingvnetrg
}

data "azurerm_key_vault_secret" "secret" {
  name         = "WINDOWSSERVERPASSWORD"
  key_vault_id = data.azurerm_key_vault.existing.id
}

data "azurerm_key_vault" "existing" {
  name                = "claxdevkeyvaultmaster"
  resource_group_name = "claxvault"
}

data "azurerm_network_security_group" "clax_nsg" {
  name                = "clax_nsg"
  resource_group_name = local.existingvnetrg
}