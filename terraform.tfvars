# Terraform variables file
resource_group_name = "rg-3tier-app"
location           = "Korea Central"
admin_username     = "adminuser"
ssh_public_key_path = "./id_rsa.pub"

# MySQL configuration
mysql_admin_username = "mysqladmin"
mysql_admin_password = "YourSecurePassword123!"

# VM configuration
web_vm_count = 2
app_vm_count = 2
vm_size_web  = "Standard_B1s"
vm_size_app  = "Standard_B2s"