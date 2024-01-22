provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/network"
  
  resource_group_name = module.resource_group.name

  location  = var.location
}

module "virtual-machines" {
  source = "./modules/virtual-machines"

  resource_group_name = module.resource_group.name
}

# Import Active Directory Module
module "active-directory" {
  source = "./modules/active-directory"

  resource_group_name = module.resource_group.name

  ad_domain_name     = var.ad_domain_name
  ad_admin_username  = var.ad_administrator_username
  ad_admin_password  = var.ad_administrator_password
}

module "client-join" {
  source = "./modules/client-join"

  resource_group_name = module.resource_group.name
}
