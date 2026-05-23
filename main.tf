terraform {
  required_version = "~> 1.15"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

resource "tls_private_key" "cluster_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
