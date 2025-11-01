provider "aws" {
region = "ap-south-1"
}
data "aws_ami" "amazon_linux" {
most_recent = true
filter {
name = "amazon_linux"
value = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
owners = ["137112412989"]
}
resource "aws_instance" "ec2" {
ami = data.aws_ami.amazon_linux.id
instance_type = var.instance_type
vpc_security_group_ids = ["aws_security_group.launch_wizard.id"]
user_data = << -EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install nginx -y
        sudo systemctl start nginx
        sudo systemctl enable nginx
  tags = {
     Name = "my-ec2"
  }
} 
resource "aws_security_group" "launch_wizard" {
name = "launch_wizard"
ingress {
 from_port = 80
 to_port = 80
 protocol = tcp
 cidr_block = "0.0.0.0/0"
 }
} 
