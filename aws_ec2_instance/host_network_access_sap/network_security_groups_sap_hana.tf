
# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("43${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("43${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("43${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("43${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("80${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("80${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("80${var.module_var_sap_hana_instance_no}")
  to_port           = tonumber("80${var.module_var_sap_hana_instance_no}")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA Internal Web Dispatcher, webdispatcher process, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}06")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}06")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}06")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}06")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}13")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}13")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}15")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}15")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("3${var.module_var_sap_hana_instance_no}15")
  to_port           = tonumber("3${var.module_var_sap_hana_instance_no}15")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA for SOAP over HTTP for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_hana_instance_no}13")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("5${var.module_var_sap_hana_instance_no}13")
  to_port           = tonumber("5${var.module_var_sap_hana_instance_no}13")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}


# SAP HANA for SOAP over HTTPS (Secure) for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "aws_security_group_rule" "vpc_sg_rule_tcp_ingress_saphana_startsrv_https_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("5${var.module_var_sap_hana_instance_no}14")
  to_port           = tonumber("5${var.module_var_sap_hana_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
resource "aws_security_group_rule" "vpc_sg_rule_tcp_egress_saphana_startsrv_https_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("5${var.module_var_sap_hana_instance_no}14")
  to_port           = tonumber("5${var.module_var_sap_hana_instance_no}14")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}



# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}01")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}07")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}01")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}07")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}40")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}40")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = tonumber("4${var.module_var_sap_hana_instance_no}40")
  to_port           = tonumber("4${var.module_var_sap_hana_instance_no}40")
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 2224
  to_port           = 2224
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 2224
  to_port           = 2224
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 3121
  to_port           = 3121
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 3121
  to_port           = 3121
  protocol          = "tcp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_ingress_pacemaker_3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "ingress"
  from_port         = 5404
  to_port           = 5412
  protocol          = "udp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}

resource "aws_security_group_rule" "vpc_sg_rule_sap_egress_pacemaker_3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  security_group_id = var.module_var_host_security_group_id
  type              = "egress"
  from_port         = 5404
  to_port           = 5412
  protocol          = "udp"
  cidr_blocks  = ["${local.target_subnet_ip_range}"]
}
