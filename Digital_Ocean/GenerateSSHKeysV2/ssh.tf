# Generate a new SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "nginx-webserver"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.docker03_ssh_file.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              EOF

  depends_on = [digitalocean_ssh_key.docker03_ssh_file]
}