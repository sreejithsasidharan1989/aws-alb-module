output "alb_id" {
  value = aws_lb.alb.id
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "tg_arn" {
  value = aws_lb_target_group.alb_tg.arn
}
