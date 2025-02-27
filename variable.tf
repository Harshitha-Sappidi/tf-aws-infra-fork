variable "aws_region" {
  description = "AWS Region where resources will be created"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_name" {
  description = "Custom name for public subnets"
  type        = string
  default     = "PublicSubnet"
}

variable "private_subnet_name" {
  description = "Custom name for private subnets"
  type        = string
  default     = "PrivateSubnet"
}
variable "public_route_table_name" {
  description = "Custom name for the public route table"
  type        = string
  default     = "PublicRouteTable"
}

variable "private_route_table_name" {
  description = "Custom name for the private route table"
  type        = string
  default     = "PrivateRouteTable"
}
variable "vpc_name" {
  description = "Custom name for the VPC"
  type        = string
  default     = "MainVPC"
}
variable "destination_cidr_block" {
  description = "CIDR block for public internet access route"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume"
  type        = number
  default     = 25
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp2"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "allowed_ingress_ports" {
  description = "List of allowed ingress ports for the security group"
  type        = list(number)
  default     = [22, 80, 443, 8080]
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for EC2 instance"
  type        = list(string)
  default     = []
}
variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "Egress rule: from port (default: all traffic)"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "Egress rule: to port (default: all traffic)"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol for egress traffic (default: all protocols)"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks allowed for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}