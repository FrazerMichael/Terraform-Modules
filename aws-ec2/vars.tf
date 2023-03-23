variable "sg-id" {}

variable "SN-id" {}

variable "cluster" {
  type    = string
}

variable "key" {
  type  = string
}

variable "chassis" {
  type = string
  default = "t2.micro"
}