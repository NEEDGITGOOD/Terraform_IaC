#!/bin/bash

# Extract the private IP address from the terraform.tfstate file
IP_ADDRESS_DOCKER02=$(jq -r '.resources[] | select(.name=="Docker02") .instances[0].attributes.ipv4_address' terraform.tfstate)
IP_ADDRESS_DOCKER03=$(jq -r '.resources[] | select(.name=="Docker03") .instances[0].attributes.ipv4_address' terraform.tfstate)

# Extract the public IP address from the terraform.tfstate file

## Docker02
IP_ADDRESS_PUBLIC_DOCKER02=$(jq -r '.resources[] | select(.name=="Docker02") .instances[0].attributes.ipv4_address' terraform.tfstate)

## Docker03
IP_ADDRESS_PUBLIC_DOCKER03=$(jq -r '.resources[] | select(.name=="Docker03") .instances[0].attributes.ipv4_address' terraform.tfstate)

## Netbox
IP_ADDRESS_PUBLIC_NETBOX01=$(jq -r '.resources[] | select(.name=="Netbox01") .instances[0].attributes.ipv4_address' terraform.tfstate)

## Nginx 1
IP_ADDRESS_PUBLIC_NGINX01=$(jq -r '.resources[] | select(.name=="www-1") .instances[0].attributes.ipv4_address' ../../Loadbalancer_DNS/terraform.tfstate)

## Nginx 1
IP_ADDRESS_PUBLIC_NGINX02=$(jq -r '.resources[] | select(.name=="www-2") .instances[0].attributes.ipv4_address' ../../Loadbalancer_DNS/terraform.tfstate)

## Loadbalancer
IP_ADDRESS_PUBLIC_LOADBALANCER=$(jq -r '.resources[] | select(.name=="default") .instances[0].attributes.ip_address' ../../Loadbalancer_DNS/terraform.tfstate)

# Make a copy of the Docker Compose template file
cp ./templates/ssh_tunnels_template.sh ./rendered-templates/ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_ADDRESS/${IP_ADDRESS_DOCKER02}/g" ./rendered-templates/ssh_tunnels.sh

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_ADDRESS/${IP_ADDRESS_DOCKER03}/g" ./rendered-templates/ssh_tunnels.sh

###############################################

# Template Creator for Dashy

# Copy File
cp ./templates/dashy_template.yml ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER02}/g" ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER03}/g" ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Netbox01
sed -i "s/PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NETBOX01}/g" ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Nginx01
sed -i "s/PLACEHOLDER_NGINX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NGINX01}/g" ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Nginx02
sed -i "s/PLACEHOLDER_NGINX02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NGINX02}/g" ./rendered-templates/dashy-config.yml

# Replace the placeholder in the Template file with the IP address of Loadbalancer
sed -i "s/PLACEHOLDER_LOADBALANCER_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_LOADBALANCER}/g" ./rendered-templates/dashy-config.yml

###############################################

# Gatus Template

# Copy File
cp ./templates/gatus_template.yml ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Docker02
sed -i "s/PLACEHOLDER_DOCKER02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER02}/g" ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Docker03
sed -i "s/PLACEHOLDER_DOCKER03_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_DOCKER03}/g" ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Netbox01
sed -i "s/PLACEHOLDER_NETBOX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NETBOX01}/g" ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Nginx01
sed -i "s/PLACEHOLDER_NGINX01_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NGINX01}/g" ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Nginx02
sed -i "s/PLACEHOLDER_NGINX02_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_NGINX02}/g" ./rendered-templates/gatus-config.yml

# Replace the placeholder in the Template file with the IP address of Loadbalancer
sed -i "s/PLACEHOLDER_LOADBALANCER_IP_PUBLIC_ADDRESS/${IP_ADDRESS_PUBLIC_LOADBALANCER}/g" ./rendered-templates/gatus-config.yml