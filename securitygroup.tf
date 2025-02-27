resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  name   = var.sg_name

  # Dynamically create ingress rules based on the allowed ports
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
    Name = var.sg_name
  }
}
