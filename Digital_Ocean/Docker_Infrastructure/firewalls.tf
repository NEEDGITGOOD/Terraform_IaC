# Firewall for Netbox01
resource "digitalocean_firewall" "netbox_firewall" {
  name = "netbox-firewall"

  droplet_ids = [ 
    digitalocean_droplet.Netbox01.id,
  ]

 ## Inbound Rules

  ### Allow Inbound ssh from jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  ### Allow Inbound HTTPS (443)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound ICMP
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
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

# Firewall for Docker01
resource "digitalocean_firewall" "docker01_firewall" {
  name = "docker01-firewall"

  droplet_ids = [ 
    digitalocean_droplet.Docker01.id,
  ]

 ## Inbound Rules


  ### Allow Inbound to Portainer (443) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  ### Allow Inbound to Dashy (80) from VPN IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  ### Allow Inbound to Gatus (8080) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0"]
  }

  ### Allow Inbound ssh from jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
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

# Firewall for Docker02
resource "digitalocean_firewall" "docker02_firewall" {
  name = "docker02-firewall"

  droplet_ids = [ 
    digitalocean_droplet.Docker02.id,
  ]

 ## Inbound Rules

  ### Allow Inbound to Ubuntu SSH (2222) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "2222"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound to Alma Linux SSH (2223) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "2223"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound to Kali SSH (2224) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "2224"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound ICMP
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound ssh from jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
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

# Firewall for Docker03
resource "digitalocean_firewall" "docker03_firewall" {
  name = "docker03-firewall"

  droplet_ids = [ 
    digitalocean_droplet.Docker03.id,
  ]

 ## Inbound Rules

  ### Allow Inbound to AdGuard WebUI (80) from VPN IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound to Wordpress WebUI (8080) from VPN IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound to ADGuard Konfiguration WebUI (3000) from VPN
  inbound_rule {
    protocol         = "tcp"
    port_range       = "3000"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound to ADGuard DNS (3000) from VPN
  inbound_rule {
    protocol         = "udp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound ICMP
  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
  }

  ### Allow Inbound ssh from jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "${digitalocean_droplet.Docker01.ipv4_address}"]
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
