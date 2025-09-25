variable "availability_zone" {
  description = "The availability zone to deploy the subnet in"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "name" {
  description = "The name tag for the subnet"
  type        = string
}
