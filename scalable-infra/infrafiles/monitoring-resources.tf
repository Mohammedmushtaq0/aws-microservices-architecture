# CloudWatch Alarms for EC2 Instances
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
    alarm_name          = "HighCPUUtilization"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "300"
    statistic           = "Average"
    threshold           = "80"
    
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.web_asg.name
    }
    
    alarm_description = "This alarm triggers when CPU utilization exceeds 80% for 10 minutes."
    actions_enabled   = true
    
    alarm_actions = [
        aws_sns_topic.alerts_topic.arn
    ]
    
    tags = {
        Name = "HighCPUUtilizationAlarm"
    }
    }

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts_topic" {
    name = "alerts-topic"
    
    tags = {
        Name = "AlertsTopic"
    }
}

# SNS Topic Subscription (Email)
resource "aws_sns_topic_subscription" "email_subscription" {
    topic_arn = aws_sns_topic.alerts_topic.arn
    protocol  = "email"
    endpoint  = "your-email@example.com"  # Replace with your email address
}

