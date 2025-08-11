# WAS Tier Availability Set
resource "azurerm_availability_set" "app" {
  name                         = "jeewoong-test-avset-app"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  managed                      = true
  platform_fault_domain_count = 2
}

# WAS Tier Network Interfaces
resource "azurerm_network_interface" "app" {
  count               = var.app_vm_count
  name                = "jeewoong-test-nic-app-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

# WAS Tier Virtual Machines (Tomcat)
resource "azurerm_linux_virtual_machine" "app" {
  count               = var.app_vm_count
  name                = "jeewoong-test-vm-app-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size_app
  admin_username      = var.admin_username
  availability_set_id = azurerm_availability_set.app.id

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.app[count.index].id,
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

  custom_data = base64encode(file("${path.module}/scripts/app-setup.sh"))
}