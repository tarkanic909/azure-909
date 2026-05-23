variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "k8s-lab"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "admin_user" {
  description = "Admin username on VM"
  type        = string
  default     = "azureuser"
}
