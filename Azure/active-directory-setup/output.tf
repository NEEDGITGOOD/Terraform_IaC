output "virtual_machine_ip" {
  value = module.virtual-machines.virtual_machine_ip
  description = "The IP address of the created virtual machine."
}

# Define other outputs as needed