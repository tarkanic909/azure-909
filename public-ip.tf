resource "azurerm_public_ip" "k8s" {
  for_each            = local.vms
  name                = "k8s-${each.key}-ip"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  allocation_method   = "Static"
  sku                 = "Standard"
}