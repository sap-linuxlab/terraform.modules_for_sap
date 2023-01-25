
# SAP NetWeaver AS JAVA Central Instance (CI) ICM server process 0..n, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_sapnwas_java_ci_icm" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}00")
  to_port           = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}06")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS JAVA Central Instance (CI) Access server process 0..n, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_sapnwas_java_ci_access" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}20")
  to_port           = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}22")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services HTTP server process 0..n, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_sapnwas_java_ci_admin_http" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services SL Controller server process 0..n, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_sapnwas_java_ci_admin_slcontroller" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}17")
  to_port           = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}19")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
