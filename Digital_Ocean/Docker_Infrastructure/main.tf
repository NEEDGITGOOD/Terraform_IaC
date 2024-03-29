# Cloud Init for Docker01 (Portainer): Make Template out of Templatefile
data "template_file" "cloud_init_docker01_template" {
  template = file("${path.module}/templates/cloud-init_docker01_template.yaml")

  vars = {
    DOMAIN = var.domain_dns
  }
}

# Cloud Init for Docker01 (Portainer): Create Template File locally so it can be referenced
resource "local_file" "cloud_init_docker01_template_save" {
  content  = data.template_file.cloud_init_docker01_template.rendered
  filename = "${path.module}/rendered-templates/cloud-init_docker01.yaml"
}

# Alma Linux: Make Template out of Templatefile
data "template_file" "alma_linux_create_dockerfile" {
  template = file("${path.module}/dockerfiles/Dockerfile.alma_linux.tpl")

  vars = {
    USER_PASSWORD = var.alma_linux_password
  }
}

# Alma Linux: Create Template File locally so it can be referenced
resource "local_file" "alma_linux_save_dockerfile" {
  content  = data.template_file.alma_linux_create_dockerfile.rendered
  filename = "${path.module}/rendered-dockerfiles/rendered_Dockerfile.alma_linux"
}

#########

# Kali Linux: Make Template out of Templatefile
data "template_file" "kali_linux_create_dockerfile" {
  template = file("${path.module}/dockerfiles/Dockerfile.kali_linux.tpl")

  vars = {
    USER_PASSWORD = var.kali_linux_password
  }
}

# Kali Linux: Create Template File locally so it can be referenced
resource "local_file" "kali_linux_save_dockerfile" {
  content  = data.template_file.kali_linux_create_dockerfile.rendered
  filename = "${path.module}/rendered-dockerfiles/rendered_Dockerfile.kali_linux"
}

#########

# Ubuntu: Make Template out of Templatefile
data "template_file" "ubuntu_create_dockerfile" {
  template = file("${path.module}/dockerfiles/Dockerfile.ubuntu.tpl")

  vars = {
    USER_PASSWORD = var.ubuntu_password
  }
}

# Ubuntu: Create Template File locally so it can be referenced
resource "local_file" "ubuntu_save_dockerfile" {
  content  = data.template_file.ubuntu_create_dockerfile.rendered
  filename = "${path.module}/rendered-dockerfiles/rendered_Dockerfile.ubuntu"
}

#########

# Generate a new SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Upload the public key to DigitalOcean
resource "digitalocean_ssh_key" "temporarySSH" {
  name       = "myFPrivateKey"
  public_key = tls_private_key.ssh.public_key_openssh

    provisioner "local-exec" {
        command = "echo '${tls_private_key.ssh.private_key_pem}' > ./ssh/myKey.pem && chmod 600 ./ssh/myKey.pem"
    }
}

# Netbox01
resource "digitalocean_droplet" "Netbox01" {
  image = "netverity-netbox-20-04"
  name = "Netbox01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  user_data =  file("./cloud-init/cloud-init_netbox01.yaml")

  ssh_keys = [
    digitalocean_ssh_key.temporarySSH.id
  ]
}

# Docker02
resource "digitalocean_droplet" "Docker02" {
  image = "docker-20-04"
  name = "Docker02"
  region = "fra1"
  size = "s-1vcpu-1gb"
  user_data =  file("./cloud-init/cloud-init_docker02.yaml")
  ssh_keys = [
    digitalocean_ssh_key.temporarySSH.id
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
    destination = "/root/rendered-dockerfiles/Dockerfile.alma_linux"
  }

  ## Upload Rendered Dockerfile to the VM (Kali Linux)
  provisioner "file" {
    source      = local_file.kali_linux_save_dockerfile.filename
    destination = "/root/rendered-dockerfiles/Dockerfile.kali_linux"
  }
  
  ## Upload Rendered Dockerfile to the VM (Ubuntu)
  provisioner "file" {
    source      = local_file.ubuntu_save_dockerfile.filename
    destination = "/root/rendered-dockerfiles/Dockerfile.ubuntu"
  }
  
  depends_on = [
    digitalocean_ssh_key.temporarySSH,
  ]
}

# Docker03
resource "digitalocean_droplet" "Docker03" {
  image = "docker-20-04"
  name = "Docker03"
  region = "fra1"
  size = "s-1vcpu-1gb"
  user_data =  file("./cloud-init/cloud-init_docker03.yaml")
  ssh_keys = [
    digitalocean_ssh_key.temporarySSH.id
  ]

  depends_on = [digitalocean_ssh_key.temporarySSH]
}

# Create Dashy Config
resource "local_file" "dashy_config" {
  content  = templatefile("${path.module}/templates/dashy_template.yml", {
    PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker02.ipv4_address,
    PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker03.ipv4_address,
    PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS = digitalocean_droplet.Netbox01.ipv4_address,
  })
  filename = "${path.module}/rendered-templates/dashy-config.yml"
  
  # Ensure this runs after Docker02 and Docker03 are created
  depends_on = [
    digitalocean_droplet.Docker02,
    digitalocean_droplet.Docker03
  ]
}

# Create Gatus Config
resource "local_file" "gatus_config" {
  content  = templatefile("${path.module}/templates/gatus_template.yml", {
    PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker02.ipv4_address
    PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker03.ipv4_address
    PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS = digitalocean_droplet.Netbox01.ipv4_address
  })
  filename = "${path.module}/rendered-templates/gatus-config.yml"
  
  # Ensure this runs after Docker02 and Docker03 are created
  depends_on = [
    digitalocean_droplet.Docker02,
    digitalocean_droplet.Docker03
  ]
}

# Create AutoSSH Tunnels
resource "local_file" "autossh_config" {
  content  = templatefile("${path.module}/templates/ssh_tunnels_template.sh", {
    PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker02.ipv4_address
    PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS = digitalocean_droplet.Docker03.ipv4_address
  })
  filename = "${path.module}/rendered-templates/ssh_tunnels.sh"

  # Ensure this runs after Docker02 and Docker03 are created
  depends_on = [
    digitalocean_droplet.Docker02,
    digitalocean_droplet.Docker03
  ]
}

# Docker01 (Portainer)
resource "digitalocean_droplet" "Docker01" {
  image = "docker-20-04"
  name = "Docker01"
  region = "fra1"
  size = "s-1vcpu-1gb"
  user_data =  data.template_file.cloud_init_docker01_template.rendered

  ssh_keys = [
    digitalocean_ssh_key.temporarySSH.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("./ssh/myKey.pem")
    timeout = "4m"
  }

  ## Upload Dashy Config File
  provisioner "file" {  
    source      = "./rendered-templates/dashy-config.yml"
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
    source      = "./rendered-templates/gatus-config.yml"
    destination = "/root/config/config.yml"
  }

  ## Run Commands on the VM
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "bash setupDocker01IP.sh", # Run the Script, which changes the Docker01 Placeholder in the Gatos Config file to the Docker01 IP.
      "chmod 600 ~/.ssh/id_rsa", # Change the permissions of the ssh file
      "sudo docker compose -f /root/docker-compose.yaml up -d", # Run the docker-compose file
      "http --verify no POST https://localhost/api/users/admin/init Username=\"admin\" Password=\"admin01admin01\"" # Create the admin user
    ]
  }

  ## Copy the script to the remote machine (from my Host to the VM)
  provisioner "file" {
    source      = "./rendered-templates/ssh_tunnels.sh"
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
    local_file.autossh_config, # Wait for the autossh script to be created
    local_file.dashy_config, # Wait for the the Dashy config to be created
    local_file.gatus_config, # Wait for the the Gatus config to be created
    data.template_file.cloud_init_docker01_template,
    local_file.cloud_init_docker01_template_save,
    digitalocean_ssh_key.temporarySSH
  ]
}
