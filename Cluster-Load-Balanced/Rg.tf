# Import the data from the current Client (Tenant ID, user, etc..)
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.Rgname
  location = var.location
}