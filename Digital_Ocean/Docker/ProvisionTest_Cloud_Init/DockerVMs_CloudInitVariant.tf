### Alma Linux

# Alma Linux: Set Password Variable for Alma Linux DockerFile
variable "alma_linux_password" {
  description = "Password for the Alma Linux Docker Container/Dockerfile"
  type        = string
}

# Alma Linux: Make Template out of Templatefile
data "template_file" "alma_linux_create_dockerfile" {
  template = file("${path.module}/templates/Dockerfile.alma_linux.tpl")

  vars = {
    USER_PASSWORD = var.alma_linux_password
  }
}

# Alma Linux: Create Template File locally so it can be referenced
resource "local_file" "alma_linux_save_dockerfile" {
  content  = data.template_file.alma_linux_create_dockerfile.rendered
  filename = "${path.module}/Dockerfiles/rendered_Dockerfile.alma_linux"
}

### Kali Linux

# Kali Linux: Set Password Variable for Kali Linux DockerFile
variable "kali_linux_password" {
  description = "Password for the Kali Linux Docker Container/Dockerfile"
  type        = string
}

# Kali Linux: Make Template out of Templatefile
data "template_file" "kali_linux_create_dockerfile" {
  template = file("${path.module}/templates/Dockerfile.kali_linux.tpl")

  vars = {
    USER_PASSWORD = var.kali_linux_password
  }
}

# Kali Linux: Create Template File locally so it can be referenced
resource "local_file" "kali_linux_save_dockerfile" {
  content  = data.template_file.kali_linux_create_dockerfile.rendered
  filename = "${path.module}/Dockerfiles/rendered_Dockerfile.kali_linux"
}

# Generate a new SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Upload the public key to DigitalOcean
resource "digitalocean_ssh_key" "temporary_ssh" {
  name       = "myPrivateKey"
  public_key = tls_private_key.ssh.public_key_openssh

    provisioner "local-exec" {
        command = "echo '${tls_private_key.ssh.private_key_pem}' > ./ssh/myKey.pem && chmod 400 ./ssh/myKey.pem"
    }
}

# Netbox01
resource "digitalocean_droplet" "Netbox01" {
  image = "netverity-netbox-20-04"
  name = "Netbox01"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.temporary_ssh.id
  ]

  user_data = "cloud-init_netbox01.yaml"
}

# Firewall for Netbox01
resource "digitalocean_firewall" "netbox_firewall" {
  name = "netbox-firewall"

  droplet_ids = [ 
    digitalocean_droplet.Netbox01.id,
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

  ### Allow Inbound ssh from jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["206.81.16.20"]
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

# Docker01 (Portainer)
resource "digitalocean_droplet" "Docker01" {
  image = "docker-20-04"
  name = "Docker01"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.temporary_ssh.id
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

  ## Copy the ssh file to the VM
  provisioner "file" {  
    source      = "./ssh/myKey.pem"
    destination = "/root/.ssh/id_rsa"
  }

  ## Wait for cloud-init to finish
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init on Docker01...'; sleep 1; done"
          ]
  }

    ## Upload Gatus Config File
  provisioner "file" {  
    source      = "gatus-config.yml"
    destination = "/root/config/config.yml"
  }

  ## Run Commands on the VM
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "bash setupDocker01IP.sh", # Run the Script, which changes the Docker01 Placeholder in the Gatos Config file to the Docker01 IP.
      "chmod 600 ~/.ssh/id_rsa", # Change the permissions of the ssh file
      "sudo docker compose -f /root/docker-compose.yaml up -d", # Run the docker-compose file
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
    digitalocean_ssh_key.temporary_ssh
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
    digitalocean_ssh_key.temporary_ssh.id
  ]
  
    connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("./ssh/myKey.pem")
    timeout = "4m"
  }
  
  ## Upload Rendered Dockerfile to the VM (Alma Linux)
  provisioner "file" {
    source      = local_file.alma_linux_save_dockerfile.filename
    destination = "/root/Dockerfile.alma_linux"
  }

  ## Upload Rendered Dockerfile to the VM (Kali Linux)
  provisioner "file" {
    source      = local_file.kali_linux_save_dockerfile.filename
    destination = "/root/Dockerfile.kali_linux"
  }

    user_data = templatefile("cloud-init_docker02.yaml", {
    GITHUB_TOKEN = var.GITHUB_TOKEN
  })

    depends_on = [digitalocean_ssh_key.temporary_ssh]

}


# Docker03
resource "digitalocean_droplet" "Docker03" {
  image = "docker-20-04"
  name = "Docker03"
  region = "fra1"
  size = "s-1vcpu-2gb"
  ssh_keys = [
    digitalocean_ssh_key.temporary_ssh.id
  ]

    user_data = templatefile("cloud-init_docker03.yaml", {
    GITHUB_TOKEN = var.GITHUB_TOKEN
  })

  depends_on = [digitalocean_ssh_key.temporary_ssh]
}