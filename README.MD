# Overview
Welcome to the IaC_Project repository! This project is focused on building a real-world hybrid infrastructure combining on-prem, Azure, and DigitalOcean environments. The goal is to deploy infrastructure automatically with minimal manual intervention.

# Table of Contents
- [Project Objective](#Project-Objectives)
- [Repository Structure](#Repository-Structure)
- [Network Plan](#Network-Plan)
- [Usage](#Usage)
- [Tasks](#Tasks)

# Project Objectives
- Building a hybrid infrastructure across Azure and DigitalOcean.
- Introducing security elements like honeypots and logging.
- Automating deployment processes.

# Repository Structure
- [**Azure**](/Config%20Files/Azure): Terraform scripts for Azure services like VMs, Active Directory, etc.
	- [Windows VM](/Config%20Files/Azure/Windows_VM)
	- [Ressource Group](/Config%20Files/Azure/ResourceGroup)
	- [Virtual Network + Ressource Group](/Config%20Files/Azure/VirtualNetwork_RSG)
	- [Premade_AD_WinVMs](/Config%20Files/Azure/Premade_AD_WINVMS)
	- [yeaaa_copied_azure_vm_ad_join](/Config%20Files/Azure/yeaaa_copied_azure_vm_ad_join)

- [**Digital Ocean**](/Config%20Files/Digital%20Ocean): Terraform scripts for Digital Ocean configurations.
	- [Docker](/Config%20Files/Digital%20Ocean/Docker)
		- [Nginx](/Config%20FIles/Digital%20Ocean/Docker/Nginx)
		- [Wordpress](/Config%20FIles/Digital%20Ocean/Docker/Wordpress)
		- [Uptime Kuma](#)
	- [Nginx](/Config%20Files/Digital%20Ocean/Nginx)
	- [Wordpress](/Config%20Files/Digital%20Ocean/Wordpress)
	- [Netbox](/Config%20Files/Digital%20Ocean/Netbox)
	- [MC Server](/Config%20Files/Digital%20Ocean/MC%20Server)
	- [Portainer Community Edition](/Config%20Files/Digital%20Ocean/Portainer%20Community)
	- [TPot Honeypot](/Config%20Files/Digital%20Ocean/TPot)
	- [OpenVPN](/Config%20Files/Digital%20Ocean/OpenVPN)
	- [Cert Manager](/Config%20Files/Digital%20Ocean/Cert%20Manager)
	- [Promotheus](/Config%20Files/Digital%20Ocean/Promotheus)
	- [MySQL](/Config%20Files/Digital%20Ocean/MySQL)
	- [Ubuntu](/Config%20Files/Digital%20Ocean/Ubuntu)
	- [Loadbalancer](/Config%20Files/Digital%20Ocean/Loadbalancer_Nginx)

- [**Docker**](/Config%20Files/Docker): Scripts for Docker deployments.
	- [Nginx](/Config%20Files/Docker/Nginx)
	- [Wordpress](/Config%20Files/Docker/Wordpress_Other_Hosts)

***

# Network Plan

(Insert TerraformGraph?)

```bash
# Digital Ocean Infrastructure

## Docker Hosts, maybe even deply them as a swarm?
Docker01 - Docker Digital Ocean Image: (1/2gb machine)
	Portainer
	(CentOS Machine)
	(Dashy)

Docker02 - Docker Digital Ocean Image: (1/2gb machine)
	Docker Portainer Agent
	Ubuntu Machine
	(Uptime Kuma)
	(Watch Tower)

Docker02 - Docker Digital Ocean Image: (1/2gb machine)
	Docker Portainer Agent
	Wordpress
	(Kali VM)
	(Adguard)

	# Unsure
	MS SQL

## Nginx LoadBalancer Setup with DNS Management (Digital Ocean, Cloudflare)
Nginx02 - Docker Digital Ocean Image: (1/2gb machine)
Nginx02 - Docker Digital Ocean Image: (1/2gb machine)
LoadBalancer01

## HoneyPot Might not be automatically deployable
T-Pot - Debian Digital Ocean Image
	s-4vcpu-16gb-320gb-intel machine

## MC Server
MC Server - MC Server Digital Ocean Image (8gb)

## VPN Gateway - VPN01
Use OpenVPN Gateway Image from Digital Ocean

# Netbox
Netbox DO Image

# Unsure & maybe do this aswell on the Digital Ocean DockerXX Hosts? 
Promotheus - Docker Digital Ocean Image: (xx machine)
Grafana  - Docker Digital Ocean Image: (xx machine)
MS SQL
CertBot

# Azure Infrastructure
## Windows Infrastructure

DC (AD Server)- Azure Microsoft Entra Domain Services

	WindowsClient01
	WindowsClient02
	WindowsClient03

VPN Gateway - VPN02

# Optional
Linux VM - Linux01
```

# Usage

1. Clone the repository:
```bash
git clone https://github.com/the-worldmainplayer/IaC_Project.git
```

2. Navigate to the desired configuration directory, for example:
```bash
cd IaC_Project/Azure/VM_Setup
```

3. Initialize Terraform:
```bash
terraform init
```

# Tasks

## Organizational.
- [x] Setup GitHub Repo
- [ ] Create Networkplan
- [x] Define Objective
- [x] Create To-Do List

***

## VMs (Digital Ocean)

### [Ubuntu](/Config%20Files/Ubuntu)
- [x] Creating an Ubuntu VM in Digital Ocean 

[Official Dokumentation](https://marketplace.digitalocean.com/apps/Ubuntu)

---

### Docker

Thoughts: Instead of using the Digital Ocean Nginx Image use the Docker Image and then deploy: Agent, Portainer (on one Server), and then Nginx Images etc. That way you can utilize Portainer way better.

[Overview](https://github.com/the-worldmainplayer/IaC_Project/blob/master/Config%20Files/Docker)

[Official Dokumentation](https://marketplace.digitalocean.com/apps/docker)

#### Docker Provider - Same Host
- [x] [Nginx](./Config%20Files/Docker/Nginx_Same_Host)
- [x] [WordPress](./Config%20Files/Docker/Nginx_Same_Host)

**Info**: Seems to be really straightforward, can basically just edit the "image" section. That's why both point to the same Tutorial.

#### Docker Image - External host
- [x] [Nginx](./Config%20Files/Digital%20Ocean/Docker/Nginx)
- [x] [Wordpress](./Config%20Files/Digital%20Ocean/Docker/Wordpress)

**Info**: Basically you create an Docker Digital Ocean host via Terraform and then via Commandline Arg oder other Parameters you create the Container on the host you have created

---

### Nginx

[Official Dokumentation](https://marketplace.digitalocean.com/apps/nginx)

- [x] [Nginx](./Config%20Files/Digital%20Ocean/Nginx)
- [x] [Nginx + Loadbalancer](./Config%20Files/Digital%20Ocean/Loadbalancer_Nginx)

**Optional**:
- [ ] Create an Static HTML and upload it and then try it with that.
        - What: Wordpress/Nginx
        - Upload HTML to the Server (scp should work with key) the HTML needs to be uploaded to the Wordpress/Nginx Directory.

---

### Wordpress

- [x] [Wordpress](./Config%20Files/Digital%20Ocean/Wordpress)

[Official Dokumentation](https://marketplace.digitalocean.com/apps/docker)

---

###  Netbox
- [ ] [NetBox](./Config%20Files/Digital%20Ocean/Netbox/README.MD) 

[Official Dokumentation](https://marketplace.digitalocean.com/apps/netbox)

---

### MC Server
- [ ] [MC Server](./Config%20Files/Digital%20Ocean/MC%20Server/README.MD)

[Official Dokumentation](https://marketplace.digitalocean.com/apps/minecraft-java-edition-server)

---

### Portainer
- [ ] [Portainer Community Edition](./Config%20Files/Digital%20Ocean/Portainer%20Community%20Edition)

[Official Dokumentation](https://marketplace.digitalocean.com/apps/portainer-community-edition)

---

### TPot / Honeypot
- [x] [TPot](./Config%20Files/Digital%20Ocean/TPot)

[Official Dokumentation](https://github.com/telekom-security/tpotce)

Info: Based on the Digital Ocean Debian Image

---

### OpenVPN Access Server
- [x] [OpenVPN Access Server](./Config%20Files/Digital%20Ocean/OpenVPN)

[Official Dokumentation](https://marketplace.digitalocean.com/apps/openvpn-access-server)

AFAIK it provides only ClientVPN functionality.

---

## Windows Machines, Active Directory
If Terraform can't join the PCs to the Domain, try Ansible.

### Active Directory
- **Deploy DC**: 
    - [ ] Deploy [Microsoft Entra Domain Services](https://azure.microsoft.com/en-us/products/active-directory-ds)

- [ ] Deploy Azure Windows VMs and join AD
    - [x] [Deploy Azure Windows VMs](./Config%20Files/Azure/Windows_VMs)
    - [ ] Join AD (Microsoft Entra Domain Services)

- Need to deploy Cnet with VM prob. (Both just in the same terraform state file)
- Can Probably use Azure Vault to store Credentials and then with powershell ´Add-Computer´ join the domain

## VPN Gateway (Onsite to Site, Site to Site)

### Site to Site
- Create Azure VPN Gateway
    - [ ] [Create an Azure VPN Gateway](#)

    - [ ] [Create an Digital Ocean VPN Gateway](#)

### Client VPN
- [x] [Create OpenVPN VPN Gateway and connect.](./Config%20Files/Digital%20Ocean/OpenVPN)
> Deployed via Digital Ocean

## DNS Management
Buy Domain add NS Record to Point to Digital Ocean

- [ ] Explore CloudFlare

## End
- [ ] End. Make sure a **Cleanup script** or whatever is working etc.

## Sources

- [Modules Overview](https://developer.hashicorp.com/terraform/tutorials/modules/module)
