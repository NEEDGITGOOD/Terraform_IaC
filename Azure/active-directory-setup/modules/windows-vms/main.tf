# Create Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-VNET"
  address_space       = ["10.10.10.0/24"]
  location            = var.location
  resource_group_name = "${var.resource_group_name}"
}

# Create Subnet
resource "azurestack_subnet" "default" {
    name                = "${var.resource_group_name}-SN"
    resource_group_name = "${var.resource_group_name}"
    virtual_network_name = azurestack_virtual_network.vnet.name
    address_prefix       = "10.10.10.0/25"
}