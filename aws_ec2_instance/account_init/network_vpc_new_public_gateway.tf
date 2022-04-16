
# Create Internet Gateway for the VPC
# Only 1 IGW per VPC
# This is a requirement for the NAT Gateway of a Subnet

resource "aws_internet_gateway" "vpc_igw" {
  #count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : (local.target_subnet_public_gateway == "" ? 1 : 0)

  vpc_id = var.module_var_aws_vpc_subnet_create_boolean ? aws_vpc.vpc[0].id : local.target_vpc_id

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-igw"
  }
}


# Create NAT Gateway for the Subnet
#
# Allows Subnet to communicate with public internet as
# a Many-to-One NAT whereby the entire Subnet shares the same outbound Floating IP (Public IP / Public endpoint).
#
# The Public Gateway (PGW) does not enable the Internet to initiate a connection with those instances (this will still require a Jump/Bastion host)

resource "aws_eip" "vpc_nat_eip" {
  #count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : (local.target_subnet_public_gateway == "" ? 1 : 0)
}

resource "aws_nat_gateway" "vpc_natgw_public" {
  #count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : (local.target_subnet_public_gateway == "" ? 1 : 0)

  depends_on = [
    aws_eip.vpc_nat_eip,
    aws_internet_gateway.vpc_igw
  ]

  connectivity_type = "public"
  allocation_id     = aws_eip.vpc_nat_eip.id
  subnet_id         = var.module_var_aws_vpc_subnet_create_boolean ? aws_subnet.vpc_subnet_public[0].id : var.module_var_aws_vpc_subnet_id

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-natgw"
  }
}
