provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "./modules/resource_group"
  
  resource_group_name     = var.resource_group_name
  location  = var.location
}

module "network" {
  source = "./modules/network"
  
  resource_group_name = module.resource_group.name
  location  = var.location
}

module "virtual-machines" {
  source = "./modules/virtual-machines"

  resource_group_name = module.resource_group.name
  location  = var.location
}

# Import Active Directory Module
module "active-directory" {
  source = "./modules/active-directory-domain-services"

  resource_group_name = module.resource_group.name
  location  = var.location

  adds_domain_name     = var.adds_domain_name
  adds_admin_username  = var.adds_admin_username
  adds_admin_password  = var.adds_admin_password
}

module "client-join" {
  source = "./modules/client-join"

  resource_group_name = module.resource_group.name
  location  = var.location

}

module "windows-vms" {
  source = "./modules/windows-vms"

  resource_group_name = module.resource_group.name
  location  = var.location

}
