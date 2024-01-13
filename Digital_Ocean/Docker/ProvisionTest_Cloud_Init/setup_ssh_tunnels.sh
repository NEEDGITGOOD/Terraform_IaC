#!/bin/bash

# Extract the private IP address from the terraform.tfstate file
IP_ADDRESS_DOCKER02=$(jq -r '.resources[] | select(.name=="Docker02") .instances[0].attributes.ipv4_address_private' terraform.tfstate)
IP_ADDRESS_DOCKER03=$(jq -r '.resources[] | select(.name=="Docker03") .instances[0].attributes.ipv4_address_private' terraform.tfstate)

# Extract the public IP address from the terraform.tfstate file
IP_ADDRESS_PUBLIC_DOCKER02=$(jq -r '.resources[] | select(.name=="Docker02") .instances[0].attributes.ipv4_address' terraform.tfstate)
IP_ADDRESS_PUBLIC_DOCKER03=$(jq -r '.resources[] | select(.name=="Docker03") .instances[0].attributes.ipv4_address' terraform.tfstate)

## Netbox
IP_ADDRESS_PUBLIC_NETBOX01=$(jq -r '.resources[] | select(.name=="Netbox01") .instances[0].attributes.ipv4_address' terraform.tfstate)

# Make a copy of the Docker Compose template file
cp ./templates/template_setup_ssh_tunnels.sh ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_ADDRESS/${IP_ADDRESS_DOCKER02}/g" ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_ADDRESS/${IP_ADDRESS_DOCKER03}/g" ssh_tunnels.sh

###############################################

# Template Creator for Dashy

# Copy File
cp ./templates/dashy_template.yml my-config.yml

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER02}/g" my-config.yml

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER03}/g" my-config.yml

# Replace the placeholder in the Template file with the IP address of Netbox01
sed -i "s/PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NETBOX01}/g" my-config.yml


###############################################

# Gatus Template

# Copy File
cp ./templates/gatus-config_template.yml gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER02}/g" my-config.yml

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER03}/g" my-config.yml

# Replace the placeholder in the Template file with the IP address of Netbox01
sed -i "s/PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NETBOX01}/g" my-config.yml