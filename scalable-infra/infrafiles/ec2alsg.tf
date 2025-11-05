# -------------------------
# Auto Scaling Group for ECS Cluster
# -------------------------
resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  min_size                  = 0
  max_size                  = 1
  desired_capacity           = 0

  vpc_zone_identifier = [
    aws_subnet.product_v1_subnet_1a_private.id,
    aws_subnet.product_v1_subnet_1b_private.id
  ]

  # # Attach to ALB Target Group (for instance health)
  # target_group_arns = [aws_lb_target_group.web_tg.arn]

  health_check_type           = "EC2"     # ECS-managed instances, no need for ALB checks
  health_check_grace_period   = 180
  force_delete                = true

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-container-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
