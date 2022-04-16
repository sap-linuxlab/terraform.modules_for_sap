
# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC, Availability Zone

data "aws_subnet" "vpc_subnet" {
  id = var.module_var_aws_vpc_subnet_id
}

data "aws_vpc" "vpc" {
  id = data.aws_subnet.vpc_subnet.vpc_id
}

locals {
  target_vpc_id                = data.aws_subnet.vpc_subnet.vpc_id
  target_vpc_availability_zone = data.aws_subnet.vpc_subnet.availability_zone
  target_subnet_ip_range       = data.aws_subnet.vpc_subnet.cidr_block
}
