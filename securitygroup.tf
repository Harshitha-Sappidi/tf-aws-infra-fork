resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.instance_secuitygroup_name

  # Dynamic ingress rules based on the allowed ports
  dynamic "ingress" {
    for_each = var.allowed_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  # Outbound rules (egress)
  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
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