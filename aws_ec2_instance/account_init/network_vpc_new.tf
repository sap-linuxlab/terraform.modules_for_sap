# If not using existing VPC Subnet, then create VPC

# Create VPC
resource "aws_vpc" "vpc" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  cidr_block           = "10.200.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc"
  }
}


# Create Subnet on the VPC - Public
#
# The IPv4 cidr_block is clean definition but static

resource "aws_subnet" "vpc_subnet_public" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = "10.200.220.0/28"
  enable_dns64            = false
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-subnet-public"
  }
}

# Create Subnet on the VPC - Private
#
# The IPv4 cidr_block is clean definition but static

resource "aws_subnet" "vpc_subnet_private" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = "10.200.10.0/24"
  enable_dns64            = false
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-subnet-private"
  }
}


# Create Route Table - Public
resource "aws_route_table" "vpc_rt_public" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-rt-public"
  }
}

# Create Route Table - Private
resource "aws_route_table" "vpc_rt_private" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_natgw_public.id
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-rt-private"
  }
}


# Subnet association to routing table
resource "aws_route_table_association" "vpc_rt_public_associate" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  subnet_id      = aws_subnet.vpc_subnet_public[0].id
  route_table_id = aws_route_table.vpc_rt_public[0].id
}
resource "aws_route_table_association" "vpc_rt_private_associate" {
  count = var.module_var_aws_vpc_subnet_create_boolean ? 1 : 0

  subnet_id      = aws_subnet.vpc_subnet_private[0].id
  route_table_id = aws_route_table.vpc_rt_private[0].id
}


# Terraform must take ownership of Default Routing Table for the VPC
resource "aws_default_route_table" "vpc_rt_default" {
  default_route_table_id = aws_vpc.vpc[0].default_route_table_id

  tags = {
    Name = "${var.module_var_resource_prefix}-rt-default"
  }
}
