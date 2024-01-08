resource "digitalocean_droplet" "netbox" {
  image = "netverity-netbox-20-04"
  name = "Netbox01"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

resource "digitalocean_firewall" "netbox_firewall" {
  name = "netbox-firewall"

  droplet_ids = [ 
    digitalocean_droplet.netbox.id,
  ]

 ## Inbound Rules

  ### Allow Inbound HTTPS (443)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["207.154.228.93"]
  }

  ### Allow Inbound ICMP
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["207.154.228.93"]
  }

 ## Outbound Rules (allow to any)

  ### Allow Outbound TCP (1-65535)
  outbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  ### Allow Outbound UDP (1-65535)
  outbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  ### Allow Outbound ICMP
  outbound_rule {
    protocol         = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}