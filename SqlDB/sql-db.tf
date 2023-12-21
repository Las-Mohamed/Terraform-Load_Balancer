
resource "azurerm_resource_group" "rg" {
  name     = "Last-SQL-DB-RG"
  location = "francecentral"
}
# To manage the DB you need to install SSMS with th DB credentials you created
# "https://learn.microsoft.com/fr-fr/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16"

resource "azurerm_storage_account" "sto_acc" {
  name                     = "lastsqlstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "sql_srv" {
  name                         = "last-sql-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "Admtes"
  administrator_login_password = "Admin@123password"
}

resource "azurerm_mssql_database" "sql_db" {
  name           = "last-sql-db"
  server_id      = azurerm_mssql_server.sql_srv.id
#  collation      = "SQL_Latin1_General_CP1_CI_AS"
#  license_type   = "LicenseIncluded"
#  max_size_gb    = 4
#  read_scale     = true
  sku_name       = "Basic"
#  zone_redundant = true
#  enclave_type   = "VBS"

#  tags = {
#    foo = "bar"
#  }

  # prevent the possibility of accidental data loss
#  lifecycle {
#    prevent_destroy = true
#  }
}