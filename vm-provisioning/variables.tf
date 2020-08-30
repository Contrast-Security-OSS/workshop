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

variable "image_uri" {
  type = string
  default = "/subscriptions/4352f0e7-67db-4001-8352-25147175ee02/resourceGroups/sales-engineering/providers/Microsoft.Compute/images/medtronic-workshop-containers-2019-mm"
}

variable "os_type" {
  type = string
  default = "Windows"
}

variable "storage_account_name" {
  type = string
  default = "salesengineering"
}

variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure complexity requirements"
}
