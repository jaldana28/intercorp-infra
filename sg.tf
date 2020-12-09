resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "alb_to_ec2" {
  type      = "egress"
  from_port = 8080
  to_port   = 8080
  protocol  = "TCP"

  source_security_group_id = aws_security_group.jenkins-sg.id
  security_group_id        = aws_security_group.lb-sg.id
}


resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "allow traffic from LB on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description     = "allow traffic from LB on port 8081"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
