resource "digitalocean_droplet" "HoneyPot01" {
  image = "debian-11-x64"
  name = "HoneyPot01"
  region = "nyc3"
  size = "s-4vcpu-16gb-320gb-intel"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

resource "digitalocean_vpc" "example_vpc" {
  name     = "example-vpc"
  region   = "nyc3"
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_firewall" "honeypot_firewall" {
  name = "honeypot_firewall"

  droplet_ids = [ 
    digitalocean_droplet.HoneyPot01.id,
  ]

 ## Inbound Rules

  ### Allow Inbound TCP Honey Ports (1-64000)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-64000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  ### Allow Inbound UDP Honey Ports (1-64000)
  inbound_rule {
    protocol         = "udp"
    port_range       = "1-64000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  ### Allow Inbound UDP Webinterface Ports (64000 - 65535)
  inbound_rule {
    protocol         = "udp"
    port_range       = "64000-65535"
    source_addresses = ["207.154.228.93"]
  }

  ### Allow Inbound UDP Webinterface Ports (64000 - 65535)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "64000-65535"
    source_addresses = ["207.154.228.93"]
  }

  ### Allow Inbound ICMP
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
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