
# Create ACL for VPC Subnet/s
resource "aws_network_acl" "main" {
  vpc_id = local.target_vpc_id

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535
  }

  egress {
    protocol   = "udp"
    rule_no    = 302
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 303
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1
    to_port    = 65535
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-acl"
  }

}
