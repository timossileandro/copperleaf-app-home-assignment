output "nlb_dns_name" {
  description = "The DNS name of the NLB"
  value       = aws_lb.nat_lb.dns_name
}

output "app_dns_name" {
  description = "The DNS name of the Route53 Record"
  value       = aws_route53_record.alb.name
}