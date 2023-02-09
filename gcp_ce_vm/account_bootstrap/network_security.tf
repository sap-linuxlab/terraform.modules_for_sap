
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# Outbound via VPC SNAT
resource "google_compute_firewall" "vpc_fw_rule_egress_http_https" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-http-s"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  direction = "EGRESS"
#  destination_ranges = 
  source_ranges = ["0.0.0.0/0"]
}


# Allow ping inbound from other Virtual Servers within the same Subnet
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "google_compute_firewall" "vpc_fw_rule_ingress_icmp_subnet_internal" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-icmp-subnet-internal"
  network = local.target_vpc_name

  allow {
    protocol = "icmp"
    ports    = []
  }

  direction = "INGRESS"
#  destination_ranges = 
  source_ranges = ["${local.target_vpc_subnet_range}"]
}

# Allow ping outbound from Virtual Servers to any network, only for Subnet containing Virtual Servers (i.e. not for Bastion Subnet)
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "google_compute_firewall" "vpc_fw_rule_egress_icmp_subnet_internal" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-icmp-subnet-internal"
  network = local.target_vpc_name

  allow {
    protocol = "icmp"
    ports    = []
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}


# SSH Ingress from hosts within private VPC Subnet
resource "google_compute_firewall" "vpc_fw_rule_ingress_ssh_subnet_internal" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-ingress-ssh-subnet-internal"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction = "INGRESS"
#  destination_ranges = 
  source_ranges = ["${local.target_vpc_subnet_range}"]
}

# SSH Egress from hosts within private VPC Subnet
resource "google_compute_firewall" "vpc_fw_rule_egress_ssh_subnet_internal" {
  name    = "${var.module_var_resource_prefix}-vpc-fw-egress-ssh-subnet-internal"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction  = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
#  source_ranges      = 
}
