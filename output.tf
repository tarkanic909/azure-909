output "master_private_ip" {
  description = "Private IP of k8s master"
  value       = azurerm_network_interface.k8s["master"].private_ip_address
}

output "master_public_ip" {
  description = "Public IP of k8s master"
  value       = azurerm_public_ip.k8s["master"].ip_address
}

output "worker_ips" {
  value = {
    for k, v in azurerm_public_ip.k8s : k => v.ip_address
    if k != "master"
  }
}