resource "aws_instance" "app" {
  count                       = 2
  ami                         = var.centos
  instance_type               = "t2.micro"
  subnet_id                   = var.sn1
  key_name                    = var.key-pair
  vpc_security_group_ids      = [var.app-sg]
  associate_public_ip_address = true
  user_data                   = file("modules/ec2/tomcat.sh")
  tags = {
    Name = "${var.project}-app${count.index}"
  }
}
/*
  user_data = <<EOF
		#!/bin/bash
		yum update -y
		yum install -y httpd.x86_64
		systemctl start httpd.service
		systemctl enable httpd.service
		echo ?Hello World from $(hostname -f)? > /var/www/html/index.html
	EOF
*/
resource "aws_instance" "sql" {
  ami                    = var.centos
  instance_type          = "t2.micro"
  subnet_id              = var.sn1
  key_name               = var.key-pair
  vpc_security_group_ids = [var.backend-sg]
  associate_public_ip_address = true
  user_data              = file("modules/ec2/mysql.sh")
  tags = {
    Name = "${var.project}-sql"
  }
}
resource "aws_instance" "cache" {
  ami                    = var.centos
  instance_type          = "t2.micro"
  subnet_id              = var.sn1
  key_name               = var.key-pair
  vpc_security_group_ids = [var.backend-sg]
  associate_public_ip_address = true
  user_data              = file("modules/ec2/memcache.sh")
  tags = {
    Name = "${var.project}-cache"
  }
}
resource "aws_instance" "memq" {
  ami                    = var.centos
  instance_type          = "t2.micro"
  subnet_id              = var.sn1
  key_name               = var.key-pair
  vpc_security_group_ids = [var.backend-sg]
  associate_public_ip_address = true
  user_data              = file("modules/ec2/rabbitmq.sh")
  tags = {
    Name = "${var.project}-memq"
  }
}