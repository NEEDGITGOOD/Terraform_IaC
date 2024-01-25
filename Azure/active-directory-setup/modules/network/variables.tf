variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Location/Region of the Resource"
  type        = string
}

variable "dns_servers" {
  description = "List of IP addresses for DNS servers"
  type        = list(string)
}