# write terraform code for elasti beanstalk with java application loadbalancer and autoscaling

# provider
provider "aws" {
  region = "us-east-1"
}

# elastic beanstalk environment
resource "aws_elastic_beanstalk_environment" "java_app_env" {
  name        = "java-app-env"
  description = "Java application environment"
  application = "java-app"

  # set up the environment with a load balancer
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.10.0 running Java 8"
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
}

# elastic beanstalk application
resource "aws_elastic_beanstalk_application" "java_app" {
  name        = "java-app"
  description = "Java application"
}

# elastic beanstalk application version
resource "aws_elastic_beanstalk_application_version" "java_app_version" {
  name        = "java-app-version"
  application = aws_elastic_beanstalk_application.java_app.name
  bucket      = "java-app-bucket"
  key         = "java-app.war"
}

# autoscaling group
resource "aws_autoscaling_group" "java_app_asg" {
  name                      = "java-app-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.java_app_lc.name

  # associate the autoscaling group to the elastic beanstalk environment
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  tag {
    key                 = "elasticbeanstalk:environment-id"
    value               = aws_elastic_beanstalk_environment.java_app_env.id
    propagate_at_launch = true
  }
}

# launch configuration
resource "aws_launch_configuration" "java_app_lc" {
  name_prefix              = "java-app-lc"
  image_id                 = "ami-12345678"
  instance_type            = "t2.micro"
  security_groups          = [aws_security_group.java_app_sg.id]
  associate_public_ip_address = true
  user_data                = <<-EOF
    #!/bin/bash
    yum install java -y
    EOF
}

# security group
resource "aws_security_group" "java_app_sg" {
  name        = "java-app-sg"
  description = "Security group for java application"
  vpc_id      = aws_vpc.main.id

  # allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone  = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone  = "us-east-1b"
  map_public_ip_on_launch = true
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}