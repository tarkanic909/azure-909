output "subnet_master_id" {
  value = azurerm_subnet.master.id
}

output "subnet_workers_id" {
  value = azurerm_subnet.workers.id
}

output "nsg_id" {
  value = azurerm_network_security_group.k8s.id
}
