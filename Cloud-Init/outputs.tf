output "rg_init" {
  value = azurerm_resource_group.rg-Cloud-Init.name
}

output "rg_init_location" {
  value = var.location
}

output "Ip_Init" {
  value = azurerm_public_ip.Cloud-init-IP.ip_address
}