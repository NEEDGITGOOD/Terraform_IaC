terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "GITHUB_TOKEN" {
  description = "GitHub personal access token"
  type        = string
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
