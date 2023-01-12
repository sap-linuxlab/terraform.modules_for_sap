
# Define host security group rules
resource "aws_security_group" "vpc_sg" {
  name        = "${var.module_var_resource_prefix}-vpc-hosts-sg"
  vpc_id      = local.target_vpc_id
  description = "Open Ports for hosts in VPC"

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-hosts-sg"
  }

}

# Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers
resource "aws_security_group_rule" "vpc_sg_rule_outbound_dns_tcp" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}

# Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers
resource "aws_security_group_rule" "vpc_sg_rule_outbound_dns_udp" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}

# Allow Outbound HTTP Port 80 connection to any (e.g. via NAT Gateway)
resource "aws_security_group_rule" "vpc_sg_rule_outbound_http_80" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow Outbound HTTPS Port 443 connection to any (e.g. via NAT Gateway)
resource "aws_security_group_rule" "vpc_sg_rule_outbound_https_443" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow ping inbound from other hosts within the same Subnet
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "aws_security_group_rule" "vpc_sg_rule_ingress_icmp" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow ping outbound from hosts to any network, only for Subnet containing hosts (i.e. not for Bastion Subnet)
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "aws_security_group_rule" "vpc_sg_rule_egress_icmp" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# SSH Inbound from hosts within private VPC Subnet
resource "aws_security_group_rule" "vpc_sg_rule_ingress_ssh" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}

# SSH Outbound from hosts within private VPC Subnet
resource "aws_security_group_rule" "vpc_sg_rule_egress_ssh" {
  security_group_id = aws_security_group.vpc_sg.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}
