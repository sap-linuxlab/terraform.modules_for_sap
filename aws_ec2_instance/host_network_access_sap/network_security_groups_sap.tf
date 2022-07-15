
# Define SAP HANA / SAP NetWeaver Application Server Ports
resource "aws_security_group" "vpc_sg_hosts_sap" {
  name        = "${var.module_var_resource_prefix}-sg-hosts-sap"
  vpc_id      = local.target_vpc_id
  description = "Open Ports for SAP Systems"

  # SAP NetWeaver PAS Gateway, access from within the same Subnet
  ingress {
    from_port   = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
    to_port     = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
  ingress {
    from_port   = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
    to_port     = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
  ingress {
    from_port   = tonumber("43${var.module_var_sap_hana_instance_no}")
    to_port     = tonumber("43${var.module_var_sap_hana_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
  ingress {
    from_port   = tonumber("80${var.module_var_sap_hana_instance_no}")
    to_port     = tonumber("80${var.module_var_sap_hana_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP NetWeaver AS JAVA Message Server, access from within the same Subnet
  ingress {
    from_port   = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
    to_port     = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA Internal Web Dispatcher, access from within the same Subnet
  ingress {
    from_port   = tonumber("3${var.module_var_sap_hana_instance_no}06")
    to_port     = tonumber("3${var.module_var_sap_hana_instance_no}06")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
  ingress {
    from_port   = tonumber("3${var.module_var_sap_hana_instance_no}13")
    to_port     = tonumber("3${var.module_var_sap_hana_instance_no}13")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
  ingress {
    from_port   = tonumber("3${var.module_var_sap_hana_instance_no}15")
    to_port     = tonumber("3${var.module_var_sap_hana_instance_no}15")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
  ingress {
    from_port   = tonumber("443${var.module_var_sap_hana_instance_no}")
    to_port     = tonumber("443${var.module_var_sap_hana_instance_no}")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  # SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
  ingress {
    from_port   = tonumber("5${var.module_var_sap_nwas_pas_instance_no}13")
    to_port     = tonumber("5${var.module_var_sap_nwas_pas_instance_no}13")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
  ingress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}01")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}07")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}01")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}07")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  ingress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}40")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}40")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}40")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}40")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  ingress {
    from_port   = 2224
    to_port     = 2224
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = 2224
    to_port     = 2224
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  ingress {
    from_port   = 3121
    to_port     = 3121
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = 3121
    to_port     = 3121
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  ingress {
    from_port   = 5404
    to_port     = 5412
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = 5404
    to_port     = 5412
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-sg-hosts-sap"
  }
}
