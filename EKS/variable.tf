variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "instance_type" {
  type = string
}