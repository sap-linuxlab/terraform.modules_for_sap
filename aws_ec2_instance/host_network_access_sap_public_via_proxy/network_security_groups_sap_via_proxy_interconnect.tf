
# SAP NetWeaver PAS / SAP GUI, and RFC connections
### ABAP dispatcher using 32<NN>
### ABAP gateway using 33<NN>
resource "aws_security_group_rule" "vpc_sg_rule_tcp_inbound_sapnwas_sapgui" {
  security_group_id = var.module_var_bastion_connection_sg_id

  type              = "ingress"
  source_security_group_id = var.module_var_bastion_sg_id
  from_port         = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
  to_port           = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  protocol          = "tcp"
}


# SAP HANA indexserver MDC System Database (SYSTEMDB) using 3<NN>13
# SAP HANA indexserver MDC Tenant #0 SYSTEMDB using 3<NN>15
# SAP HANA indexserver MDC Tenant #1--n using 3<NN>41
resource "aws_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana" {
  security_group_id = var.module_var_bastion_connection_sg_id

  type              = "ingress"
  source_security_group_id = var.module_var_bastion_sg_id
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}41")
  protocol          = "tcp"
}


# SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) Instance Number 01
# SAP Web GUI and SAP Fiori Launchpad (HTTPS)
### ABAP ICM HTTPS using 443<NN>, default 00
### Web Dispatcher HTTPS for NWAS PAS using 443<NN>, default 01
resource "aws_security_group_rule" "vpc_sg_rule_tcp_inbound_sapfiori" {
  security_group_id = var.module_var_bastion_connection_sg_id

  type              = "ingress"
  source_security_group_id = var.module_var_bastion_sg_id
  from_port         = tonumber("44300")
  to_port           = tonumber("443${max(var.module_var_sap_hana_instance_no,var.module_var_sap_nwas_pas_instance_no)}")
  protocol          = "tcp"
}


# SAP NetWeaver sapctrl HTTP/HTTPS from SAP HANA
resource "aws_security_group_rule" "vpc_sg_rule_tcp_inbound_sapctrl" {
  security_group_id = var.module_var_bastion_connection_sg_id

  type              = "ingress"
  source_security_group_id = var.module_var_bastion_sg_id
  from_port         = tonumber("5${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_hana_instance_no}14")
  protocol          = "tcp"
}
