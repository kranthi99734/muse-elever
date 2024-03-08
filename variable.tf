variable "vpc_cidr_muse_elever" {
    type = list(string)
    default = ["10.0.0.0/16"]
}
 
variable "availability_zones" {
  type    = list(string)
}
variable "public_subnet_cidr_blocks" {
  type = list(string)
  default = ["10.0.1.0/24"]
}
 
variable "private_subnet_cidr_blocks" {
     type = list(string)
     default = ["10.0.2.0/24"]
}