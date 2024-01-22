provider "azurerm" {
  features {}
}

module "network" {
  source = "./modules/network"
  
  location  = var.location
  resource_group_name =  var.resource_group_name
}

module "virtual-machines" {
  source = "./modules/virtual-machines"
  # Pass necessary variables
}

# Import Active Directory Module
module "active-directory" {
  source = "./modules/active-directory"

  ad_domain_name     = var.ad_domain_name
  ad_admin_username  = var.ad_administrator_username
  ad_admin_password  = var.ad_administrator_password
}

module "client-join" {
  source = "./modules/client-join"
  # Pass necessary variables
}
