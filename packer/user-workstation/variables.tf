variable "initials" {
  description = "Enter your initials to include in URLs. Lowercase only!!!"
  default = "bc"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created, to find your nearest run `az account list-locations -o table`"
  default = "westus"
}

variable "custom_image_name" {
  description = "Name of the HDE Windows demo workstation custom Azure image produced by Chef and Packer"
  default = "hde-win2016-sandbox"
}

variable "custom_image_resource_group_name" {
  description = "Azure resource group where the HDE Windows demo workstation Azure image resides"
  default = "sales-engineering"
}

variable "admin_password" {
  description = "Admin password for the Windows VM"
  default = "ContrastRocks123!"
}