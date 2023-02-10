
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# SAP Host Agent with SOAP over HTTP, saphostctrl process as 1128 port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphostctrl_http_soap" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphostctrl-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [1128]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphostctrl_http_soap" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphostctrl-http"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [1128]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SAP Host Agent with SOAP over HTTPS, saphostctrls process as 1129 port, access from within the same Subnet
resource "google_compute_firewall" "vpc_fw_rule_tcp_ingress_saphostctrl_https_soap" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-saphostctrl-https"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [1129]
  }

  direction  = "INGRESS"
#  destination_ranges = 
  source_ranges      = ["${local.target_vpc_subnet_range}"]
}
resource "google_compute_firewall" "vpc_fw_rule_tcp_egress_saphostctrl_https_soap" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-saphostctrl-https"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = [1129]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}
