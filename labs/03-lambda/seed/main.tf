# The lab hands you a network to attach the function to and the role it runs as

resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "Lab VPC" }
}

resource "aws_subnet" "lab" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.1.0/24"
  tags       = { Name = "Lab Subnet" }
}

resource "aws_security_group" "lambda" {
  name        = "LambdaSecurityGroup"
  description = "Security group for the thumbnail function"
  vpc_id      = aws_vpc.lab.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# function in VPC (with no NAT) needs endpoint to reach S3
# this is only needed for real AWS
resource "aws_vpc_endpoint" "s3" {
  count             = var.use_floci ? 0 : 1
  vpc_id            = aws_vpc.lab.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [aws_vpc.lab.default_route_table_id]
  vpc_endpoint_type = "Gateway"
}

resource "aws_iam_role" "lambda_execution" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_execution" {
  name = "thumbnail-access"
  role = aws_iam_role.lambda_execution.id



  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Logs"
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
      {
        Sid      = "ReadWriteImages"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "arn:aws:s3:::images-*/*"
      },
      {
        Sid    = "VpcNetworking"
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSubnets",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        Resource = "*"
      },
    ]
  })
}
