output "vm_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "The ID of the Windows VM"
}

output "vm_public_ip" {
  value       = azurerm_public_ip.vm_pip.ip_address
  description = "Public IP address of the Windows VM"
}
