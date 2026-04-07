variable "env" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "subnet_az" {
  type        = string
  description = "Subnet AZ"
}
