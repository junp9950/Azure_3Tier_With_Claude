output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.lb.ip_address
}

output "web_vm_public_ips" {
  description = "Public IP addresses of web VMs"
  value       = azurerm_public_ip.web[*].ip_address
}

output "web_vm_private_ips" {
  description = "Private IP addresses of web VMs"
  value       = azurerm_network_interface.web[*].private_ip_address
}

output "app_vm_private_ips" {
  description = "Private IP addresses of application VMs"
  value       = azurerm_network_interface.app[*].private_ip_address
}

output "mysql_server_fqdn" {
  description = "FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_database_name" {
  description = "Name of the MySQL database"
  value       = azurerm_mysql_flexible_database.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}