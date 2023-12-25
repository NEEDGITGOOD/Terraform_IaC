#!/bin/bash
export PATH=$PATH:/usr/bin
# Optioanl add the SSH Section!

# Docker02
echo "Adding Environment for Docker02..."
TOKEN=$(http POST localhost:9000/api/auth Username="admin" Password="admin01admin01" | jq -r ".jwt")
echo $TOKEN
http --form POST http://localhost:9000/api/endpoints "Authorization: Bearer $TOKEN" Name='Docker02' URL='tcp://localhost:2375' EndpointCreationType=1

# Docker03
echo "Adding Environment for Docker03..."
TOKEN=$(http POST localhost:9000/api/auth Username="admin" Password="admin01admin01" | jq -r ".jwt")
echo $TOKEN
http --form POST http://localhost:9000/api/endpoints "Authorization: Bearer $TOKEN" Name='Docker03' URL='tcp://localhost:2374' EndpointCreationType=1
