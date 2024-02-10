output "public_ips_www" {
  value = { for i, droplet in digitalocean_droplet.www : "www-${i+1}" => droplet.ipv4_address }
  description = "IP Addresses of Nginx Webservers"
}

output "public_ip_lb" {
  value = digitalocean_loadbalancer.www-lb.ip
  description = "Loadbalancer IP Address"
}
