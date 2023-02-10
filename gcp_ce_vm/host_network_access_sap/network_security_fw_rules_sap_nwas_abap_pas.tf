
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher, sapdp<PAS_NN> process as 32<PAS_NN> port, for SAP GUI, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_pas_dp_sapgui" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-pas-dp-sapgui"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_pas_dp_sapgui" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-pas-dp-sapgui"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway, sapgw<PAS_NN> process as 33<PAS_NN> port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_pas_gw" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-pas-gw"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_pas_gw" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-pas-gw"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway Secured (with SNC Enabled), sapgw<PAS_NN>s process as 48<PAS_NN> port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_pas_gw_secure" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-pas-gw-secure"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_pas_gw_secure" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-pas-gw-secure"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS Primary Application Server (PAS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<PAS_NN> and sapctrls<PAS_NN> processes as 5<PAS_NN>13 and 5<PAS_NN>14 ports, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_pas_ctrl" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-pas-ctrl"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_abap_pas_instance_no}13-5${var.module_var_sap_nwas_abap_pas_instance_no}14"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_pas_ctrl" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-pas-ctrl"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_abap_pas_instance_no}13-5${var.module_var_sap_nwas_abap_pas_instance_no}14"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP NetWeaver AS Primary Application Server (PAS) ICM HTTPS for Web GUI and SAP Fiori Launchpad (HTTPS), icman process as 443<PAS_NN>, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_sap_ingress_sapnwas_abap_pas_icm" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-abap-pas-icm"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_sap_egress_sapnwas_abap_pas_icm" {
  count   = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-sapnwas-abap-pas-icm"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}
