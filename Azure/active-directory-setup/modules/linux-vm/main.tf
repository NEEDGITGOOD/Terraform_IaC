## Network Interface Card 01
resource "azurerm_network_interface" "ni01" {
  name                = "${var.vm_name}-ni01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal01"
    subnet_id                          = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip01.id
  }
}

## Associate NIC to Public IP 01
resource "azurerm_network_interface_security_group_association" "ni_nsg01" {
  network_interface_id      = azurerm_network_interface.ni01.id
  network_security_group_id = var.nsg_id01
}

## Create Public IP 01 (Windows Client01 - Win10)
resource "azurerm_public_ip" "vm_pip01" {
  name                = "${var.vm_name}-pip01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

### Create Windows VM 01
resource "azurerm_windows_virtual_machine" "vm01" {
  name                = "${var.vm_name}-Win10"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.ni01.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-22h2-pro"
    version   = "latest"
  }
}

### Create Windows VM 02
resource "azurerm_windows_virtual_machine" "vm02" {
  name                = "${var.vm_name}-Win11"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.ni02.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }
}

### Create Windows Server VM03
resource "azurerm_windows_virtual_machine" "vm03" {
  name                = "WinServer01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.ni03.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
