resource "aws_lauch_configuration" "ec2-cluster" {
  image_id        = "ami-06e46074ae430fba6"
  instance_type   = "t2.micro"
  security_groups = [var.sg-id]
  user_data       = var.user-data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "asg-tg" {
  name     = "asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_lauch_configuration.ec2-cluser.name
  vpc_zone_identifier  = var.vpc-subnet-ids
  target_group_arns    = [aws_lb_target_group.asg-tg.arn]
  health_check_type    = "ELB"
  min_size             = 2
  max_size             = 3
  desired_capacity     = 3
}

resource "aws" "lb" {
  name               = "${var.cluster}-lb"
  load_balancer_type = "application"
  subnets            = var.vpc-subnet-ids
  security_groups    = [var.sg-id]
}

resource "aws_lb_listener" "http" {
  listener_arn = aws_lb.lb.arn
  port         = 80
  protocol     = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg-listen" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-tg.arn
  }
}

