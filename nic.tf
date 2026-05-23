resource "azurerm_network_interface" "k8s" {
  for_each            = local.vms
  name                = "k8s-${each.key}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet == "master" ? azurerm_subnet.master.id : azurerm_subnet.workers.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s[each.key].id
  }
}
