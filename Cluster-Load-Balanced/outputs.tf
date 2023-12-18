output "Rg_child_name" {
  value = azurerm_resource_group.rg.name
}

output "Rg_child_ocation" {
  value = var.location
}

output "Ip" {
  value = azurerm_public_ip.IP_Pub.ip_address
}
output "motdepasse" {
  value = azurerm_linux_virtual_machine.vm[0].admin_password
  sensitive = true
}

output "tenant" {
  value = data.azurerm_client_config.current.tenant_id
}