resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.instance_secuitygroup_name

  # Dynamic ingress rules based on the allowed ports
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidr_blocks
  }

  # Allow application traffic from Load Balancer only
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer_securitygroup.id]
  }

  # Outbound rules (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.instance_secuitygroup_name
  }
}
# RDS Security Group - Allow traffic from EC2 only
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.rds_securitygroup_name

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.instance_sg.id]
  }

  tags = {
    Name = var.rds_securitygroup_name
  }
}
# Load Balancer Security Group
resource "aws_security_group" "loadbalancer_securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = var.loadbalancer_securitygroup
  description = "Security group for Load Balancer"

  # Allow HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.lb_ingress_cidr_blocks
  }

  # Allow HTTPS traffic (port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.lb_ingress_cidr_blocks
  }

  # Allow all egress traffic (Load Balancer needs to communicate with instances)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.loadbalancer_securitygroup
  }
}