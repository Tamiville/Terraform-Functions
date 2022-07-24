# terraform {
#   backend "azurerm" {
#     resource_group_name  = "claxdev_state"
#     storage_account_name = "claxdevstorage"
#     container_name       = "claxdevcontainer"
#     key                  = "servers.terraform.tfstate"
#   }
# }