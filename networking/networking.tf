
resource "azurerm_resource_group" "appgrp" {
  name = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "zvirtualnetworkBlock" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.virtual_network_address_space]
  depends_on = [ 
    azurerm_resource_group.appgrp 
    ]
}
resource "azurerm_subnet" "zsubnetsBlock" {
  count=var.number_of_subnets
  name                 = "z-Subnet-${terraform.workspace}-${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on = [ 
    azurerm_virtual_network.zvirtualnetworkBlock 
    ]
}

resource "azurerm_network_security_group" "znsgroupBlock" {
  name                = "z-app-nsg-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ 
    azurerm_resource_group.appgrp
   ]
}
resource "azurerm_subnet_network_security_group_association" "znsgassociationblock" {
    count=var.number_of_subnets
    subnet_id                 = azurerm_subnet.zsubnetsBlock[count.index].id
    network_security_group_id = azurerm_network_security_group.znsgroupBlock.id
    depends_on = [
        azurerm_virtual_network.zvirtualnetworkBlock,
        azurerm_network_security_group.znsgroupBlock
      ]
}