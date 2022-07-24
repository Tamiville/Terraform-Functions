variable "path_to_publickey" {
  type    = string
  default = "linuxserver.pub"
}

# variable "windwowssecret" {
#   type = string
# }

variable "statestorage" {
  type    = string
  default = "claxdev_state"
}

variable "statestorage_account" {
  type    = string
  default = "claxdevstorage"
}
