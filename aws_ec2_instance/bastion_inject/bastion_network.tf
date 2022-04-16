
# Create Subnet on the VPC
#
# The IPv4 cidr_block is clean definition but static

resource "aws_subnet" "vpc_bastion_subnet" {
  vpc_id                  = local.target_vpc_id
  cidr_block              = "10.200.240.0/28"
  enable_dns64            = false
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-bastion-subnet"
  }
}
