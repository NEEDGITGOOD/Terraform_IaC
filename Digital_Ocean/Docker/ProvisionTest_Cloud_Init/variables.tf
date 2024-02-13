# Ubuntu: Set Password Variable for Ubuntu DockerFile
variable "ubuntu_password" {
  description = "Password for the ubuntu Docker Container/Dockerfile"
  type        = string
}

# Alma Linux: Set Password Variable for Alma Linux DockerFile
variable "alma_linux_password" {
  description = "Password for the Alma Linux Docker Container/Dockerfile"
  type        = string
}

# Kali Linux: Set Password Variable for Kali Linux DockerFile
variable "kali_linux_password" {
  description = "Password for the Kali Linux Docker Container/Dockerfile"
  type        = string
}