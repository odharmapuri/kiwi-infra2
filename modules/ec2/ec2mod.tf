resource "aws_instance" "app" {
  count                       = 2
  ami                         = var.centos
  instance_type               = "t2.micro"
  subnet_id                   = var.sn1
  key_name                    = var.key-pair
  vpc_security_group_ids      = [var.app-sg]
  associate_public_ip_address = true
  #user_data                  = file("modules/ec2/tomcat.sh")
  user_data                   = filebase64("modules/ec2/sh/tomcat.sh")
  tags = {
    Name = "${var.project}-app${count.index}"
  }
}
resource "aws_instance" "backend" {
  ami                    = var.centos
  instance_type          = "t2.micro"
  subnet_id              = var.sn1
  key_name               = var.key-pair
  vpc_security_group_ids = [var.backend-sg]
  associate_public_ip_address = true
  user_data              = file("modules/ec2/sh/backend.sh")
  tags = {
    Name = "${var.project}-backend"
  }
}
resource "aws_instance" "jenkins" {
  ami                    = var.ubuntu
  instance_type          = "t2.medium"
  subnet_id              = var.sn1
  key_name               = var.key-pair
  vpc_security_group_ids = [var.jenkins-sg]
  associate_public_ip_address = true
  user_data              = file("modules/ec2/sh/jenkins.sh")
  tags = {
    Name = "${var.project}-jenkins"
  }
}
