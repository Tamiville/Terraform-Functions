# resource "azuread_group" "admingroup" {
#   display_name     = "admingroup"
#   owners           = [data.azuread_client_config.current.object_id]
#   security_enabled = true
# }