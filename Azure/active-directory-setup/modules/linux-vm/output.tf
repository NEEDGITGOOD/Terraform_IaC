# Update your outputs accordingly
output "vm_id04" {
  value = azurerm_linux_virtual_machine.UbuntuVM.id
}

output "vm_public_ip04" {
  value       = azurerm_linux_virtual_machine.UbuntuVM.public_ip_address
  description = "Public IP address of the Windows VM01"
}