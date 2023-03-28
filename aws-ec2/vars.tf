variable "sg-id" {}

variable "SN-id" {}

variable "user_data" {}

variable "cluster" {
  type = string
}

variable "key" {
  type = string
}

variable "chassis" {
  type    = string
  default = "t2.micro"
}

variable "private" {
  type    = bool
  default = false
}

variable "config-name" {
  type = string
}