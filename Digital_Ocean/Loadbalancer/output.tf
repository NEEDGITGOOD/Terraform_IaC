output "public_ip_ww-1" {
  value = digitalocean_droplet.www-1.ipv4_address
  description = "Nginx Webserver 01"
}

output "public_ip_ww-2" {
  value = digitalocean_droplet.www-2.ipv4_address
  description = "Nginx Webserver 02"
}

#### Docker02 ####

output "public_ip_Docker02" {
  value = digitalocean_droplet.www-lb.ipv4_address
  description = "Loadbalancer"
}

