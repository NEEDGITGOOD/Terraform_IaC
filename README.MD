#### What is this?

Just my School Project, it basically has multiple Parts with my [Docker Infrastructure](/Digital_Ocean/Docker/ProvisionTest_Cloud_Init) being the most complicated. It basically deploys 3 Digital Ocean Droplets with the first called Docker01 which has the Portainer Container, it also adds the two following Droplets (VMs) Docker02, Docker03 as an Remote Environment via AUTOSSH (it connects via autossh and then binds that connection to localhost:2375 and localhost:2374 so its secure) so its fully automatic. And all the other stuff below like having 3 VMs (Ubuntu, AlmaLinux, Ubuntu) on Docker02 accessible via and SSH User (your_ssh user) via the Ports 2222, 2223, 2224. When running `terraform apply` you will be prompted for a VM Password so thats that. 

For the Azure Part you will need to pass the Environmental Variables into the CLI or use a .tfvars File.

If there are any questions ask.

#### Requirements

You need an [Digital Ocean Personal Access Key](https://cloud.digitalocean.com/account/api/tokens) if you want to use the Digital Ocean Infrastructure.

On Linux Machine: jq Installed.

#### To Do

- [ ] Create an Setup Script
- [ ] Organize Docker Setup better.

### Usage (for the Docker Infrastructure)

0. Go to Directory

````
cd ./Terraform_IaC/Digital_Ocean/Docker/ProvisionTest_Cloud_Init
````

1. Get Digital Ocean Personal Access Key and set it with

````bash
export DO_PAT="KEY_HERE"
````

2. Create Empty SSH File

````
mkdir -p ./ssh && ssh-keygen -t rsa -b 4096 -f ./ssh/myKey.pem -q -N ""
````

2. terraform init (just once)

````
terraform init
````

3. terraform apply

````
terraform apply -var "do_token=${DO_PAT}"
````

#### Infrastructure Goal | Illustration

##### Digital Ocean
![Digital Ocean](https://raw.githubusercontent.com/NEEDGITGOOD/Terraform_IaC/main/Digital_Ocean.png)

##### Azure
![Azure](https://raw.githubusercontent.com/NEEDGITGOOD/Terraform_IaC/main/azure.png)


#### Docker Infrastructure
- [3x Docker Hosts | Automated Docker Infrastructure](/Digital_Ocean/Docker/ProvisionTest_Cloud_Init)

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

