output "alb_id" {
  value = aws_lb.alb[0].id
}

output "dns_name" {
  value = aws_lb.alb[0].dns_name
}
