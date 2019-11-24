provider "aws" {
  region = "us-east-1"
}
# Create elastic-ip
resource "aws_eip" "default1" {
  instance = "${aws_instance.default.id}"
  }
resource "aws_instance" "default" {
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  key_name = "soumil-moog"
  user_data = "${file("permit_root.sh")}"
 tags = {
  Environment = "${var.environment_tag}"
 }
}
resource "null_resource" "Script_provisioner" {
  triggers {
    public_ip = "${aws_eip.default1.public_ip}"
  }

  connection {
    type = "ssh"
    host = "${aws_eip.default1.public_ip}"
    user = "root"
    port = "22"
   private_key  = "${file("soumil-moog")}"
    agent = false
  }
  provisioner "local-exec" {
    command = "sleep 120"
  }
provisioner "file" {
    source      = "test.sh"
    destination = "/home/centos/test.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/test.sh",
      "sh /home/centos/test.sh",
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      "service sshd restart"
    ]
  }
depends_on = ["aws_instance.default"]
  }
