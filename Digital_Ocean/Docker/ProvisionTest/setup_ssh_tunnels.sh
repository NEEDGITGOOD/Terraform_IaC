#!/bin/bash

# Extract the private IP address from the terraform.tfstate file
IP_ADDRESS_DOCKER02=$(jq -r '.resources[] | select(.name=="Docker02") .instances[0].attributes.ipv4_address_private' terraform.tfstate)
IP_ADDRESS_DOCKER03=$(jq -r '.resources[] | select(.name=="Docker03") .instances[0].attributes.ipv4_address_private' terraform.tfstate)

# Make a copy of the Docker Compose template file
cp ./templates/template_setup_ssh_tunnels.sh ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_ADDRESS/${IP_ADDRESS_DOCKER02}/g" ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_ADDRESS/${IP_ADDRESS_DOCKER03}/g" ssh_tunnels.sh

# Template Creator for Dashy
cp ./templates/dashy_template.yml my-config.yml

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_ADDRESS/${IP_ADDRESS_DOCKER02}/g" my-config.yml

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_ADDRESS/${IP_ADDRESS_DOCKER03}/g" my-config.yml