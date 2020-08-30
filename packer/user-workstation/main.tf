# Create Azure resource group
resource "azurerm_resource_group" "main" {
  name     = "Sales-Engineer-${var.initials}"
  location = "${var.location}"
}

# Create public IP
resource "azurerm_public_ip" "public" {
  name = "public-ip-${var.initials}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method = "Static"

  tags = {
    environment = "hde-win2016-${var.initials}"
  }
}

# Create Azure network security group to allow RDP access
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.initials}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "hde-win2016-${var.initials}"
  }
}

# Create Azure virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "network-${var.initials}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

# Create Azure subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.initials}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create Azure VM network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.initials}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public.id}"
  }
}

# Identify the custom HDE Azure image
data "azurerm_image" "custom" {
  name                = "${var.custom_image_name}"
  resource_group_name = "${var.custom_image_resource_group_name}"
}

# Create Azure VM
resource "azurerm_virtual_machine" "hde" {
  name                  = "hde-win2016-vm-${var.initials}"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS3_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.custom.id}"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "150"
  }
  os_profile {
    computer_name  = "hde-win2016-vm"
    admin_username = "azure"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent = "true"
  }
  tags = {
    environment = "hde-win2016-${var.initials}"
  }
}