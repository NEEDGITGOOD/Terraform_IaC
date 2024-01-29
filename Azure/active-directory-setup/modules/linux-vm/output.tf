output "vm_id04" {
  value       = azurerm_windows_virtual_machine.vm01
  description = "The ID of the Windows VM01"
}

output "vm_public_ip04" {
  value       = azurerm_public_ip.vm_pip01.ip_address
  description = "Public IP address of the Windows VM01"
}