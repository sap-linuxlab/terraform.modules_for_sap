
# Create Route Table - Bastion
resource "aws_route_table" "vpc_bastion_rt" {

  vpc_id = local.target_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.module_var_aws_vpc_igw_id
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-bastion-rt"
  }
}


# Subnet association to Bastion routing table
resource "aws_route_table_association" "vpc_bastion_rt_associate" {
  subnet_id      = aws_subnet.vpc_bastion_subnet.id
  route_table_id = aws_route_table.vpc_bastion_rt.id
}
