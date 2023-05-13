#VPC Creation
resource "aws_vpc" "kiwi-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name    = "${var.project}-vpc"
    Project = "${var.project}"
  }
}
#Internet Gateway 
resource "aws_internet_gateway" "kiwi-igw" {
  vpc_id = aws_vpc.kiwi-vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}
#Elastic IP 
/*resource "aws_eip" "kiwi-eip" {
  vpc = true
  tags = {
    Name = "${var.project}-eip"
  }
}*/
#Subnet 1
resource "aws_subnet" "sn1" {
  availability_zone = var.zone1a
  vpc_id            = aws_vpc.kiwi-vpc.id
  cidr_block        = "10.0.1.0/24"
  #map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.project}-sn1"
  }
}
#Subnet 2
resource "aws_subnet" "sn2" {
  availability_zone = var.zone1b
  vpc_id            = aws_vpc.kiwi-vpc.id
  cidr_block        = "10.0.2.0/24"
  #map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.project}-sn2"
  }
}
#security group for jenkins
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow jenkins"
  vpc_id      = aws_vpc.kiwi-vpc.id

  ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project}-jenkins-sg"
  }
}
#security group for alb
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow alb inbound traffic"
  vpc_id      = aws_vpc.kiwi-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #security_groups = ["${aws_security_group.app-sg.id}"]
  }
  tags = {
    Name = "${var.project}-alb-sg"
  }
}
#security group for app
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "Allow traffic from alb"
  vpc_id      = aws_vpc.kiwi-vpc.id

  ingress {
    description     = "web traffic from alb"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
    #cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project}-app-sg"
  }
}
#security group for backend
resource "aws_security_group" "backend-sg" {
  name        = "backend-sg"
  description = "Allow backend traffic from app"
  vpc_id      = aws_vpc.kiwi-vpc.id

  ingress {
    description = "SSH open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "TLS from app"
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }
  ingress {
    description     = "TLS from app"
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }
  ingress {
    description     = "TLS from app"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-sg.id}"]
  }
  ingress {
    description = "TLS from app"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.project}-backend-sg"
  }
}
resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.kiwi-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kiwi-igw.id
  }
  tags = {
    Name = "${var.project}-route1"
  }
}
resource "aws_route_table" "route2" {
  vpc_id = aws_vpc.kiwi-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kiwi-igw.id
  }
  tags = {
    Name = "${var.project}-route2"
  }
}
#Route table Association
resource "aws_route_table_association" "rp1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.route1.id
}
#Route table Association
resource "aws_route_table_association" "rp2" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.route2.id
}
