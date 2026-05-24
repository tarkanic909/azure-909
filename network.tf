module "network" {
  source              = "./modules/network"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.k8s.name
  vnet_cidr           = local.vnet_cidr
  subnet_cidrs        = local.subnet_cidrs
}
