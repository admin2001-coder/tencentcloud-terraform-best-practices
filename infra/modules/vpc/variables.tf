variable "name" { type = string }
variable "cidr" { type = string }
variable "subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}
variable "tags" { type = map(string) }
