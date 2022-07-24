variable "clax_general_network" {
  type    = string
  default = "clax_general_network"
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "clax_nsg" {
  type    = string
  default = "clax_nsg"
}

variable "clax_vnet" {
  type    = string
  default = "clax_vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.0.4", "10.0.0.5"]
}

variable "clax_rt" {
  type    = string
  default = "clax_rt"
}

variable "database_subnet" {
  type    = string
  default = "database_subnet"
}

variable "application_subnet" {
  type    = string
  default = "application_subnet"
}

variable "address_prefixes_database" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "address_prefixes_application" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "destination_address_prefix" {
  type    = string
  default = "VirtualNetwork"
}

variable "source_address_prefix" {
  type    = string
  default = "82.76.59.177/32"
}