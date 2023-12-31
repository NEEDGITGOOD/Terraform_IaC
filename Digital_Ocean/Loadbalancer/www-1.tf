resource "digitalocean_droplet" "www-1" {
  image = "ubuntu-20-04-x64"
  name = "www-2"
  region = "nyc3"
  size = "s-1vcpu-1gb"
  user_data = file("${path.module}/cloud-init_nginx.yaml")
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}