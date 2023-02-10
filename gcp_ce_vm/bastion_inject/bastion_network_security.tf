
# Firewall Rules are within a logical container, which can be either:
# - GCP VPC Network Firewall, for 1 VPC Network in 1 GCP Project. Terraform Resource for individual rules managed by 'google_compute_firewall'.
# - GCP Firewall Policies
#   - Type 1. Hierarchical Firewall Policies, attached to 1..n VPC Networks in 1..n GCP Projects. Terraform Resource is 'google_compute_firewall_policy', individual rules managed by Terraform use 'google_compute_firewall_policy_rule'.
#   - Type 2. Network Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects. Terraform Resource is 'google_compute_network_firewall_policy', individual rules managed by Terraform use 'google_compute_network_firewall_policy_rule', .
#   - Type 3. Regional Firewall Policies, attached to 1..n VPC Networks in 1 GCP Projects in 1 Region. Terraform Resource is 'google_compute_region_network_firewall_policy', individual rules managed by Terraform use 'google_compute_region_network_firewall_policy_rule'.


# GCP VPC Network Firewall rules control the inbound and outbound traffic within all subnets of 1 VPC, and to/from all Virtual Machine instances
# GCP VPC Network Firewall rules can be assigned to specific Virtual Machine instances using 'Target Tags', similar to VPC Security Groups from other Cloud Service Providers


# Allow Inbound SSH Port 22 connection on Hosts Subnet, from the Bastion Subnet
resource "google_compute_firewall" "bastion_connection_fw_rule_ingress_ssh" {
  name    = "${var.module_var_resource_prefix}-vpc-bastion-proxy-connection-fw-ingress-ssh"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction = "INGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${google_compute_subnetwork.vpc_bastion_subnet.ip_cidr_range}"]
}



# Allow Inbound SSH Port 22 connection from remote (i.e. Public Internet), required during provisioning
resource "google_compute_firewall" "bastion_fw_rule_ingress_ssh" {
  name    = "${var.module_var_resource_prefix}-vpc-bastion-proxy-fw-ingress-ssh"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction = "INGRESS"
  destination_ranges = ["${google_compute_subnetwork.vpc_bastion_subnet.ip_cidr_range}"]
  source_ranges      = ["0.0.0.0/0"]
}

# Allow Inbound SSH Port chosen by user for connection from remote (i.e. Public Internet)
resource "google_compute_firewall" "bastion_fw_rule_ingress_ssh_custom" {
  name    = "${var.module_var_resource_prefix}-vpc-bastion-proxy-fw-ingress-ssh-custom"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["${var.module_var_bastion_ssh_port}"]
  }

  direction = "INGRESS"
  destination_ranges = ["${google_compute_subnetwork.vpc_bastion_subnet.ip_cidr_range}"]
  source_ranges      = ["0.0.0.0/0"]
}

# Allow Outbound SSH Port 22 connection on Bastion Subnet, to the Bastion Subnet
resource "google_compute_firewall" "bastion_fw_rule_egress_ssh" {
  name    = "${var.module_var_resource_prefix}-vpc-bastion-proxy-fw-egress-ssh"
  network = local.target_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction = "EGRESS"
  destination_ranges = ["${local.target_vpc_subnet_range}"]
  source_ranges      = ["${google_compute_subnetwork.vpc_bastion_subnet.ip_cidr_range}"]
}



# Outbound via VPC SNAT
# Allow Outbound HTTP/S to Public Internet (required for OS Package repositories)
resource "google_compute_firewall" "bastion_fw_rule_egress_http_https" {
  name    = "${var.module_var_resource_prefix}-vpc-bastion-proxy-fw-egress-http-s"
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
