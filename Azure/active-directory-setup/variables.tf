# Azure
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Location/Region of the Resource"
  type        = string
}


# AD

## Administrator Passwort
variable "administrator_password" {
  description = "Password for the Administrator Account"
  type        = string
}
# Define other variables as needed