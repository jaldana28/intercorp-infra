resource "aws_lb" "application-lb" {
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [module.vpc.public_subnets[0],module.vpc.public_subnets[1] , 
                        module.vpc.public_subnets[2]]
  tags = {
    Name = "Jenkins-LB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  name        = "app-lb-tg"
  port        = 8080
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/login"
    port     = 8080
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "jenkins-target-group"
  }
}

resource "aws_lb_listener" "jenkins-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.arn_certificate
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}

resource "aws_lb_listener" "jenkins-listener-http" {
  load_balancer_arn = aws_lb.application-lb.arn
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

resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.jenkins-master.id
  port             = 8080
}

resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [module.vpc.public_subnets[0],module.vpc.public_subnets[1] , 
                        module.vpc.public_subnets[2]]
  tags = {
    Name = "Jenkins-LB"
  }
}

resource "aws_lb_target_group" "it-lb-tg" {
  name        = "it-lb-tg"
  port        = 8081
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 8081
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "app-target-group"
  }
}

resource "aws_lb_listener" "app-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.arn_certificate
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.it-lb-tg.arn
  }
}

resource "aws_lb_listener" "app-http" {
  load_balancer_arn = aws_lb.app-lb.arn
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

resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  target_group_arn = aws_lb_target_group.it-lb-tg.arn
  target_id        = aws_instance.jenkins-master.id
  port             = 8081
}











