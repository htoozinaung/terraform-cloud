/*
resource "azurerm_network_interface" "zappinterfaceblock" {
  count = var.number_of_vmachines
  name                = "z-app-interface${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "zinternalip"
    subnet_id                     = azurerm_subnet.zsubnetsBlock[count.index].id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.zpublicipblock[count.index].id
  }
  depends_on = [ 
    azurerm_subnet.zsubnetsBlock,
    #azurerm_public_ip.zpublicipblock
    ]
}
/*
resource "azurerm_public_ip" "zpublicipblock" {
  count = var.number_of_vmachines  
  name                = "z-app-public-ip${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  depends_on = [
    var.resource_group_name
  ]
}
*/
/*
#virtual machine
resource "azurerm_windows_virtual_machine" "zWinVmachineBlock" {
  count = var.number_of_vmachines
  name                = "z-Win-VM${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.zappinterfaceblock[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
*/