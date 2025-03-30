variable "vpc_cidr" {
  type = string
}

variable "pb_cidr" {
  type = string
}

variable "ext_ip" {
  type = string
}

variable "pv_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

