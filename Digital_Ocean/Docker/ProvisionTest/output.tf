output "public_ip_Docker01" {
  value = digitalocean_droplet.Docker01.ipv4_address
  description = "Public IP of Docker01"
}

output "private_ip_Docker01" {
  value = digitalocean_droplet.Docker01.ipv4_address_private
  description = "Private IP of Docker01"
}

#### Docker02 ####

output "public_ip_Docker02" {
  value = digitalocean_droplet.Docker02.ipv4_address
  description = "Public IP of Docker02"
}

output "private_ip_Docker02" {
  value = digitalocean_droplet.Docker02.ipv4_address_private
  description = "Private IP of Docker02"
}

#### Docker03 ####

output "public_ip_Docker03" {
  value = digitalocean_droplet.Docker03.ipv4_address
  description = "Public IP of Docker03"
}

output "private_ip_Docker03" {
  value = digitalocean_droplet.Docker03.ipv4_address_private
  description = "Private IP of Docker03"
}