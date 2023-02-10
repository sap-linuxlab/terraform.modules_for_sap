
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_nfs" {
  security_group_id = var.module_var_host_sg_id
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_nfs" {
  security_group_id = var.module_var_host_sg_id
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["${local.target_subnet_ip_range}"]
}
