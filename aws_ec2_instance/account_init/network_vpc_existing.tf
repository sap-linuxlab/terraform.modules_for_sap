# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC, Availability Zone

data "aws_subnet" "vpc_subnet" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 0 : 1
  id    = var.module_var_aws_vpc_subnet_id
}

data "aws_internet_gateway" "vpc_igw" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 0 : 1
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_subnet.vpc_subnet[0].vpc_id]
  }
}


locals {
  target_vpc_id                = var.module_var_aws_vpc_subnet_create_boolean ? "" : tostring(data.aws_subnet.vpc_subnet[0].vpc_id)
  target_vpc_availability_zone = var.module_var_aws_vpc_subnet_create_boolean ? "" : tostring(data.aws_subnet.vpc_subnet[0].availability_zone)
  target_subnet_ip_range       = var.module_var_aws_vpc_subnet_create_boolean ? "" : tostring(data.aws_subnet.vpc_subnet[0].cidr_block)
  target_vpc_igw               = var.module_var_aws_vpc_subnet_create_boolean ? "" : data.aws_internet_gateway.vpc_igw[0].id
}
