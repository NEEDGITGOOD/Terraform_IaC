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
variable "adds_domain_name" {
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

## Windows-Vms | Subnet_ID
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

## Windows-Vms | Subnet_ID
variable "windows_password_client01" {
  description = "Windows Password Client01"
  type        = string
}

## Windows-Vms | Subnet_ID
variable "windows_password_client02" {
  description = "Windows Password Client02"
  type        = string
}