
# Define host security group rules
resource "aws_security_group" "bastion_connection_sg" {
  name        = "${var.module_var_resource_prefix}-vpc-bastion-proxy-connection-sg"
  vpc_id      = local.target_vpc_id
  description = "Open Ports for bastion connection to hosts in VPC"

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-bastion-proxy-connection-sg"
  }

}

# Allow Inbound SSH Port 22 connection from Bastion Subnet
resource "aws_security_group_rule" "bastion_connection_sg_rule_inbound_ssh" {
  security_group_id = aws_security_group.bastion_connection_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.vpc_bastion_subnet.cidr_block]
}


# Define host security group rules
resource "aws_security_group" "bastion_sg" {
  name        = "${var.module_var_resource_prefix}-vpc-bastion-sg"
  vpc_id      = local.target_vpc_id
  description = "Open Ports for bastion in VPC"

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-bastion-sg"
  }

}

# Allow Inbound SSH Port 22 connection from remote (i.e. Public Internet), required during provisioning
resource "aws_security_group_rule" "bastion_sg_rule_inbound_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow Inbound SSH Port chosen by user for connection from remote (i.e. Public Internet)
resource "aws_security_group_rule" "bastion_sg_rule_inbound_ssh_custom" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  from_port         = var.module_var_bastion_ssh_port
  to_port           = var.module_var_bastion_ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow Outbound SSH Port 22 connection from remote (i.e. Public Internet) to hosts
resource "aws_security_group_rule" "bastion_sg_rule_outbound_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion_connection_sg.id
}

# Allow Outbound HTTP to Public Internet
resource "aws_security_group_rule" "bastion_sg_rule_outbound_http_80" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow Outbound HTTPS to Public Internet (required for OS Package repositories)
resource "aws_security_group_rule" "bastion_sg_rule_outbound_https_443" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
