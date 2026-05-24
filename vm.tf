resource "azurerm_linux_virtual_machine" "k8s" {
  for_each            = local.vms
  name                = "vm-${var.prefix}-${each.key}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  size                = each.value.is_master ? var.vm_size.master : var.vm_size.worker
  priority            = each.value.is_master ? "Spot" : "Regular"
  eviction_policy     = each.value.is_master ? "Deallocate" : null
  max_bid_price       = each.value.is_master ? -1 : null

  admin_username                  = var.admin_user
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.k8s[each.key].id
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.os_image.publisher
    offer     = local.os_image.offer
    sku       = local.os_image.sku
    version   = "latest"
  }

  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.yaml.tftpl", {
      is_master               = each.value.is_master
      CONTROL_PLANE_IP        = each.value.is_master ? azurerm_network_interface.k8s["master"].private_ip_address : ""
      CONTROL_PLANE_PUBLIC_IP = azurerm_public_ip.k8s["master"].ip_address
      cluster_public_key      = tls_private_key.cluster_ssh.public_key_openssh
      cluster_private_key     = each.value.is_master ? tls_private_key.cluster_ssh.private_key_openssh : ""
      worker_ips              = each.value.is_master ? [for k, v in azurerm_network_interface.k8s : v.private_ip_address if k != "master"] : []
    })
  )
}
