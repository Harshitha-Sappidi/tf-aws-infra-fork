resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
  }

  disable_api_termination = false

  user_data = <<-EOF
               #!/bin/bash

               # Update and install required packages
               sudo apt update && sudo apt install -y awscli jq
               sudo apt-get install -y mysql-client-core-8.0

               # Navigate to the webapp directory
               cd /opt/csye6225/webapp

               # Write environment variables to .env file
               echo "DB_HOST=${aws_db_instance.rds_instance.address}" >> .env
               echo "DB_USER=${var.db_username}" >> .env
               echo "DB_PASSWORD=${random_password.db_password.result}" >> .env
               echo "DB_NAME=${var.db_name}" >> .env
               echo "DB_PORT=${var.db_port}" >> .env
               echo "S3_BUCKET_NAME=${aws_s3_bucket.webapp_bucket.bucket}" >> .env
               echo "AWS_REGION=${var.aws_region}" >> .env
               echo "PORT=${var.port}" >> .env

               # Reload and restart services
               systemctl daemon-reload
               systemctl enable webapp.service
               systemctl restart webapp.service
EOF

  tags = {
    Name = var.instance_name
  }
}
