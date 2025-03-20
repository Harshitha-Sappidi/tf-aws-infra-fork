# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "EC2S3SecretsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
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
}

# Custom S3 Policy for EC2 Access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3FullAccessPolicy"
  description = "Policy to allow EC2 full access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.webapp_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket.webapp_bucket]
}

# Attach S3 Policy to IAM Role
resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# IAM Policy for EC2 to Access Secrets Manager
resource "aws_iam_policy" "ec2_secrets_manager_policy" {
  name        = "EC2SecretsManagerPolicy"
  description = "Policy to allow EC2 instance to retrieve secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db_password.arn
      }
    ]
  })
}

# Attach Secrets Manager Policy to IAM Role
resource "aws_iam_role_policy_attachment" "ec2_secrets_manager_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_secrets_manager_policy.arn
}

# IAM Instance Profile for EC2 Instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfileWithS3AndSecretsAccess"
  role = aws_iam_role.ec2_role.name
}
