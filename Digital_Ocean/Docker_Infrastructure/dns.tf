resource "digitalocean_domain" "portainer" {
   name = "portainer.${var.domain_dns}"
   ip_address = digitalocean_droplet.Docker01.ipv4_address
}

resource "digitalocean_domain" "monitor" {
   name = "monitor.${var.domain_dns}"
   ip_address = digitalocean_droplet.Docker01.ipv4_address
}

resource "digitalocean_domain" "blog" {
   name = "blog.${var.domain_dns}"
   ip_address = digitalocean_droplet.Docker01.ipv4_address
}

resource "digitalocean_domain" "db-admin" {
   name = "db-admin.${var.domain_dns}"
   ip_address = digitalocean_droplet.Docker01.ipv4_address
}