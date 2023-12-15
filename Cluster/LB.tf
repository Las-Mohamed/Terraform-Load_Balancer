
#resource "azurerm_availability_set" "avset" {
#  name                         = "avset"
#  location                     = azurerm_resource_group.rg.location
#  resource_group_name          = azurerm_resource_group.rg.name
#  platform_fault_domain_count  = 2
#  platform_update_domain_count = 2
#  managed                      = true
#}

resource "azurerm_public_ip" "IP_Pub" {
  name = "Ip-Pub-Load-Balancer"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_lb" "lb" {
  name                = "Load-Balancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.IP_Pub.id
  }
}

resource "azurerm_lb_backend_address_pool" "Bckpool" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_association" {
  count                   = 2
  backend_address_pool_id = azurerm_lb_backend_address_pool.Bckpool.id
  ip_configuration_name   = "Config"
  network_interface_id    = azurerm_network_interface.nic[count.index].id
}


resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "httprobe"
  port            = 80
}

resource "azurerm_lb_rule" "Lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRulehttp"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.Bckpool.id]
}

# Redirect traffic comming from port 80(LB) to port 80(VM)
#resource "azurerm_lb_nat_rule" "nat_rule" {
#  resource_group_name            = azurerm_resource_group.rg.name
#  loadbalancer_id                = azurerm_lb.lb.id
#  name                           = "HTTP"
#  protocol                       = "Tcp"
#  frontend_port                  = 80
#  backend_port                   = 80
#  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
#}

#        Redirect traffic comming from port 2222(LB) or 2223(LB) to port 22(VM)
#                 resource "azurerm_lb_nat_rule" "nat_rule" {
#                   count                          = 2
#                   resource_group_name            = azurerm_resource_group.kube.name
#                   loadbalancer_id                = azurerm_lb.klb.id
#                   name                           = "SSHAccess${count.index}"
#                   protocol                       = "Tcp"
#                   frontend_port                  = 222 + count.index
#                   backend_port                   = 22
#                   frontend_ip_configuration_name = "publicIPAddress"
#                 }

#                 resource "azurerm_network_interface_nat_rule_association" "natrules_association" {
#                   count                 = 2
#                   network_interface_id  = azurerm_network_interface.nic[count.index].id
#                   ip_configuration_name = "Config"
#                   nat_rule_id           = azurerm_lb_nat_rule.nat_rule.id
#                 }
