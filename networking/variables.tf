variable "resource_group_name" {
  type = string
  description = "This defines the resource group name"
}
variable "location" {
  type = string
  description = "This defines the location"
}
variable "virtual_network_name" {
  type = string
  description = "This defines the name the virtual network"
}
variable "virtual_network_address_space" {
  type = string
  default = "This defines the address of the virtual address space"
}

variable "number_of_subnets" {
    type=number
    description = "This defines the number of subnets"
    default = 1
    validation {
      condition = var.number_of_subnets < 5
      error_message = "The number of subnets must be less than 5."
    }
}

variable "number_of_vmachines" {
    type = number
    description = "This defines the number of virtual machines"
    default = 1
}
