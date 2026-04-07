variable "region" {
  type    = string
  default = "ap-singapore"
}

variable "name_prefix" {
  type    = string
  default = "staging"
}

variable "tags" {
  type    = map(string)
  default = {
    env = "staging"
  }
}
