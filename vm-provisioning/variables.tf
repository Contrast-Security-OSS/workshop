variable "location" {
  type = string
  default = "eastus"
}

variable "prefix" {
  type = string
  default = "acme"
}

variable "hostname" {
  type = string
  default = "workshop"
}

variable "vm_size" {
  type = string
  default = "Standard_E2s_v3"
}

variable "os_type" {
  type = string
  default = "Windows"
}

variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure complexity requirements"
}

variable "image_id" {
  type = string
  description = "Full AZ ID of the packer image."
}