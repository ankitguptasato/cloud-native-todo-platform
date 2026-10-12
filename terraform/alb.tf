
resource "aws_lb" "app" {
  name               = "platform-lab-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_secondary.id
  ]

  tags = {
    Name        = "platform-lab-alb"
    Environment = "learning"
  }
}


resource "aws_lb_target_group" "app" {
  name     = "platform-lab-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.platform.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "platform-lab-tg"
    Environment = "learning"
  }
}


resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}