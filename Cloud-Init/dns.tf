# This resource is usefull if you already bought an external domain name

# Put your domain name in "name"
resource "azurerm_dns_zone" "dns" {
  resource_group_name   = azurerm_resource_group.rg-Cloud-Init.name
  name                  = "<your_domain_name>"
  }

output "server_names" {
  value = azurerm_dns_zone.dns.name_servers
}

# Add the public IP of the target to associate with the domain name in "records",
# Add a prefix for the domaine name (if you want) in "name"
resource "azurerm_dns_a_record" "example" {
  name                = "www"
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg-Cloud-Init.name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.cloud-init.public_ip_address]
}
