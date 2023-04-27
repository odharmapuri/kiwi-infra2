resource "aws_elastic_beanstalk_application" "java_application" {
  name        = "java_application"
  description = "Java application"
}

resource "aws_elastic_beanstalk_environment" "java_application_env" {
  name = "java_application_env"

  application = "${aws_elastic_beanstalk_application.java_application.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.9 running Java 8"
}

resource "aws_elb" "java_application_elb" {
  name = "java_application_elb"

  subnets = ["${aws_subnet.public.*.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_elastic_beanstalk_configuration_template" "java_application" {
  name        = "java_application"
  application = "${aws_elastic_beanstalk_application.java_application.name}"

  option_settings = [
    {
      namespace = "aws:autoscaling:launchconfiguration"
      option_name = "ELBSecurityGroups"
      value = "${aws_security_group.ec2_and_elb_security_group.id}"
    },
    {
      namespace = "aws:elb:loadbalancer"
      option_name = "LoadBalancerName"
      value = "${aws_elb.java_application_elb.name}"
    },
  ]
}

resource "aws_autoscaling_group" "java_application" {
  name                  = "java_application"
  vpc_zone_identifier   = ["${aws_subnet.public.*.id}"]
  launch_configuration  = "${aws_launch_configuration.beanstalk_lc.name}"
  max_size              = 4
  min_size              = 2
  desired_capacity      = 2
  health_check_type     = "ELB"

  tag {
    key                 = "Name"
    value               = "java_application"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ec2_and_elb_security_group" {
  name        = "ec2_and_elb_security_group"
  description = "Security group for the EC2 Instance and ELB"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }
}