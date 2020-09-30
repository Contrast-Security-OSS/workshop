provider "azurerm" {
  version = "~>2.0"
  features {}
}
// The following commented-out code causes a terraform 0.13.1 crash.  I haven't investigated, but it looks like when we
// specify the image with a reference to a resource group name, we get an error.  This is a fairly explicit reference,
// that doesn't seem to work.  The workaround is to cite the image by ID.

//data "azurerm_image" "image" {
//  name = "medtronic-workshop-containers-2019-mm"
//  resource_group_name = "sales-engineering"
//}

resource "azurerm_resource_group" "workshopgroup" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    Owner = "Marco Morales"
    Environment = "Workshop Test"
    Team  = "MarcoOps"
  }
}

resource "azurerm_virtual_network" "workshopnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.workshopgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "workshopsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.workshopgroup.name
  virtual_network_name = azurerm_virtual_network.workshopnetwork.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "workshoppublicip" {
  name                         = "myPublicIP"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.workshopgroup.name
  allocation_method            = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_security_group" "workshopnsg" {
  name                = "myNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.workshopgroup.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "workshopnic" {
  name                        = "myNIC"
  location                    = "eastus"
  resource_group_name         = azurerm_resource_group.workshopgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.workshopsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.workshoppublicip.id
  }

  tags = {
    environment = "Workshop"
    CreatedBy = "Marco Morales"
    Customer = var.customer
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.workshopnic.id
  network_security_group_id = azurerm_network_security_group.workshopnsg.id
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.hostname
  location              = var.location
  resource_group_name   = azurerm_resource_group.workshopgroup.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.workshopnic.id}"]

  storage_image_reference {
    // Reference the image by ID directly
//    id = data.azurerm_image.image.id
    id = var.image_id
  }


  storage_os_disk {
    name          = "${var.hostname}-osdisk1"
    caching = "ReadWRite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false
    timezone = "Eastern Standard Time"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
}