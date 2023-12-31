output "public_ips_www" {
  value = { for i, droplet in digitalocean_droplet.www : "www-${i+1}" => droplet.ipv4_address }
  description = "IP Addresses of Nginx Webservers"
}
