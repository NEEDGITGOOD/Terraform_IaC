output "vm_id01" {
  value       = azurerm_windows_virtual_machine.vm01
  description = "The ID of the Windows VM01"
}

output "vm_public_ip01" {
  value       = azurerm_public_ip.vm_pip01.ip_address
  description = "Public IP address of the Windows VM01"
}

output "vm_id02" {
  value       = azurerm_windows_virtual_machine.vm02
  description = "The ID of the Windows VM02"
}

output "vm_public_ip02" {
  value       = azurerm_public_ip.vm_pip02.ip_address
  description = "Public IP address of the Windows VM02"
}

output "vm_id03" {
  value       = azurerm_windows_virtual_machine.vm03
  description = "The ID of the Windows VM02"
}

output "vm_public_ip03" {
  value       = azurerm_public_ip.vm_pip03.ip_address
  description = "Public IP address of the Windows VM03"
}