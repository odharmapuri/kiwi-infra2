provider "aws" {
  region = "us-east-1"
}

resource "aws_elastic_beanstalk_application" "example_app" {
  name = "example-app"
}

resource "aws_elastic_beanstalk_environment" "example_env" {
  name                = "example-env"
  application         = aws_elastic_beanstalk_application.example_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.3.0 running Java 8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "arn:aws:iam::123456789012:instance-profile/example-instance-profile"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-xxxxxxxx"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-xxxxxxxx,subnet-yyyyyyyy"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "subnet-xxxxxxxx,subnet-yyyyyyyy"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "10"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "us-east-1a,us-east-1b,us-east-1c"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  lifecycle {
    ignore_changes = [
      setting["aws:autoscaling:launchconfiguration", "KeyName"],
      setting["aws:autoscaling:launchconfiguration", "SecurityGroups"],
    ]
  }
}

/*This code creates an Elastic Beanstalk environment with the name "example-env" 
and the application named "example-app". The environment is based on the Amazon Linux 2 platform 
running Java 8 with Tomcat. It uses an IAM instance profile named "example-instance-profile" 
and runs in a VPC with two subnets. The load balancer type is set to "application", 
and autoscaling is configured to have a minimum of 2 instances and a maximum of 10 instances 
across three availability zones. Enhanced health reporting is enabled.

Note: This code is for demonstration purposes only and may require modifications to fit your 
specific use case.*/