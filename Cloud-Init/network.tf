resource "azurerm_virtual_network" "vnet-Cloud-Init" {
    name = "Vnet1"
    address_space = ["10.1.0.0/16"]
    resource_group_name = azurerm_resource_group.rg-Cloud-Init.name
    location = var.location
}

resource "azurerm_subnet" "subnet-cloudinit" {
  name = "Subnet-Cloud-Init"
  address_prefixes = ["10.1.12.0/24"]
  resource_group_name = azurerm_resource_group.rg-Cloud-Init.name
  virtual_network_name = azurerm_virtual_network.vnet-Cloud-Init.name
}


resource "azurerm_public_ip" "Cloud-init-IP" {
  name = "Ip-Cloud-Init"
  location = var.location
  resource_group_name = azurerm_resource_group.rg-Cloud-Init.name
  allocation_method = "Static"
  sku = "Standard"
  # Create a domain name managed by Azure 
  domain_name_label = "last-init-test"
  
  depends_on = [azurerm_resource_group.rg-Cloud-Init]
}

resource "azurerm_network_interface" "nic-Cloud-Init" {
  name = "Nic-Cloud-Init"
  location = var.location
  resource_group_name = azurerm_resource_group.rg-Cloud-Init.name

  ip_configuration {
    name = "Config"
    subnet_id = azurerm_subnet.subnet-cloudinit.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Cloud-init-IP.id
  }
depends_on = [azurerm_resource_group.rg-Cloud-Init]
}


resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.rg-Cloud-Init.name
   location = var.location
  
   security_rule {
       name = "http"
       priority = 100
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "80"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "https"
       priority = 200
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "ssh"
       priority = 300
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
    security_rule {
       name = "all"
       priority = 400
       direction = "Inbound"
       access = "Allow"
       protocol = "*"
       source_port_range = "*"
       destination_port_range = "*"
       source_address_prefix = "VirtualNetwork"
       destination_address_prefix = "VirtualNetwork"
   }
}


resource "azurerm_subnet_network_security_group_association" "cloud-init" {
  subnet_id                 = azurerm_subnet.subnet-cloudinit.id
  network_security_group_id = azurerm_network_security_group.allowedports.id
}