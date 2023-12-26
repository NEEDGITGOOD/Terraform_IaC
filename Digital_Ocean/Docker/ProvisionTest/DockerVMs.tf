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

 # Connect to the Docker02 VM, create ssh tunnel, add environment
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "echo Running SSH command...",
      "autossh -M 0 -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -f -N -L 2375:/var/run/docker.sock root@${digitalocean_droplet.Docker02.ipv4_address_private} -o \"StrictHostKeyChecking=no\" -o \"UserKnownHostsFile=/dev/null\""
    ]
  }
      #"autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -f -N -L 2375:/var/run/docker.sock root@10.114.0.2 -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"",
      #http --form POST http://localhost:9000/api/endpoints "Authorization: Bearer $TOKEN" Name="Docker03" URL="tcp://localhost:2375" EndpointCreationType=1


#autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -f -N -L 2375:/var/run/docker.sock root@10.114.0.2 -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null
# autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -f -N -L 2375:/var/run/docker.sock root@10.114.0.4

## Old exec
#      "autossh -M 0 -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -f -N -L 2375:/var/run/docker.sock root@${digitalocean_droplet.Docker03.ipv4_address_private} -o \"StrictHostKeyChecking=no\" -o \"UserKnownHostsFile=/dev/null\"",


#### This Work! (Manually!) (Lets try it in exec!)
### AutoSSH
## autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -f -N -L 2375:/var/run/docker.sock root@10.114.0.4

### SSH
# ssh -L 2375:/var/run/docker.sock root@10.114.0.2 -N



# AUTOSSH_LOGLEVEL=7 autossh -M 0 -v -o "ServerAliveInterval 30" -o "StrictHostKeyChecking=no" -o "ServerAliveCountMax 3" -N -L 2375:/var/run/docker.sock root@10.114.0.2
# Connect to the Docker03 VM, create ssh tunnel
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "echo Running SSH command...",
      "autossh -M 0 -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -f -N -L 2375:/var/run/docker.sock root@10.114.0.4 -o \"StrictHostKeyChecking=no\""
    ]
  }

  # Copy the script to the remote machine
  provisioner "file" {
    source      = "setup.sh"
    destination = "/root/setup.sh"
  }

# Run the script
provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup.sh",
      "export PATH=$PATH:/usr/bin",
      "echo Running my Script! command...",
      "bash /root/setup.sh"
    ]
}


    depends_on = [digitalocean_droplet.Docker02, digitalocean_droplet.Docker03]
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