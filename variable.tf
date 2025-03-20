variable "aws_region" {
  description = "AWS Region where resources will be created"
  type        = string
  default     = "us-east-1"
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
# EC2 Configuration
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

# Security Group Configuration
variable "instance_secuitygroup_name" {
  description = "Name of the Instance security group"
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

# RDS Configuration

variable "db_instance_id" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage size for the RDS instance (in GB)"
  type        = number
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine for the RDS instance"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Engine version for the RDS instance"
  type        = string
  default     = "8.0.36"
}

variable "db_port" {
  description = "Port for the RDS database"
  default     = 3306
  type        = number
}
variable "port" {
  description = "Port"
  default     = 8080
  type        = number
}
variable "db_name" {
  description = "Database name"
  default     = "csye6225"
}
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Subnet group name for the RDS instance"
  type        = string
  default     = "rds-private-subnet-group"
}

variable "db_family" {
  description = "Family of the RDS parameter group"
  type        = string
  default     = "mysql8.0"
}

variable "db_parameter_group_name" {
  description = "Name of the RDS parameter group"
  type        = string
}

variable "rds_securitygroup_name" {
  description = "Name of the RDS security group"
  type        = string
}
