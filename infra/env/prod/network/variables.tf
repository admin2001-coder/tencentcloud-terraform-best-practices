variable "region" { type = string }
variable "org" { type = string }
variable "env" { type = string }
variable "app" { type = string }

variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
