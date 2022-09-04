# Creating the autoscaling launch configuration that contains AWS EC2 instance details
resource "aws_launch_configuration" "aws_autoscale_conf" {
# Defining the name of the Autoscaling launch configuration
  name          = "web_config"
# Defining the image ID of AWS EC2 instance
  image_id      = "ami-04505e74c0741db8d"
# Defining the instance type of the AWS EC2 instance
  instance_type = "t2.micro"
# Defining the Key that will be used to access the AWS EC2 instance
  key_name = "iaacassessment"
}

# Creating the autoscaling group within us-east-1a availability zone
resource "aws_autoscaling_group" "waledevops-group" {
# Defining the availability Zone in which AWS EC2 instance will be launched
  availability_zones        = ["us-east-1a"]
# Specifying the name of the autoscaling group
  name                      = "autoscalegroup"
# Defining the maximum number of AWS EC2 instances while scaling
  max_size                  = 6
# Defining the minimum number of AWS EC2 instances while scaling
  min_size                  = 1
# Grace period is the time after which AWS EC2 instance comes into service before checking health.
  health_check_grace_period = 30
# The Autoscaling will happen based on health of AWS EC2 instance defined in AWS CLoudwatch Alarm 
  health_check_type         = "EC2"
# force_delete deletes the Auto Scaling Group without waiting for all instances in the pool to terminate
  force_delete              = true
# Defining the termination policy where the oldest instance will be replaced first 
  termination_policies      = ["OldestInstance"]
# Scaling group is dependent on autoscaling launch configuration because of AWS EC2 instance configurations
  launch_configuration      = aws_launch_configuration.aws_autoscale_conf.name
}
# Creating the autoscaling schedule of the autoscaling group

resource "aws_autoscaling_schedule" "mygroup_schedule" {
  scheduled_action_name  = "autoscalegroup_action"
# The minimum size for the Auto Scaling group
  min_size               = 1
# The maxmimum size for the Auto Scaling group
  max_size               = 2
# Desired_capacity is the number of running EC2 instances in the Autoscaling group
  desired_capacity       = 1
# defining the start_time of autoscaling if you think traffic can peak at this time.
  start_time             = "2022-09-04T14:45:00Z"
  autoscaling_group_name = aws_autoscaling_group.waledevops-group.name
}

# Creating the autoscaling policy of the autoscaling group
resource "aws_autoscaling_policy" "mygroup_policy" {
  name                   = "autoscalegroup_policy"
# The number of instances by which to scale.
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
# The amount of time (seconds) after a scaling completes and the next scaling starts.
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.waledevops-group.name
}
# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
# defining the name of AWS cloudwatch alarm
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
# Defining the metric_name according to which scaling will happen (based on CPU) 
  metric_name = "CPUUtilization"
# The namespace for the alarm's associated metric
  namespace = "AWS/EC2"
# After AWS Cloudwatch Alarm is triggered, it will wait for 60 seconds and then autoscales
  period = "60"
  statistic = "Average"
# CPU Utilization threshold is set to 10 percent
  threshold = "10"
  alarm_actions = [
        "${aws_autoscaling_policy.mygroup_policy.arn}"
    ]
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.waledevops-group.name}"
  }
}

resource "aws_security_group" "terramino_instance" {
  name = "learn-asg-terramino-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]
  }


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}