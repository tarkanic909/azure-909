locals {
  vms = var.single_node ? {
    master = { subnet = "master", is_master = true }
    } : {
    master  = { subnet = "master", is_master = true }
    worker1 = { subnet = "workers", is_master = false }
    worker2 = { subnet = "workers", is_master = false }
  }

  os_image = {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
  }

  vnet_cidr = "10.0.0.0/16"

  subnet_cidrs = {
    master  = "10.0.1.0/24"
    workers = "10.0.2.0/24"
  }
}
