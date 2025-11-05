# Fetch existing hosted zone
data "aws_route53_zone" "my_zone" {
  name         = "name.com." # change with your actual domain

  private_zone = false
}

# Alias A record
resource "aws_route53_record" "alb_alias_a" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "name.com." # change with your actual domain
  type    = "A"

  alias {
    name                   = aws_lb.ec2_alb.dns_name
    zone_id                = aws_lb.ec2_alb.zone_id
    evaluate_target_health = true
  }
}

# Alias AAAA record
resource "aws_route53_record" "alb_alias_aaaa" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "name.com." # change with your actual domain
  type    = "AAAA"

  alias {
    name                   = aws_lb.ec2_alb.dns_name
    zone_id                = aws_lb.ec2_alb.zone_id
    evaluate_target_health = true
  }
}
