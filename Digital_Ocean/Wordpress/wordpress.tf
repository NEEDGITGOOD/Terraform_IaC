resource "digitalocean_droplet" "wordpress" {
  image = "wordpress-20-04"
  name = "Wordpress01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

