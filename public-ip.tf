resource "azurerm_public_ip" "k8s" {
  for_each            = local.vms
  name                = "pip-${var.prefix}-${each.key}"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  allocation_method   = "Static"
  sku                 = "Standard"
}