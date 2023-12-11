resource "digitalocean_droplet" "HoneyPot01" {
  image = "debian-11-x64"
  name = "HoneyPot01"
  region = "nyc3"
  size = "s-4vcpu-16gb-320gb-intel"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}
