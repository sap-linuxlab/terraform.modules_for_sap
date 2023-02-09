
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP NetWeaver AS ABAP Central Services (ASCS) Dispatcher, sapdp<ASCS_NN> process as 32<ASCS_NN> port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_ascs_dp" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-ascs-dp"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_ascs_dp" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-ascs-dp"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), sapms<SAPSID> process as 36<ASCS_NN> port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_ascs_ms" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-ascs-ms"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_ascs_ms" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-ascs-ms"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), sapdp<ASCS_NN> process as 39<ASCS_NN> port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_ascs_en" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-ascs-en"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_ascs_en" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-ascs-en"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS ABAP Central Services (ASCS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<ASCS_NN> and sapctrls<ASCS_NN> processes as 5<ASCS_NN>13 and 5<ASCS_NN>14 ports, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_ascs_ctrl" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-ascs-ctrl"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_abap_ascs_instance_no}13-5${var.module_var_sap_nwas_abap_ascs_instance_no}14"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_ascs_ctrl" {
  count   = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-ascs-ctrl"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_abap_ascs_instance_no}13-5${var.module_var_sap_nwas_abap_ascs_instance_no}14"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}
