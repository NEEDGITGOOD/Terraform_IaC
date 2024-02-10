output "public_ip" {
  value = digitalocean_droplet.openvpn.ipv4_address
  description = "The public IP address of the droplet"
}
