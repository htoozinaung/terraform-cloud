/*
resource "azurerm_resource_group" "appgrp" {
  name = "z-app-grp2"
  location = "North Europe"
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "5.3.0"
  # insert the 2 required variables here
  resource_group_name = azurerm_resource_group.appgrp.name
  use_for_each = false
  vnet_name = "z-app-vnet"
  address_space = "10.0.0.0/16"
  subnet_names = ["zSubnet1","zSubnet2"]
  subnet_prefixes =["10.0.0.0/24","10.0.1.0/24"]
  depends_on = [ azurerm_resource_group.appgrp ]
}
*/

module "networking_module" {
    source = "./networking"
    resource_group_name = "z-app-grp2-${terraform.workspace}"
    location = "North Europe"
    virtual_network_name = "z-app-vir-network2-${terraform.workspace}"
    virtual_network_address_space = "10.0.0.0/16"
}
