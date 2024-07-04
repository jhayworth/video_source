variable "subnet_id" {
    type = string
    description = "the subnet id for our test machine"
}

variable "vpc_security_group_ids" {
    type = list(string)
    description = "The list of security groups this instance will belong to"
}

variable "key_name" {
    type = string
    description = "The name of pem certificate to use for the instance"
}