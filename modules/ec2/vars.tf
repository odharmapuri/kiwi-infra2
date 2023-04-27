variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-03657b56516ab7912"
    us-east-1 = "ami-0947d2ba12ee1ff75"
  }
}
variable "app" {
  default = "ami-007855ac798b5175e"
}
variable "centos" {}

variable "key-pair" {}
variable "project" {}
variable "sn1" {}
variable "sn2" {}
variable "app-sg" {}
variable "alb-sg" {}
variable "backend-sg" {}