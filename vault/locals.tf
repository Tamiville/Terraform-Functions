locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "tamiville"
    environment = "Development"
    company     = "elitesolutionsit"
    ManagedWith = "terraform"
  }
}