variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}
# variable "ec2_root_storage_size" {
#     default = "10"
#     type = number
# }

variable "ec2_ami_id" {
    default = "ami-0360c520857e3138f"
    type = string
}

variable "db_password" {
  description = "The RDS master password"
  type        = string
  sensitive   = true
}