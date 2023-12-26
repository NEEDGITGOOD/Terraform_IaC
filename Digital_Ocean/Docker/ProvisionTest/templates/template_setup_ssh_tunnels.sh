#!/bin/bash
export PATH=$PATH:/usr/bin

# Doing the SSH Tunneling!

# Docker02
echo "Running SSH command...AUTOSSH Version for Docker02"
AUTOSSH_LOGLEVEL=7 autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "StrictHostKeyChecking=no" -f -N -L 2375:/var/run/docker.sock root@PLACEHOLDER_DOCKER02_IP_ADDRESS

# Docker03
echo "Running SSH command...AUTOSSH Version for Docker03"
AUTOSSH_LOGLEVEL=7 autossh -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "StrictHostKeyChecking=no" -f -N -L 2374:/var/run/docker.sock root@PLACEHOLDER_DOCKER03_IP_ADDRESS

# Adding the Environments!

# Token!
echo "Getting the Token!"
TOKEN=$(http POST localhost:9000/api/auth Username="admin" Password="admin01admin01" | jq -r ".jwt")
echo $TOKEN

# Docker02
echo "Adding Environment for Docker02..."
http --form POST http://localhost:9000/api/endpoints "Authorization: Bearer $TOKEN" Name='Docker02' URL='tcp://localhost:2375' EndpointCreationType=1

# Docker03
echo "Adding Environment for Docker03..."
http --form POST http://localhost:9000/api/endpoints "Authorization: Bearer $TOKEN" Name='Docker03' URL='tcp://localhost:2374' EndpointCreationType=1
