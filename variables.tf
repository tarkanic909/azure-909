variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "prefix" {
  description = "Prefix used for all resource names"
  type        = string
  default     = "k8s-lab"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
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

variable "vm_size" {
  description = "Azure VM size"
  type        = map(string)
  default     = { master = "Standard_D2as_v5", worker = "Standard_B2s" }
}

variable "single_node" {
  description = "If true, deploy only master node (no workers)"
  type        = bool
  default     = false
}
