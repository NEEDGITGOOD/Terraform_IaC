output "public_ip" {
  value = digitalocean_droplet.HoneyPot01.ipv4_address
  description = "The public IP address of the droplet"
}
