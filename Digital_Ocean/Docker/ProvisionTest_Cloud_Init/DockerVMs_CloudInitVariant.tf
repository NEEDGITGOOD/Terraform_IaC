# Generate a new SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Upload the public key to DigitalOcean
resource "digitalocean_ssh_key" "docker01_ssh_file" {
  name       = "myKey"
  public_key = tls_private_key.ssh.public_key_openssh

    provisioner "local-exec" {
        command = "echo '${tls_private_key.ssh.private_key_pem}' > ./ssh/myKey.pem && chmod 400 ./ssh/myKey.pem"
    }
}

# Docker01 (Portainer)
resource "digitalocean_droplet" "Docker01" {
  image = "docker-20-04"
  name = "Docker01"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.docker01_ssh_file.id
  ]

  user_data = templatefile("cloud-init_docker01.yaml", {
    GITHUB_TOKEN = var.GITHUB_TOKEN
  })
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("./ssh/myKey.pem")
    timeout = "4m"
  }

  ## Upload Dashy Config File
  provisioner "file" {  
    source      = "my-config.yml"
    destination = "/root/my-config.yml"
  }

  ## Copy the docker-compose file to the VM
  provisioner "file" {  
    content     = file("${path.module}/templates/docker-compose-portainer.yaml") 
    destination = "/root/docker-compose.yml"
  }

  ## Create the .ssh directory (for the ssh file)
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/.ssh",  
    ]
  }

  ## Copy the ssh file to the VM
  provisioner "file" {  
    source      = "./ssh/myKey.pem"
    destination = "/root/.ssh/id_rsa"
  }

  ## Run Commands on the VM
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "chmod 600 ~/.ssh/id_rsa", # Change the permissions of the ssh file
      "http POST localhost:9000/api/users/admin/init Username=\"admin\" Password=\"admin01admin01\"" # Create the admin user
    ]
  }

  ## Copy the script to the remote machine (from my Host to the VM)
  provisioner "file" {
    source      = "ssh_tunnels.sh"
    destination = "/root/ssh_tunnels.sh"  
  }

  ## Run the ssh script
  provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin", 
        "chmod +x /root/ssh_tunnels.sh", # Make the script executable
        "echo Running my Script! command...", # Logging
        "bash /root/ssh_tunnels.sh" # Run the script
      ]
  }

  ## Ensure this runs after Docker02 and Docker03 are created
  depends_on = [
    digitalocean_droplet.Docker02,  # Wait for Docker02 and Docker03 to be created
    digitalocean_droplet.Docker03,
    null_resource.setup_ssh_tunnels, # Wait for the script to be created
    digitalocean_ssh_key.docker01_ssh_file
  ]
}

# SSH Tunnel Script Creator
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

# Docker02
resource "digitalocean_droplet" "Docker02" {
  image = "docker-20-04"
  name = "Docker02"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.docker01_ssh_file.id
  ]

    user_data = templatefile("cloud-init_docker01.yaml", {
    GITHUB_TOKEN = var.GITHUB_TOKEN
  })

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("./ssh/myKey.pem")
    timeout = "4m"
  }

    depends_on = [digitalocean_ssh_key.docker01_ssh_file]

}

# Docker03
resource "digitalocean_droplet" "Docker03" {
  image = "docker-20-04"
  name = "Docker03"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.docker01_ssh_file.id
  ]

    user_data = templatefile("cloud-init_docker03.yaml", {
    GITHUB_TOKEN = var.GITHUB_TOKEN
  })

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("./ssh/myKey.pem")
    timeout = "4m"
  }

  depends_on = [digitalocean_ssh_key.docker01_ssh_file]
}