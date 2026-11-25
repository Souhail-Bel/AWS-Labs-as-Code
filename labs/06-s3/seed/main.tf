# Lab provides you:
#   the role of the "Bastion Host" instance
#   -it can read S3 but not write

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "instance" {
  name = "EC2InstanceProfileRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
      {
        # creds as instance, stand-in SSM session on bastion host
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

# read-only
resource "aws_iam_role_policy" "s3_read" {
  name = "s3-read"
  role = aws_iam_role.instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:Get*", "s3:List*"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "instance" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.instance.name
}