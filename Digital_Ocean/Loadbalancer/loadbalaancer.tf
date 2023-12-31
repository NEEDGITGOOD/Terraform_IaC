resource "digitalocean_droplet" "www" {
  count = 2
  image = "ubuntu-20-04-x64"
  name = "www-${count.index + 1}"
  region = "nyc3"
  size = "s-1vcpu-1gb"
  user_data = file("${path.module}/cloud-init_nginx.yaml")
  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

resource "digitalocean_loadbalancer" "www-lb" {
  name = "www-lb"
  region = "nyc3"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = [for droplet in digitalocean_droplet.www : droplet.id]
}
