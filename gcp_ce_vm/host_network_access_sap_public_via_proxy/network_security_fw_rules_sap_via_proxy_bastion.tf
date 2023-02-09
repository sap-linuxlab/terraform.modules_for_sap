
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP NetWeaver PAS / SAP GUI, and RFC connections
### ABAP dispatcher using 32<NN>
### ABAP gateway using 33<NN>
resource "google_compute_firewall" "vpc_fw_rule_tcp_bastion_egress_sapnwas_sapgui" {
  count   = local.network_rules_sap_nwas_abap_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-bastion-egress-sapnwas-sapgui"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["32${var.module_var_sap_hana_instance_no}-33${var.module_var_sap_hana_instance_no}"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${local.bastion_vpc_subnet_range}"]
}


# SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) Instance Number 01
# SAP Web GUI and SAP Fiori Launchpad (HTTPS)
### ABAP ICM HTTPS using 443<NN>, default 00
### Web Dispatcher HTTPS for NWAS PAS using 443<NN>, default 01
resource "google_compute_firewall" "vpc_fw_rule_tcp_bastion_egress_sapfiori" {
  count   = local.network_rules_sap_nwas_abap_boolean ? local.network_rules_sap_hana_boolean ? 1 : 0 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-bastion-egress-sapfiori"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["${tonumber(var.module_var_sap_hana_instance_no) < tonumber(var.module_var_sap_nwas_abap_pas_instance_no) ? tonumber("443${var.module_var_sap_hana_instance_no}") : tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")}-${tonumber(var.module_var_sap_hana_instance_no) > tonumber(var.module_var_sap_nwas_abap_pas_instance_no) ? tonumber("443${var.module_var_sap_hana_instance_no}") : tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")}"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${local.bastion_vpc_subnet_range}"]
}


# SAP NetWeaver sapctrl HTTP/HTTPS from SAP HANA
resource "google_compute_firewall" "vpc_fw_rule_tcp_bastion_egress_sapctrl" {
  count   = local.network_rules_sap_nwas_abap_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-bastion-egress-sapctrl"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_hana_instance_no}13-5${var.module_var_sap_hana_instance_no}14"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${local.bastion_vpc_subnet_range}"]
}


# SAP HANA indexserver MDC System Database (SYSTEMDB) using 3<NN>13
# SAP HANA indexserver MDC Tenant #0 SYSTEMDB using 3<NN>15
# SAP HANA indexserver MDC Tenant #1--n using 3<NN>41
resource "google_compute_firewall" "vpc_fw_rule_tcp_bastion_egress_saphana" {
  count   = local.network_rules_sap_hana_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-bastion-egress-saphana"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["3${var.module_var_sap_hana_instance_no}13-3${var.module_var_sap_hana_instance_no}41"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${local.bastion_vpc_subnet_range}"]
}
