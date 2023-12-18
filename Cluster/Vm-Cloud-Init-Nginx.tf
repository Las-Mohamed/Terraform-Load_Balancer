# These resources are created for testing Cloud init Config

resource "azurerm_subnet" "subnet-cloudinit" {
  name = "Subnet-Cloud-Init"
  address_prefixes = ["10.1.12.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}


resource "azurerm_public_ip" "Cloud-init-IP" {
  name = "Ip-Cloud-Init"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_interface" "nic-Cloud-Init" {
  name = "Nic-Cloud-Init"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "Config"
    subnet_id = azurerm_subnet.subnet-cloudinit.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Cloud-init-IP.id
  }
depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_subnet_network_security_group_association" "cloud-init" {
  subnet_id                 = azurerm_subnet.subnet-cloudinit.id
  network_security_group_id = azurerm_network_security_group.allowedports.id
}

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
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = var.Admin_Password
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
    azurerm_resource_group.rg,
    azurerm_network_interface.nic-Cloud-Init ]
}