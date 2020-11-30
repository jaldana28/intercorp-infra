variable "external_ip" {
  type    = string
  default = "186.123.178.26/32"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "arn_certificate" {
  type    = string
  default = "arn:aws:acm:us-east-1:931914722589:certificate/f82d8357-a8d3-4885-9c4c-f98ced31473b"
}


