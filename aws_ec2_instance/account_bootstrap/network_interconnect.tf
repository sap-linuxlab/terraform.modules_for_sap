
# Create Transit Gateway to connect VPC to VPC, with Local Routing

resource "aws_ec2_transit_gateway" "tg_gateway" {
  description = "${var.module_var_resource_prefix}-tg"
  #  dns_support = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tg_gateway_attach_vpc_subnet" {
  subnet_ids         = [var.module_var_aws_vpc_subnet_id]
  transit_gateway_id = aws_ec2_transit_gateway.tg_gateway.id
  vpc_id             = local.target_vpc_id
}
