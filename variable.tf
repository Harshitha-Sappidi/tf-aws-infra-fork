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