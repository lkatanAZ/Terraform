provider "azurerm" {
  version = "1.38.0"
  features={}
}





#create resource group
resource "azurerm_resource_group" "NETresourceGroup" {
    name     = var.NETresourceGroupName
    location = var.location
   
}

#create resource group2
resource "azurerm_resource_group" "VMresourceGroup" {
    name     = var.VMrg
    location = var.location
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = var.vnetname
    address_space       = var.vnetspace
    location            = var.location
    resource_group_name = var.NETresourceGroupName
}


# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnetname
  resource_group_name  = var.NETresourceGroupName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.subnetprefix
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "publicip-${var.vmname}"
  location            = var.location
  resource_group_name = var.NETresourceGroupName
  allocation_method   = "Static"
}


# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.vnetname} "
  location            = var.location
  resource_group_name = var.NETresourceGroupName

  security_rule {
    name                       = "rdp"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "nic-${var.vmname}"
  location                  = var.location
  resource_group_name       = var.NETresourceGroupName
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "niccfg-${var.vmname}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}


# Create virtual machine
resource "azurerm_virtual_machine" "virtual-machine" {
  name                  = var.vmname
  location              = var.location
  resource_group_name   = var.VMrg
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B2s"


  storage_os_disk {
    name              = "disk${var.vmname}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type =  "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }

  os_profile {
    computer_name  = var.vmname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }


  os_profile_windows_config{
    
    
  }
}