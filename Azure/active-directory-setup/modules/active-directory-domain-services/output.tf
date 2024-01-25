output "adds_domain_name" {
  value       = azurerm_active_directory_domain_service.adds.domain_name
  description = "The domain name of the Active Directory Domain Services instance"
}

output "adds_domain_controller_ip_addresses" {
  value = azurerm_active_directory_domain_service.adds.initial_replica_set[0].domain_controller_ip_addresses
}
