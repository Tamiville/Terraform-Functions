locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "tamiville"
    environment = "Development"
    company     = "elitesolutionsit"
    ManagedWith = "terraform"
  }
  rgappgw        = "clax"
  buildregion    = "centralus"
  existingvnet   = "clax_vnet"
  existingvnetrg = "clax_general_network"
  existingnsg    = "clax_nsg"
  existingrtb    = "clax_rt"
}