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

## Create Public IP 04 (Ubuntu)
resource "azurerm_public_ip" "vm_pip04" {
  name                = "${var.vm_name}-pip04"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "UbuntuVM" {
  name                = "${var.vm_name}-Ubuntu01"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "UbuntuVM"
  admin_username      = var.admin_username

}