resource "aws_lb" "alb" {
  name               = "Application-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
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
    type = var.cert_switch ? "redirect" : "forward"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    forward {
      target_group {
        arn = aws_lb_target_group.alb_tg.arn
       }
    }
  }
}
resource "aws_lb_listener" "https" {
  count             = var.cert_switch ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.environment} - ${var.project}-alb-"
  description = "Allowing HTTP & HTTPS connection to load balancer"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = toset(var.alb_ports)
    iterator = port
    content {
      from_port        = 0
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.environment} - ${var.project}-alb"
  }
}

