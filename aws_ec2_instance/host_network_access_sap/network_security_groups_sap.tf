
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

# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA indexserver MDC configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## In addition, there is another port offset +1 reserved for both systems to use during system replication communication.
## Source: SAP HANA Administration Guide, SAP HANA System Replication with Multi-Tenant Databases (MDC) -- https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/d20e1a973df9462fa92149f29ee2c455.html?version=latest
  ingress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}01")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}02")
    protocol    = "tcp"
    cidr_blocks = [local.target_subnet_ip_range]
  }
  egress {
    from_port   = tonumber("4${var.module_var_sap_hana_instance_no}01")
    to_port     = tonumber("4${var.module_var_sap_hana_instance_no}02")
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

  tags = {
    Name = "${var.module_var_resource_prefix}-sg-hosts-sap"
  }
}
