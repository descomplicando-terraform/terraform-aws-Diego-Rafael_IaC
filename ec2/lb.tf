# Create a new load balancer
resource "aws_lb" "web-instances" {
  name               = "elb-web-instances"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-web-instances.id]
  subnets            = values(var.subnets_map)

  tags = {
    Name = "elb-web-instances"
  }
}

# Listener para o Application Load Balancer
resource "aws_lb_listener" "http-web-instances" {
  load_balancer_arn = aws_lb.web-instances.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-web-instances.arn
  }

  depends_on = [aws_lb_target_group.tg-web-instances]
}

# Criar o Target Group
resource "aws_lb_target_group" "tg-web-instances" {
  name        = "tg-web-instances"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_terraform.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-web-instances"
  }
}

# Registrar as instâncias no Target Group
resource "aws_lb_target_group_attachment" "web-instances" {
  for_each = aws_instance.web

  target_group_arn = aws_lb_target_group.tg-web-instances.arn
  target_id        = each.value.id
  port             = 80

  depends_on = [aws_lb_target_group.tg-web-instances]
}

