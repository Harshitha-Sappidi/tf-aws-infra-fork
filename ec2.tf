# Commenting EC2 instance setup part
# resource "aws_instance" "web" {
#   ami                    = var.ami_id
#   instance_type          = var.instance_type
#   key_name               = var.key_name
#   subnet_id              = aws_subnet.public[0].id
#   vpc_security_group_ids = [aws_security_group.instance_sg.id]

# iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
# root_block_device {
#   volume_size           = var.root_volume_size
#   volume_type           = var.root_volume_type
#   delete_on_termination = true
# }

resource "aws_launch_template" "webapp" {
  name          = "webapp-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg.id]
  }

  disable_api_termination = false

  user_data = base64encode(<<-EOF
#!/bin/bash

# Update system packages
sudo apt update
sudo apt-get install -y mysql-client-core-8.0 unzip

# Install AWS CLI manually (if missing)
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    chmod +x ./aws/install
    sudo ./aws/install
    rm -rf awscliv2.zip aws
fi

# Navigate to the webapp directory
cd /opt/csye6225/webapp

# Write environment variables to .env file
echo "DB_HOST=${aws_db_instance.rds_instance.address}" >> .env
echo "DB_USER=${var.db_username}" >> .env
echo "DB_PASSWORD=${local.db_password} " >> .env
echo "DB_NAME=${var.db_name}" >> .env
echo "DB_PORT=${var.db_port}" >> .env
echo "S3_BUCKET_NAME=${aws_s3_bucket.webapp_bucket.bucket}" >> .env
echo "AWS_REGION=${var.aws_region}" >> .env
echo "PORT=${var.port}" >> .env

# Ensure CloudWatch config directory exists
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

# Create CloudWatch agent config file
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOT
{
  "agent": {
    "metrics_collection_interval": 10,
    "logfile": "/var/log/amazon-cloudwatch-agent.log"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/csye6225/webapp/logs/mywebapp.log",
            "log_group_name": "csye6225-log",
            "log_stream_name": "webapp-log",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "${var.namespace}",
    "metrics_collected": {
      "statsd": {
        "service_address": ":8125",
        "metrics_collection_interval": 10
      },
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOT

# Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

# Enable services on startup
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl enable webapp.service

# Start services
sudo systemctl restart amazon-cloudwatch-agent
sudo systemctl restart webapp.service
EOF
  )

  tags = {
    Name = var.instance_name
  }
}
