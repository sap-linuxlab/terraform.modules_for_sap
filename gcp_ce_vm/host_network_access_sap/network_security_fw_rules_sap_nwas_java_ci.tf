
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP NetWeaver AS JAVA Central Instance (CI) ICM server process 0..n, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_sapnwas_java_ci_icm" {
  count   = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-java-ci-icm"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_java_ci_instance_no}00-5${var.module_var_sap_nwas_java_ci_instance_no}06"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

# SAP NetWeaver AS JAVA Central Instance (CI) Access server process 0..n, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_sapnwas_java_ci_access" {
  count   = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-java-ci-access"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_java_ci_instance_no}20-5${var.module_var_sap_nwas_java_ci_instance_no}22"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services HTTP server process 0..n, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_sapnwas_java_ci_admin_http" {
  count   = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-java-ci-admin-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_java_ci_instance_no}13-5${var.module_var_sap_nwas_java_ci_instance_no}14"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}

# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services SL Controller server process 0..n, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_sapnwas_java_ci_admin_slcontroller" {
  count   = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-sapnwas-java-ci-admin-slcontroller"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5${var.module_var_sap_nwas_java_ci_instance_no}17-5${var.module_var_sap_nwas_java_ci_instance_no}19"]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
