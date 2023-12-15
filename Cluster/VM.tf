resource "azurerm_linux_virtual_machine" "vm" {
  count                           = 2
  name                            = "VM-${count.index}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = azurerm_key_vault_secret.vm_password.value
  computer_name                   = "nginx"
  custom_data = base64encode(file("../Cluster/init.sh"))
  #availability_set_id            = azurerm_availability_set.avset.id
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
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
    azurerm_resource_group.rg,
    azurerm_network_interface.nic,
    azurerm_key_vault_secret.vm_password ]
}