provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    Owner = "Marco Morales"
    Environment = "Workshop Test"
    Team  = "MarcoOps"
  }
}

resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "myPublicIP"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  allocation_method            = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "myterraformnic" {
  name                        = "myNIC"
  location                    = "eastus"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                        = "diag${random_id.randomId.hex}"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  location                    = "eastus"
  account_replication_type    = "LRS"
  account_tier                = "Standard"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.hostname
  location              = var.location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  vm_size               = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]

  storage_os_disk {
    name          = "${var.hostname}-osdisk1"
    vhd_uri = ""
    create_option = "Attach"
    os_type = "Windows"
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