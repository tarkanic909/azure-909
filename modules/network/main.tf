resource "azurerm_virtual_network" "k8s" {
  name                = "vnet-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "master" {
  name                 = "snet-master"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = [var.subnet_cidrs.master]
}

resource "azurerm_subnet" "workers" {
  name                 = "snet-workers"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = [var.subnet_cidrs.workers]
}

resource "azurerm_network_security_group" "k8s" {
  name                = "nsg-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name

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
    source_address_prefix      = var.vnet_cidr
    destination_address_prefix = var.vnet_cidr
  }

  security_rule {
    name                       = "allow-k8s-api"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
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
