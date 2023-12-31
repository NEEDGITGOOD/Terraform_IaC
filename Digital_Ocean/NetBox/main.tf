resource "digitalocean_droplet" "netbox" {
  image = "netverity-netbox-20-04"
  name = "VPN01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}