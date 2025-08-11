# Web Tier Availability Set
resource "azurerm_availability_set" "web" {
  name                         = "jeewoong-test-avset-web"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  managed                      = true
  platform_fault_domain_count = 2
}

# Web Tier Network Interfaces
resource "azurerm_network_interface" "web" {
  count               = var.web_vm_count
  name                = "jeewoong-test-nic-web-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web[count.index].id
  }
}

# Backend Address Pool Association for Web VMs
resource "azurerm_network_interface_backend_address_pool_association" "web" {
  count                   = var.web_vm_count
  network_interface_id    = azurerm_network_interface.web[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

# Web Tier Virtual Machines (Nginx Reverse Proxy)
resource "azurerm_linux_virtual_machine" "web" {
  count               = var.web_vm_count
  name                = "jeewoong-test-vm-web-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size_web
  admin_username      = var.admin_username
  availability_set_id = azurerm_availability_set.web.id

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.web[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(file("${path.module}/scripts/web-setup.sh"))
}