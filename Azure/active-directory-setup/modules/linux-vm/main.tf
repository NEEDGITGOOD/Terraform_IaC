## Network Interface Card 01
resource "azurerm_network_interface" "ni04" {
  name                = "${var.vm_name}-ni04"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal04"
    subnet_id                          = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip04.id
  }
}

## Associate NIC to Public IP 01
resource "azurerm_network_interface_security_group_association" "ni_nsg04" {
  network_interface_id      = azurerm_network_interface.ni04.id
  network_security_group_id = var.nsg_id01
}

## Create Public IP 01 (Windows Client01 - Win10)
resource "azurerm_public_ip" "vm_pip04" {
  name                = "${var.vm_name}-pip04"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

### Create Windows VM 04
resource "azurerm_windows_virtual_machine" "vm04" {
  name                = "${var.vm_name}-Win10"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.ni04.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}