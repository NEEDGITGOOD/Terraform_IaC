output "adds_domain_name" {
  value       = azurerm_active_directory_domain_service.adds.domain_name
  description = "The domain name of the Active Directory Domain Services instance"
}

