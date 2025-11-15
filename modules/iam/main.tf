# Elastic Beanstalk Service Role

resource "aws_iam_role" "beanstalk_service_role" {
  name = "${var.project_name}-beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-beanstalk-service-role"
  }
}

# Attach required service policies
resource "aws_iam_role_policy_attachment" "service_role" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "service_role_health" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

# EC2 Instance Role for Beanstalk

resource "aws_iam_role" "beanstalk_instance_role" {
  name = "${var.project_name}-beanstalk-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-beanstalk-instance-role"
  }
}

# Attach required policies to EC2 instance role
resource "aws_iam_role_policy_attachment" "instance_s3" {
  role       = aws_iam_role.beanstalk_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "instance_cloudwatch" {
  role       = aws_iam_role.beanstalk_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile (EC2 uses IAM role)

resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "${var.project_name}-beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_instance_role.name

  tags = {
    Name = "${var.project_name}-beanstalk-instance-profile"
  }
}
