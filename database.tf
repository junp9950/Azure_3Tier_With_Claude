# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "mysql" {
  name                = "mysql.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

# Private DNS Zone Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysqlVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = azurerm_resource_group.main.name
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  name                   = "jeewoong-test-mysql-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.data.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "main" {
  name                = "jeewoong_test_database"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}