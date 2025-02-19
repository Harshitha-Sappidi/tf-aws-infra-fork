provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Fetching availability zones dynamically based on the selected region
data "aws_availability_zones" "available" {
  state = "available"
}
