variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-02eac2c0129f6376b"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.large"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"
}
