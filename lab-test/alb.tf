# alb
resource "aws_alb" "external-alb" {
  name                       = "${var.service}-${var.alb["external_alb_name"]}"
  subnets                    = aws_subnet.public.*.id
  security_groups            = [aws_security_group.external-alb-sg.id]
  internal                   = false
  enable_deletion_protection = false
  idle_timeout               = 120

  tags = {
    Name        = "${var.service}-${var.alb["external_alb_name"]}"
    service     = var.service
  }
}

# alb (listen add target group 80)
resource "aws_alb_listener" "external-alb-insecure-listener" {
  load_balancer_arn = aws_alb.external-alb.arn
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

# alb (listen add target group 443)
resource "aws_alb_listener" "external-alb-secure-listener" {
  load_balancer_arn = aws_alb.external-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }

}

resource "aws_alb_target_group" "fe" {
  name                 = "${var.service}-${var.alb["alb_tg_fe_name"]}"
  port                 = var.container_fe["docker_port"]
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = "60"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Name        = "${var.service}-${var.alb["alb_tg_fe_name"]}"
    service     = var.service
  }
}

resource "aws_alb_target_group" "be" {
  name                 = "${var.service}-${var.alb["alb_tg_be_name"]}"
  port                 = var.container_be["docker_port"]
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = "60"

  health_check {
    interval            = 30
    path                = "/health-check"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Name        = "${var.service}-${var.alb["alb_tg_be_name"]}"
    service     = var.service
  }
}

#RULE
resource "aws_alb_listener_rule" "external-alb-fe-listener" {
  listener_arn = aws_alb_listener.external-alb-secure-listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.fe.arn
  }
  condition {
    host_header {
      values = ["${var.service}.${var.domain}"]
    }
  }
}

resource "aws_alb_listener_rule" "external-alb-be-listener" {
  listener_arn = aws_alb_listener.external-alb-secure-listener.arn
  priority     = 110
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.be.arn
  }
  condition {
    host_header {
      values = ["${var.service}-api.${var.domain}"]
    }
  }
}