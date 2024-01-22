output "resource_group_name" {
  value       = azurerm_resource_group.resource_group_name.name
  description = "The name of the resource group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.resource_group_name.location
  description = "The location of the resource group"
}

output "resource_group_id" {
  value       = azurerm_resource_group.resource_group_name.id
  description = "The ID of the resource group"
}
