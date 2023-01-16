
# SAP Host Agent with SOAP over HTTP, saphostctrl process as 1128 port, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphostctrl_http_soap" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 1128
  to_port           = 1128
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphostctrl_http_soap" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 1128
  to_port           = 1128
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

# SAP Host Agent with SOAP over HTTPS, saphostctrls process as 1129 port, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphostctrl_https_soap" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 1129
  to_port           = 1129
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphostctrl_https_soap" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 1129
  to_port           = 1129
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
