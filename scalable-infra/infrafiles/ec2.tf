# -------------------------
# Launch Template for ECS EC2 Instances
# -------------------------
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-server-"
  description   = "Launch template for ECS container instances"
  image_id      = "ami-0b6a75973f8e1297f"   # ✅ ECS-Optimized Amazon Linux 2 AMI
  instance_type = "t3.small"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.product_v1_sg.id]
  }

  

  user_data = base64encode(<<EOF
#!/bin/bash
set -ex

# Update system packages
yum update -y

# Ensure ECS config directory exists
mkdir -p /etc/ecs

# Configure ECS cluster name for the ECS agent
echo "ECS_CLUSTER=${aws_ecs_cluster.product_v1_cluster.name}" > /etc/ecs/ecs.config
echo "ECS_BACKEND_HOST=" >> /etc/ecs/ecs.config

# Enable and restart ECS agent
systemctl enable --now ecs
systemctl restart ecs
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-container-instance"
      Role = "ECS-Cluster-Node"
    }
  }
}
