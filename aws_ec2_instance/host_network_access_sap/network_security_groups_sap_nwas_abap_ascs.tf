
# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
