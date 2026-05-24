resource "azurerm_resource_group" "k8s" {
  name     = "rg-${var.prefix}"
  location = var.location
}
