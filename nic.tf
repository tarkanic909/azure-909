resource "azurerm_network_interface" "k8s" {
  for_each            = local.vms
  name                = "nic-${var.prefix}-${each.key}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.is_master ? module.network.subnet_master_id : module.network.subnet_workers_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s[each.key].id
  }
}
