# Create RDS Instance
resource "aws_db_instance" "rds_instance" {
  identifier              = var.db_instance_id
  allocated_storage       = var.db_allocated_storage
  instance_class          = var.db_instance_class
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  db_name                 = var.db_name
  username                = var.db_username
  password                = random_password.db_password.result
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  parameter_group_name    = aws_db_parameter_group.my_param_group.name
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  tags = {
    Name = "csye6225-rds"
  }
      depends_on = [aws_db_subnet_group.rds_subnet_group]
  }

# Generate a random password for the RDS database
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# Create a Secrets Manager entry for storing the RDS database password
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "rds-db-password-fixed"
  recovery_window_in_days = 0  
}

# Store the RDS database password in Secrets Manager
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

# RDS Subnet Group, using private subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "rds_subnet_group"
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "my_param_group" {
  name   = var.db_parameter_group_name
  family = var.db_family

  parameter {
    name  = "max_connections"
    value = "100"
  }

}
