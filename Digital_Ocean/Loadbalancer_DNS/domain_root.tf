resource "digitalocean_domain" "default" {
   name = "newworld.icu"
   ip_address = digitalocean_loadbalancer.www-lb.ip
}
