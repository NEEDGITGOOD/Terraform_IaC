# Create Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-VNET01"
  address_space       = ["10.10.10.0/24"]
  location            = var.location
  resource_group_name = "${var.resource_group_name}"
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
    name                = "${var.resource_group_name}-SN01"
    resource_group_name = "${var.resource_group_name}"
    virtual_network_name = azurerm_subnet.subnet.name
    address_prefixes       = ["10.10.10.0/25"]
}

# Create Security Group (Firewall)
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_group_name}-NSG01"
  location            = azurerm_resource_group.deploy.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSyncWithAzureAD"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureActiveDirectoryDomainServices"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowRD"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "CorpNetSaw"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPSRemoting"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "AzureActiveDirectoryDomainServices"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowLDAPS"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "636"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
