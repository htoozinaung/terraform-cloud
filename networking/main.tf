/*
resource "azurerm_storage_account" "appstorage240203block" {
  name                     = "zappstorage240203"
  resource_group_name      = "z-app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ 
    azurerm_resource_group.appgrp 
  ]
}

//for_each example
resource "azurerm_storage_container" "datacontainerBlock" {
  for_each = toset(["data", "files", "documents"])
  name                  = "z-${each.key}-container"
  storage_account_name  = "zappstorage240203"
  container_access_type = "blob"
  depends_on = [ 
    azurerm_resource_group.appgrp, 
    azurerm_storage_account.appstorage240203block
  ]
}
resource "azurerm_storage_blob" "storageblobBlock" {
  for_each={
    sample1 = "C:\\temp\\tmp2\\sammple1.txt"
    sample2 = "C:\\temp\\tmp3\\sammple2.txt"
    sample3 = "C:\\temp\\tmp4\\sammple3.txt"
  }
  name                   = "${each.key}.txt"
  storage_account_name   = "zappstorage240203"
  storage_container_name = "z-data-container"
  type                   = "Block"
  source                 = each.value
  depends_on = [ 
    azurerm_storage_container.datacontainerBlock
  ]
}
/*
//count example
resource "azurerm_storage_container" "datacontainerblock" {
  count = 3
  name                  = "z-data-container${count.index}"
  storage_account_name  = "zappstorage240203"
  container_access_type = "blob"
  depends_on = [ 
    azurerm_resource_group.appgrp, 
    azurerm_storage_account.appstorage240203block
  ]
}
/*
resource "azurerm_virtual_network" "zvirtualnetworkblock" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.address_space]
  depends_on = [ azurerm_resource_group.appgrp ]
}
resource "azurerm_subnet" "zsubnetAblock" {
  name                 = local.subnets[0].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[0].address_prefix]
  depends_on = [ azurerm_virtual_network.zvirtualnetworkblock ]
}
resource "azurerm_subnet" "zsubnetBblock" {
  name                 = local.subnets[1].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[1].address_prefix]
  depends_on = [ azurerm_virtual_network.zvirtualnetworkblock ] 
}
resource "azurerm_network_interface" "zappinterfaceblock" {
  name                = "z-app-interface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "zinternalip"
    subnet_id                     = azurerm_subnet.zsubnetAblock.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.zpublicipblock.id
  }
  depends_on = [ azurerm_subnet.zsubnetAblock ]
}
#it is just to see the value of id on the screen for debugging purpose
output "subnetA-id" {
  value = azurerm_subnet.zsubnetAblock.id
}
#adding another network interface
resource "azurerm_network_interface" "zappSecondInterfaceBlock" {
  name                = "z-app-second-interface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "zinternal"
    subnet_id                     = azurerm_subnet.zsubnetAblock.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_subnet.zsubnetAblock ]
}
resource "azurerm_public_ip" "zpublicipblock" {
  name                = "z-app-public-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}
resource "azurerm_network_security_group" "znsgroupblock" {
  name                = "z-app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

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
  subnet_id                 = azurerm_subnet.zsubnetAblock.id
  network_security_group_id = azurerm_network_security_group.znsgroupblock.id
}
resource "tls_private_key" "z-rsa-4096-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "zlinuxpemkey" {
  filename = "linuxkey.pem"
  content = tls_private_key.z-rsa-4096-key.private_key_pem
  depends_on = [ 
    tls_private_key.z-rsa-4096-key
   ]
  
}
#virtual machine
resource "azurerm_linux_virtual_machine" "zwinvirtualmachineBlock" {
  name                = "z-Linux-V-machine"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "linuxuser"
    network_interface_ids = [
    azurerm_network_interface.zappinterfaceblock.id,
  ]
admin_ssh_key {
  username = "linuxuser"
  public_key = tls_private_key.z-rsa-4096-key.public_key_openssh
}
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  depends_on = [ 
    azurerm_network_interface.zappinterfaceblock,
    azurerm_resource_group.appgrp,
    #azurerm_network_interface.zappSecondInterfaceBlock
    tls_private_key.z-rsa-4096-key
   ]
}
/*
#adding another disk for data
resource "azurerm_managed_disk" "zappDataDiskBlock" {
  name                 = "z-app-data-disk"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "16"
}
#attach data disk
resource "azurerm_virtual_machine_data_disk_attachment" "zDataDiskAttachBlock" {
  managed_disk_id    = azurerm_managed_disk.zappDataDiskBlock.id
  virtual_machine_id = azurerm_windows_virtual_machine.zwinvirtualmachineBlock.id
  lun                = "0"
  caching            = "ReadWrite"
}
*/
/*
resource "azurerm_storage_account" "appstorage240203block" {
  name                     = "zappstorage240203"
  resource_group_name      = "z-app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ 
    azurerm_resource_group.appgrp 
  ]
}

resource "azurerm_storage_container" "datacontainerblock" {
  name                  = "z-data-container"
  storage_account_name  = "zappstorage240203"
  container_access_type = "blob"
  depends_on = [ 
    azurerm_resource_group.appgrp, 
    azurerm_storage_account.appstorage240203block
  ]
}

resource "azurerm_storage_blob" "storageblobblock" {
  name                   = "main.tf"
  storage_account_name   = "zappstorage240203"
  storage_container_name = "z-data-container"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [ azurerm_storage_container.datacontainerblock]
}
*/