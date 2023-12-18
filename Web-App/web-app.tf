resource "azurerm_service_plan" "service_plan" {
  name                = "Last-service-plan-test"
  location            = azurerm_resource_group.rg-Web-App.location
  resource_group_name = azurerm_resource_group.rg-Web-App.name
  os_type = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "last-service-app-test"
  location            = azurerm_resource_group.rg-Web-App.location
  resource_group_name = azurerm_resource_group.rg-Web-App.name
  service_plan_id = azurerm_service_plan.service_plan.id

  site_config {
    always_on = "false"
  }
#
 # app_settings = {
 #   "SOME_KEY" = "some-value"
 # }
#
 # connection_string {
 #   name  = "Database"
 #   type  = "SQLServer"
 #   value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
 # }
}