# Target Group for ECS Service
resource "aws_lb_target_group" "web_tg" {
  name        = "ecs-web-tg"
  port        = 80                        # Container port (not host)
  protocol    = "HTTP"
  target_type = "ip"                      # ECS uses IP target mode
  vpc_id      = aws_vpc.product_v1.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "ecs-web-target-group"
  }
}

# Application Load Balancer
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.product_v1_subnet_1a_public.id,
    aws_subnet.product_v1_subnet_1b_public.id,
  ]

  enable_deletion_protection = false

  tags = {
    Name = "ecs-alb"
  }
}

# Listener for ALB (port 80)
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
