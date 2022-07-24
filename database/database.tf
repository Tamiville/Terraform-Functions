resource "azurerm_storage_account" "claxdev_storageaccount" {
  name                     = join("", ["claxdev", "storageaccount"])
  resource_group_name      = azurerm_resource_group.clax_general_resources.name
  location                 = azurerm_resource_group.clax_general_resources.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "claxdevmssqlserver" {
  name                         = join("", ["claxdev", "mssql", "server"])
  resource_group_name          = azurerm_resource_group.clax_general_resources.name
  location                     = azurerm_resource_group.clax_general_resources.location
  version                      = "12.0"
  administrator_login          = join("", ["claxdev", "sqladmin"])
  administrator_login_password = azurerm_key_vault_secret.sql_server_password.value
}

resource "azurerm_mssql_database" "claxdev_database" {
  name           = join("_", ["claxdev", "database"])
  server_id      = azurerm_mssql_server.claxdevmssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
#   max_size_gb    = 4
  read_scale     = false
#   sku_name       = "S0"
  zone_redundant = false


  #extended_auditing_policy {
  #  storage_endpoint                        = azurerm_storage_account.claxdev_storageaccount.primary_blob_endpoint
  #  storage_account_access_key              = azurerm_storage_account.claxdev_storageaccount.primary_access_key
  #  storage_account_access_key_is_secondary = true
  #  retention_in_days                       = 6
  #}

  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "fwRule" {
  name             = join("", ["fwdevRule", "database"])
  server_id        = azurerm_mssql_server.claxdevmssqlserver.id
  start_ip_address = "82.76.59.177"
  end_ip_address   = "82.76.59.177"
}