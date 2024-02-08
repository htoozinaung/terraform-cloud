output "resource_group_name" {
  value = azurerm_resource_group.appgrp.name
}
output "location" {
  value = azurerm_virtual_network.zvirtualnetworkBlock.location
}