#!/bin/bash

# Extract the private IP address from the terraform.tfstate file
IP_ADDRESS=$(jq -r '.resources[] | select(.name=="Docker01") .instances[0].attributes.ipv4_address_private' terraform.tfstate)

# Make a copy of the Docker Compose template file
cp /templates/docker-compose.yaml docker-compose.yaml

# Replace the placeholder in the Docker Compose file with the IP address
sed -i "s/PLACEHOLDER/${IP_ADDRESS}/g" docker-compose.yml
