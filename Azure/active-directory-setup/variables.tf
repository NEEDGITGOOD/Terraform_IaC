# Azure
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Location/Region of the Resource"
  type        = string
}


# Active Directory

## Domain Name
variable "ad_domain_name" {
  description = "Name for the Domain"
  type        = string
}

## Administrator Username
variable "adds_admin_username" {
  description = "Username for the Administrator Account"
  type        = string
}

## Administrator Passwort
variable "adds_admin_password" {
  description = "Password for the Administrator Account"
  type        = string
}





# Define other variables as needed