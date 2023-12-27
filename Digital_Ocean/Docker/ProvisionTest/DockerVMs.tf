## Docker01 (Portainer)
resource "digitalocean_droplet" "Docker01" {
  image = "docker-20-04"
  name = "Docker01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "4m"
  }

  provisioner "file" {  
    content     = file("${path.module}/templates/docker-compose-portainer.yaml") # Copy the docker-compose file to the VM
    destination = "/root/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/.ssh",  # Create the .ssh directory (for the ssh file)
    ]
  }

  provisioner "file" {  
    content     = file("~/.ssh/id_rsa") # Copy the ssh file to the VM
    destination = "/root/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      #"sudo apt update", 
      "chmod 600 ~/.ssh/id_rsa", # Change the permissions of the ssh file
      "snap install http", # Need to install http to run the API calls (create the admin user etc.)
      "apt install autossh", # Need to install autossh to create the ssh tunnel
      "docker compose -f /root/docker-compose.yml up -d", # Run the docker-compose file
      "sudo ufw allow 9000", # Allow port 9000 for portainer
      "sudo ufw allow 2374", # Allow port 2374 for the ssh tunnel (Docker03)
      "http POST localhost:9000/api/users/admin/init Username=\"admin\" Password=\"admin01admin01\"" # Create the admin user
    ]
  }

  # Copy the script to the remote machine
  provisioner "file" {
    source      = "ssh_tunnels.sh"
    destination = "/root/ssh_tunnels.sh"
  }

# Run the script
provisioner "remote-exec" {
    inline = [
      "chmod +x /root/ssh_tunnels.sh",
      "export PATH=$PATH:/usr/bin",
      "echo Running my Script! command...",
      "bash /root/ssh_tunnels.sh"
    ]
}

depends_on = [
  digitalocean_droplet.Docker02,
  digitalocean_droplet.Docker03,
  null_resource.setup_ssh_tunnels
]
    }

# My SSH Tunnel Script Creator
resource "null_resource" "setup_ssh_tunnels" {
  # Run the script to create the dynamic SSH tunnel file
  provisioner "local-exec" {
    command = "bash setup_ssh_tunnels.sh"
  }

  # Ensure this runs after Docker02 and Docker03 are created
  depends_on = [
    digitalocean_droplet.Docker02,
    digitalocean_droplet.Docker03
  ]
}

## Docker02
resource "digitalocean_droplet" "Docker02" {
  image = "docker-20-04"
  name = "Docker02"
  region = "fra1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "4m"
  }

  provisioner "file" {
    content     = file("${path.module}/docker-compose.yaml") # Copy the docker-compose file to the VM
    destination = "/root/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      #"sudo apt update", 
      "docker compose -f /root/docker-compose.yaml up -d"
    ]
  }
}

## Docker03
resource "digitalocean_droplet" "Docker03" {
  image = "docker-20-04"
  name = "Docker03"
  region = "fra1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "4m"
  }

  provisioner "file" {
    content     = file("${path.module}/docker-compose.yaml") # Copy the docker-compose file to the VM
    destination = "/root/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      #"sudo apt update", 
      "docker compose -f /root/docker-compose.yaml up -d" # Run the docker-compose file
    ]
  }
}