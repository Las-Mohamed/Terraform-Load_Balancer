# Import the data from the current Client (Tenant ID, user, etc..)
data "azurerm_client_config" "current" {}

# Creation of the Key Vault whith permissions
resource "azurerm_key_vault" "KV" {
  name                        = "The-Key-Vault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "purge", "recover", "restore", "set", 
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [ azurerm_resource_group.rg ]
}

# Creation of the secret
resource "azurerm_key_vault_secret" "vm_password" {
  name         = "VM-Password"
  value        = var.Admin_Password
  key_vault_id = azurerm_key_vault.example.id
  depends_on = [ azurerm_key_vault.KV ]
}
