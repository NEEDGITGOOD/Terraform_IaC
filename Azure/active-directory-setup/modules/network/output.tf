output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network"
}

output "vnet2_id" {
  value       = azurerm_virtual_network.vnet2.id
  description = "The ID of the virtual network"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "The ID of the subnet"
}

output "subnet2_id" {
  value       = azurerm_subnet.subnet2.id
  description = "The ID of the subnet"
}

output "nsg_id01" {
  value       = azurerm_network_security_group.nsg01.id
  description = "The ID of the Nework Security Group"
}

output "nsg_id02" {
  value       = azurerm_network_security_group.nsg02.id
  description = "The ID of the Nework Security Group"
}