variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "jeewoong-test-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Korea Central"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "./id_rsa.pub"
}

variable "mysql_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"
}

variable "web_vm_count" {
  description = "Number of web tier VMs"
  type        = number
  default     = 2
}

variable "app_vm_count" {
  description = "Number of application tier VMs"
  type        = number
  default     = 2
}

variable "vm_size_web" {
  description = "VM size for web tier"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_size_app" {
  description = "VM size for application tier"
  type        = string
  default     = "Standard_B2s"
}