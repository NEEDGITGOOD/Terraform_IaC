resource "null_resource" "ssh_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -b 2048 -f ${path.module}/ssh_keys/id_rsa -q -N ''"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/ssh_keys/id_rsa ${path.module}/ssh_keys/id_rsa.pub"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "local_file" "public_key_trigger" {
  filename = "${path.module}/ssh_keys/public_key_trigger"
  content  = file("${path.module}/ssh_keys/id_rsa.pub")

  depends_on = [null_resource.ssh_key]
}

resource "digitalocean_ssh_key" "example" {
  name       = "my-ssh-key"
  public_key = file("${path.module}/ssh_keys/id_rsa.pub")
  depends_on = [local_file.public_key_trigger]
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "nginx-webserver"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.example.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              EOF

  depends_on = [digitalocean_ssh_key.example]
}


