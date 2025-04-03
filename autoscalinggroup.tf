resource "aws_autoscaling_group" "webapp_asg" {
  name                = "webapp-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  default_cooldown    = 60
  vpc_zone_identifier = aws_subnet.public[*].id
  launch_template {
    name    = aws_launch_template.webapp.name
    version = "$Latest"
  }

  # Adding Tags for EC2 instances launched by the ASG
  tag {
    key                 = "Name"
    value               = "webapp_instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
# Create CloudWatch Alarms for Scaling Policies
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale_up_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scaleup_threshold
  alarm_description   = var.scaleup_description

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}
# Scale Up Policy
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale_down_cpu_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scaledown_threshold
  alarm_description   = var.scaledown_description

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}
