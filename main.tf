resource "aws_lb" "alb" {
  count              = var.enable_alb ? 1 : 0
  name               = "Application-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.secgroup_id}"]
  subnets            = [for subnet in var.subnet_ids : subnet]

  enable_deletion_protection = true

  tags = {
    Name = "${var.environment}-${var.project}"
  }
}
resource "aws_lb_target_group" "alb_tg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn 

  default_action {
    type             = "forward"
    target_group_arn = ab_tg.arn
  }
}
