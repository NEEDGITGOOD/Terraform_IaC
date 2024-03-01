# Set Domain
variable "domain_dns" {
  description = "The Domain Name for the DNS"
  type        = string
}

# Ubuntu: Set Password Variable for Ubuntu DockerFile
variable "ubuntu_password" {
  description = "Password for the Ubuntu Docker Container/Dockerfile"
  type        = string
  sensitive = true
}

# Alma Linux: Set Password Variable for Alma Linux DockerFile
variable "alma_linux_password" {
  description = "Password for the Alma Linux Docker Container/Dockerfile"
  type        = string
  sensitive = true
}

# Kali Linux: Set Password Variable for Kali Linux DockerFile
variable "kali_linux_password" {
  description = "Password for the Kali Linux Docker Container/Dockerfile"
  type        = string
  sensitive = true
}