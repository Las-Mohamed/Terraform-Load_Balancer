resource "azurerm_service_plan" "service_plan" {
  name                = "Last-service-plan-test"
  location            = azurerm_resource_group.rg-Web-App.location
  resource_group_name = azurerm_resource_group.rg-Web-App.name
  os_type = "Linux"
  sku_name = "P1v2"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "last-service-app-test"
  location            = azurerm_resource_group.rg-Web-App.location
  resource_group_name = azurerm_resource_group.rg-Web-App.name
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    always_on = true
  # Use container already builted instead of letting Azure build from your app code ---- > many errors during the build
  # WARNING : AZURE WEB APP EXPOSE AUTOMATICALLY & ONLY PORT 80 & 443 or use Cli command (az webapp config appsettings set --resource-group <resource-group-name> --name <app-name> --settings WEBSITES_PORT=<port_number>) 
    application_stack {
      docker_image     = "appsvcsample/python-helloworld"
      docker_image_tag = "latest"
      dotnet_version   = "6.0"
    }
  }
}
#  auth_settings {
#    enabled           = true
#    github {
#      client_id                  = "xxxxxxxxxxxxx"
#      client_secret              = "gxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#    } 
#  }
#  site_config {
#    always_on           = true
#    http2_enabled       = true
#    websockets_enabled  = true
#    application_stack {
#      python_version    = "3.9"
#    }
#  }
#
#}
#
#resource "azurerm_app_service_source_control" "source_control" {
#  app_id              = azurerm_linux_web_app.app_service.id
#  repo_url            = "https://github.com/Las-Mohamed/azuredevops_calculatrice"
#  branch              = "main"
#  use_manual_integration = true
#}
