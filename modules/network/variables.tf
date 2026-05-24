variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_cidr" {
  description = "Virtual network cidr range"
  type = string
}

variable "subnet_cidrs" {
  description = "Subnet cidr ranges"
  type = map(string)
}
