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
  description = "name of the workshop host for the student"
//  default = "workshop"
}

variable "vm_size" {
  type = string
  default = "Standard_E2s_v3"
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
  default = "/subscriptions/4352f0e7-67db-4001-8352-25147175ee02/resourceGroups/sales-engineering/providers/Microsoft.Compute/images/workshop-containers-2019"
  description = "Full AZ ID of the packer image."
}

variable "customer" {
  type = string
  description = "The name of the customer for this workshop."
}