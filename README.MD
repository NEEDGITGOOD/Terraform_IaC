#### Overview
This project is a comprehensive Terraform setup designed as part of an educational assignment. It focuses on deploying a sophisticated Docker infrastructure across multiple cloud platforms, primarily utilizing Digital Ocean and Azure. The architecture includes the deployment of Digital Ocean Droplets and Azure VMs, configured for various uses including container management and remote access.

#### Infrastructure Goal | Illustration

##### Digital Ocean
![Digital Ocean](https://raw.githubusercontent.com/NEEDGITGOOD/Terraform_IaC/main/Digital_Ocean.png)

##### Azure
![Azure](https://raw.githubusercontent.com/NEEDGITGOOD/Terraform_IaC/main/azure.png)

#### Key Features
- Automated Deployment of Digital Ocean Droplets: Creates three droplets, with the first, Docker01, hosting the Portainer container for Docker container management.
- Remote Environment Configuration: Utilizes AUTOSSH for secure connection to Docker02 and Docker03, binding these connections to localhost:2375 and localhost:2374, respectively, facilitating a fully automated setup.
- Multi-VM Setup on Docker02: Hosts three VMs (Ubuntu, AlmaLinux, Ubuntu), accessible via SSH on ports 2222, 2223, and 2224, with custom SSH user configuration.
- Azure Integration: Supports passing environmental variables through the CLI or a .tfvars file for Azure resource management.

#### Prerequisites
- Digital Ocean and Azure accounts.
- You need an [Digital Ocean Personal Access Key](https://cloud.digitalocean.com/account/api/tokens) if you want to use the Digital Ocean Infrastructure.
- Terraform installed on your machine.
- On Linux Machine: jq Installed.

### Usage (for the Docker Infrastructure)

1. Clone repo

````
git clone https://github.com/NEEDGITGOOD/Terraform_IaC
````

2. Go to Directory

````
cd ./Digital_Ocean/Docker_Infrastructure
````

3. Get Digital Ocean Personal Access Key and set it with

````bash
export DO_PAT="KEY_HERE"
````

4. Create Empty SSH File

````
mkdir -p ./ssh && ssh-keygen -t rsa -b 4096 -f ./ssh/myKey.pem -q -N ""
````

5. terraform init (just once)

````
terraform init
````

6. terraform apply

````
terraform apply -var "do_token=${DO_PAT}"
````




#### Docker Infrastructure
- [3x Docker Hosts | Automated Docker Infrastructure](/Digital_Ocean/Docker_Infrastructure)

Includes:
- ADGuard
- Wordpress
- Kali Linux VM
- Ubuntu VM
- Alma linux VM
- Gatus Monitoring
- Dashy Dashboard

#### Active Directory

- [Azure Active Directory Infrastructure| AADDS ](/Azure/active-directory-setup)

#### HoneyPot

- [HoneyPot](/Digital_Ocean/HoneyPot)

#### Other

- [Loadbalancer_DNS](/Digital_Ocean/Loadbalancer_DNS)
- [OpenVPN](/Digital_Ocean/OpenVPN)

#### Redundant (Already Included in Docker etc.)    
- [Wordpress](/Digital_Ocean/Wordpress)
- [NetBox](/Digital_Ocean/NetBox)
- [Loadbalancer_DNS](/Digital_Ocean/NetBox)

