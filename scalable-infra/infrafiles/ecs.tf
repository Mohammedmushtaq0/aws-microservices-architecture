# -------------------------
# ECS Cluster
# -------------------------
resource "aws_ecs_cluster" "product_v1_cluster" {
  name = "product-v1-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "product-v1-cluster"
  }
}

# -------------------------
# ECS Capacity Provider (connects ECS to ASG)
# -------------------------
resource "aws_ecs_capacity_provider" "web_asg_cp" {
  name = "web-asg-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.web_asg.arn

    # ECS should control instance lifecycle
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity            = 100       # keep 100% available capacity
      minimum_scaling_step_size  = 1
      maximum_scaling_step_size  = 2
      instance_warmup_period     = 60
    }
  }

  tags = {
    Name = "web-asg-capacity-provider"
  }
}

# -------------------------
# Attach Capacity Provider to ECS Cluster
# -------------------------
resource "aws_ecs_cluster_capacity_providers" "product_v1_cluster_providers" {
  cluster_name       = aws_ecs_cluster.product_v1_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.web_asg_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.web_asg_cp.name
    weight            = 1
    base              = 0
  }
}

# -------------------------
# ECS Task Definition
# -------------------------
resource "aws_ecs_task_definition" "web_app" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "web-container"
    image     = "851725373663.dkr.ecr.ap-south-1.amazonaws.com/ecrpage:latest"
    essential = true
    cpu       = 256
    memory    = 512
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])

  tags = {
    Name = "web-task-definition"
  }
}

# -------------------------
# ECS Service (linked to ALB + Capacity Provider)
# -------------------------
resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.product_v1_cluster.id
  task_definition = aws_ecs_task_definition.web_app.arn
  desired_count   = 1

  # Uses ECS-managed capacity provider (linked to ASG)
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.web_asg_cp.name
    weight            = 1
    base              = 0
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "web-container"
    container_port   = 80
  }

  network_configuration {
    subnets = [
      aws_subnet.product_v1_subnet_1a_private.id,
      aws_subnet.product_v1_subnet_1b_private.id
    ]
    security_groups = [aws_security_group.product_v1_sg.id]
  }

  depends_on = [aws_lb_listener.ecs_listener]

  tags = {
    Name = "web-ecs-service"
  }
}
