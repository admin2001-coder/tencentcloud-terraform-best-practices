variable "region" {
  type    = string
  default = "ap-singapore"
}

variable "name_prefix" {
  type    = string
  default = "dev"
}

variable "tags" {
  type    = map(string)
  default = {
    env = "dev"
  }
}
