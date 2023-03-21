variable "cidr-block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cluster" {
  type    = string
}

variable "public-cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private-cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}