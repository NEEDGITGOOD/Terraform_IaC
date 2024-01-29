# Create Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-VNET01"
  address_space       = ["10.10.10.0/24"]
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers = var.dns_servers
}

## Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group_name}-SN01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.10.0/25"]
}

# Create Vnet for AADS
resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.resource_group_name}-VNET02"
  address_space       = ["10.10.20.0/24"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

## Create Subnet
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.resource_group_name}-SN02"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.10.20.0/25"]
}

# Create Security Group (Firewall) (for Windows Machines)
resource "azurerm_network_security_group" "nsg01" {
  name                = "${var.resource_group_name}-NSG01"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowRD"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "207.154.228.93"
    destination_address_prefix = "*"
  }
}

# Create Security Group (Firewall) (for AADS)
resource "azurerm_network_security_group" "nsg02" {
  name                = "${var.resource_group_name}-NSG02"
  location            = var.location
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
    name                       = "Allow"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.10.10.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPSRemoting"
    priority                   = 302
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

  
  security_rule {
    name                       = "AllowDNS"
    priority                   = 501
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

