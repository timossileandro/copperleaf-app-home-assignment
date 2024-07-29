# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.dns_zone
  tags = local.tags
}

# Route 53 DNS Record
resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.dns_record
  type    = "A"

  alias {
    name                   = aws_lb.nat_lb.dns_name
    zone_id                = aws_lb.nat_lb.zone_id
    evaluate_target_health = true
  }
}