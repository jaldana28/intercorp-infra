data "aws_ami" "linuxAmi" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    owners = ["amazon"]
}

resource "aws_key_pair" "master-key" {
  key_name   = "jenkins-master"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-master" {
  ami                         = data.aws_ami.linuxAmi.id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  provisioner "local-exec" {
    command = <<EOF
      aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
      && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_jenkins.yaml
    EOF
  }
  tags = {
    Name = "jenkins_master_tf"
  }
}
