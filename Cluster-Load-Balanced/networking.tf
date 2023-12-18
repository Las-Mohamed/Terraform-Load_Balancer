resource "azurerm_virtual_network" "vnet" {
    name = "Vnet1"
    address_space = ["10.1.0.0/16"]
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
}

resource "azurerm_subnet" "subnet" {
  count = 2
  name = "Subnet-${count.index}"
  address_prefixes = ["10.1.1${count.index}.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}


resource "azurerm_network_interface" "nic" {
  count = 2
  name = "Nic-${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "Config"
    subnet_id = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.rg.name
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

resource "azurerm_subnet_network_security_group_association" "association" {
  count                     = 2
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.allowedports.id
}