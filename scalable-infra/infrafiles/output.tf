#alb dns name as output and save in endpoints.txt file
output "alb_dns_name" {
  value       = aws_lb.ec2_alb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

resource "local_file" "alb_endpoint" {
  content  = aws_lb.ec2_alb.dns_name
  filename = "${path.module}/endpoints.txt"
}