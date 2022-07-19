
# SAP NetWeaver PAS / SAP GUI, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_sapgui" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
  to_port           = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP NetWeaver PAS Gateway, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_gw" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  to_port           = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_icm_https" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("43${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("43${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_icm_http" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("80${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("80${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP NetWeaver AS JAVA Message Server, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_sapnwas_java_ms" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
  to_port           = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP HANA Internal Web Dispatcher, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_webdisp" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}06")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}06")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_index_mdc_sysdb" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}13")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_index_mdc_1" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}15")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}15")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapfiori" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("443${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("443${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

# SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_ctrl" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_nwas_pas_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_nwas_pas_instance_no}14")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_saphana_hsr1" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}01")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}07")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_saphana_hsr1" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}01")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}07")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_saphana_hsr2" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}40")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}40")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_saphana_hsr2" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}40")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}40")
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_1" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 2224
  to_port           = 2224
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_1" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 2224
  to_port           = 2224
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_2" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 3121
  to_port           = 3121
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_2" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 3121
  to_port           = 3121
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_3" {
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 5404
  to_port           = 5412
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_3" {
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 5404
  to_port           = 5412
  protocol          = "tcp"
  ipv6_cidr_blocks  = [local.target_subnet_ip_range]
}
