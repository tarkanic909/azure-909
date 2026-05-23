resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "k8s" {
  name                = "vnet-k8s-lab"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "master" {
  name                 = "subnet-master"
  resource_group_name  = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "workers" {
  name                 = "subnet-workers"
  resource_group_name  = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "k8s" {
  name                = "nsg-k8s"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-vnet-internal"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/16"
  }
}

resource "azurerm_subnet_network_security_group_association" "master" {
  subnet_id                 = azurerm_subnet.master.id
  network_security_group_id = azurerm_network_security_group.k8s.id
}

resource "azurerm_subnet_network_security_group_association" "workers" {
  subnet_id                 = azurerm_subnet.workers.id
  network_security_group_id = azurerm_network_security_group.k8s.id
}