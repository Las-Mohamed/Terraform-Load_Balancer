
resource "azurerm_resource_group" "rg-Cloud-Init" {
  name     = var.RgCloudInit
  location = var.location
}