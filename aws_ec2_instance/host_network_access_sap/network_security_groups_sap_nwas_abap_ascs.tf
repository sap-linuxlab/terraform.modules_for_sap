
# SAP NetWeaver AS ABAP Central Services (ASCS) Dispatcher, sapdp<ASCS_NN> process as 32<ASCS_NN> port, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), sapms<SAPSID> process as 36<ASCS_NN> port, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_abap_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_abap_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), sapenq<SAPSID> process as 39<ASCS_NN> port, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  to_port           = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS ABAP Central Services (ASCS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<ASCS_NN> and sapctrls<ASCS_NN> processes as 5<ASCS_NN>13 and 5<ASCS_NN>14 ports, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
