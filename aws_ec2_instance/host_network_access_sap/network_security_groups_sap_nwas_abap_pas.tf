
# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher (sapdp), for SAP GUI, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  to_port           = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  to_port           = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway (sapgw), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  to_port           = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  to_port           = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapfiori" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("443${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("443${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

# SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
