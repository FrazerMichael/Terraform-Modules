variable "azs" {
  type    = list(string)
}

variable "vpc-block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cluster" {
  type = string
}

variable "cidr-blocks" {
  type    = list(string)
}