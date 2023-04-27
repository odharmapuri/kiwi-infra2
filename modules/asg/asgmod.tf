resource "aws_launch_template" "lt" {
  name          = "${var.project}-lt"
  image_id      = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"
  key_name      = var.key-pair
  user_data     = file("modules/ec2/tomcat.sh")
  /*user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              echo "Hello, from Terraform" > /var/www/html/index.html
              service httpd start
              chkconfig httpd on
              EOF*/
  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.app-sg]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-app"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  #name                 = "${var.project}-asg"
  #launch_configuration = aws_launch_configuration.launch-conf.name
  vpc_zone_identifier       = [var.sn1, var.sn2]
  target_group_arns         = var.tg
  health_check_type         = "ELB"
  health_check_grace_period = 300
  min_size                  = 2
  max_size                  = 4
  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
  depends_on = [var.aws-alb]
  tag {
    key                 = "name"
    value               = "${var.project}-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "up" {
  name                   = "${var.project}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "up-alarm" {
  alarm_name          = "${var.project}-up-alarm"
  alarm_description   = "scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.up.arn]
}

resource "aws_autoscaling_policy" "down" {
  name                   = "${var.project}-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "down-alarm" {
  alarm_name          = "${var.project}-down-alarm"
  alarm_description   = "scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.down.arn]
}