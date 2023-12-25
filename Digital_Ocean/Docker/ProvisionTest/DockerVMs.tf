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
      "sudo apt update", 
      "chmod 600 ~/.ssh/id_rsa", # Change the permissions of the ssh file
      "snap install http", # Need to install http to run the API calls (create the admin user etc.)
      "docker compose -f /root/docker-compose.yml up -d", # Run the docker-compose file
      "sudo ufw allow 9000" # Allow port 9000 for portainer
    ]
  }

# Connect to the Docker02 VM and create a tunnel to the Docker daemon
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "nohup ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -L 2375:/var/run/docker.sock root@${digitalocean_droplet.Docker02.ipv4_address_private} -N &" 
    ]
  }

# This is the same as the above command, but for the third VM
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin", 
      "nohup ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -L 2375:/var/run/docker.sock root@${digitalocean_droplet.Docker03.ipv4_address_private} -N &"
    ]
  }

  depends_on = [digitalocean_droplet.Docker02, digitalocean_droplet.Docker03]
}

## Run the Local script
resource "null_resource" "update_docker_compose" {
  depends_on = [digitalocean_droplet.Docker01]

  provisioner "local-exec" {
    command = "./update_docker_compose.sh"
  }
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
      "sudo apt update",
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
      "sudo apt update",
      "docker compose -f /root/docker-compose.yaml up -d" # Run the docker-compose file
    ]
  }
}