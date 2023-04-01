
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_icm_https" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-icm-https"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("43${var.module_var_sap_hana_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_icm_https" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-icm-https"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("43${var.module_var_sap_hana_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_icm_http" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-icm-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("80${var.module_var_sap_hana_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_icm_http" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-icm-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("80${var.module_var_sap_hana_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA Internal Web Dispatcher, webdispatcher process, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_webdisp" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-webdisp"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}06")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_webdisp" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-webdisp"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}06")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_index_mdc_sysdb" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-index-mdc-sysdb"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}13")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_index_mdc_sysdb" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-index-mdc-sysdb"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}13")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_index_mdc_1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-index-mdc1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}15")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_index_mdc_1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-index-mdc1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("3${var.module_var_sap_hana_instance_no}15")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA for SOAP over HTTP for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
# SAP HANA for SOAP over HTTPS (Secure) for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphana_startsrv_http_soap" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-startsrv-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_hana_instance_no}13-5${var.module_var_sap_hana_instance_no}14"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphana_startsrv_http_soap" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-startsrv-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_hana_instance_no}13-5${var.module_var_sap_hana_instance_no}14"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_saphana_hsr1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-hsr1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}07"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

resource "google_compute_firewall" "vpc_fw_rule_sap_egress_saphana_hsr1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-hsr1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}07"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}

resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_saphana_hsr2" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-hsr2"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("4${var.module_var_sap_hana_instance_no}40")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

resource "google_compute_firewall" "vpc_fw_rule_sap_egress_saphana_hsr2" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-hsr2"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("4${var.module_var_sap_hana_instance_no}40")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}

resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_pacemaker_1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-pacemaker1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [2224]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

resource "google_compute_firewall" "vpc_fw_rule_sap_egress_pacemaker_1" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-pacemaker1"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [2224]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}

resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_pacemaker_2" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-pacemaker2"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [3121]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

resource "google_compute_firewall" "vpc_fw_rule_sap_egress_pacemaker_2" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-pacemaker2"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [3121]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}

resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_pacemaker_3" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphana-pacemaker3"
  network = local.target_vpc_name

  allow {
    protocol = "udp"
    ports    = ["5404-5412"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

resource "google_compute_firewall" "vpc_fw_rule_sap_egress_pacemaker_3" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphana-pacemaker3"
  network = local.target_vpc_name

  allow {
    protocol = "udp"
    ports    = ["5404-5412"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}
