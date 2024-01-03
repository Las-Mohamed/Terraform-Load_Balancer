# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
# You can add your credentials here but the Best Practice is to use an external programm that will store your credentials - In this case Dl Azure CLI and authentificate
  features {}
}
