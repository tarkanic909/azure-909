resource "azurerm_linux_virtual_machine" "k8s" {
  for_each            = local.vms
  name                = "k8s-${each.key}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  size                = "Standard_D2as_v4"

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
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.yaml.tftpl", {
      is_master           = each.key == "master"
      CONTROL_PLANE_IP    = each.key == "master" ? azurerm_network_interface.k8s["master"].private_ip_address : ""
      cluster_public_key  = tls_private_key.cluster_ssh.public_key_openssh
      cluster_private_key = each.key == "master" ? tls_private_key.cluster_ssh.private_key_openssh : ""
      worker_ips          = each.key == "master" ? [for k, v in azurerm_network_interface.k8s : v.private_ip_address if k != "master"] : []
    })
  )
}