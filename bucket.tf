resource "aws_s3_bucket" "jenkins-volume" {
  bucket = "jenkins-volume-intercorp"
  acl    = "private"

  tags = {
    Name        = "Jenkis-volume"
    Environment = "prod"
  }
}