variable "aws_region" {
  type = string
}
variable "vpc_cidr" {
}
variable "service" {
  type = string
}

variable "profile" {
}
variable "domain" {
  type = string
}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "datastore_subnet_cidrs" {
  type = list(string)
}
variable "s3" {
  type = map(string)
}
variable "alb" {
  type = map(string)
}
variable "ecs" {
  type = map(string)
}
variable "docdb" {
  type = map(string)
}
variable "container_fe" {
  type = map(string)
}
variable "container_be" {
  type = map(string)
}
