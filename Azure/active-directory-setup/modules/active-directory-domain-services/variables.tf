variable "adds_domain_name" {
  description = "The domain name for the Active Directory Domain Services instance"
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

variable "nsg_id" {
  description = "Network Security Group ID to associate with the subnet"
  type        = string
}

variable "location" {
  description = "The Azure region where the AD DS instance will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AD DS instance"
  type        = string
}

variable "subnet2_id" {
  description = "The ID of the subnet for the Active Directory Domain Services"
  type        = string
}