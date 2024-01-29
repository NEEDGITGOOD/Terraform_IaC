module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}
module "network" {
  source = "./modules/network"
  
  resource_group_name = module.resource_group.resource_group_name
  location  = var.location
  dns_servers = module.active-directory.adds_domain_controller_ip_addresses
}

module "windows_vm" {
  source              = "./modules/windows-vms"
  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id = module.network.subnet_id
  vm_size             = "Standard_DS1_v2"
  admin_username      = var.windows_username
  admin_password      = var.windows_password
  nsg_id01            = module.network.nsg_id01
}

# Import Active Directory Module
module "active-directory" {
  source    = "./modules/active-directory-domain-services"
  subnet2_id = module.network.subnet2_id 
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  adds_domain_name    = var.adds_domain_name
  adds_admin_username = var.adds_admin_username
  adds_admin_password = var.adds_admin_password
  nsg_id    = module.network.nsg_id02
}

# Import Linux Module
module "linux-vm" {
  source    = "./modules/linux-vm"
  subnet_id = module.network.subnet_id
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  nsg_id    = module.network.nsg_id02
}