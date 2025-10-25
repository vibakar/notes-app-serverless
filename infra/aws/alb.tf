resource "aws_lb" "app_alb" {
  name               = var.app_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "frontend_blue_tg" {
  name     = "frontend-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
    timeout             = 5
  }

  target_type = "ip"
}

resource "aws_lb_target_group" "frontend_green_tg" {
  name     = "frontend-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 5
    timeout             = 5
  }

  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
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
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "www_frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type = "redirect"
    redirect {
      host        = local.frontend_domain_name
      path        = "/"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["${var.app_name}.${var.root_domain_name}"]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_blue_tg.arn
  }

  condition {
    host_header {
      values = [local.frontend_domain_name]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }
}