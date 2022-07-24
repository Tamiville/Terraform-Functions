resource "azurerm_resource_group" "statestorage" {
  name     = var.statestorage
  location = local.buildregion
}

resource "azurerm_storage_account" "statestorage_account" {
  name                     = var.statestorage_account
  resource_group_name      = azurerm_resource_group.statestorage.name
  location                 = azurerm_resource_group.statestorage.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.common_tags
}

resource "azurerm_storage_container" "claxdevcontainer" {
  name                  = join("", ["clax", "dev", "container"])
  storage_account_name  = azurerm_storage_account.statestorage_account.name
  container_access_type = "private"
}
