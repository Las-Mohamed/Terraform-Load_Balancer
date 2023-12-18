# These resources are created for testing Cloud init Config

# This section will perform cloud-init config for nginx packages 
data "template_cloudinit_config" "nginx_cloud_init" {
  gzip          = true
  base64_encode = true

 part {
   content_type = "text/cloud-config"
   content = "packages: ['nginx']"
 }
}

resource "azurerm_linux_virtual_machine" "cloud-init" {
  name                            = "VM-Cloud-Init"
  resource_group_name             = azurerm_resource_group.rg-Cloud-Init.name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = var.Admin_Password-Cloud-Init
  computer_name                   = "nginx"
  #availability_set_id            = azurerm_availability_set.avset.id
  disable_password_authentication = false
  # This will call the cloud-init custom data
  custom_data = data.template_cloudinit_config.nginx_cloud_init.rendered
  network_interface_ids = [
    azurerm_network_interface.nic-Cloud-Init.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  depends_on = [ 
    azurerm_resource_group.rg-Cloud-Init,
    azurerm_network_interface.nic-Cloud-Init ]
}