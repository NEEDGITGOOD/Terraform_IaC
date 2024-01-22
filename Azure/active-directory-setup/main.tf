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

module "active-directory" {
  source = "./modules/active-directory"

  ad_domain_name     = "example.com"
  ad_admin_username  = "admin"
  ad_admin_password  = var.ad_admin_password
  # Pass other necessary variables as needed
}

module "client-join" {
  source = "./modules/client-join"
  # Pass necessary variables
}
