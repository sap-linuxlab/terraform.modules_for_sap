
# Create security group for bastion connection to instances inside VPC
# (available to use by all Subnets in all Zones)
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
#
# Create Security Group with standalone declarations of Security Group Rules.
# Alternative is to use in-line rules nested in ibm_is_vpc or ibm_is_security_group Terraform Resources. Use of both will cause conflict of rule settings.
# Uses depends_on to provide an order to the rules

# Security Group for Virtual Servers to use Proxy Connection via Bastion/Jump Host
resource "ibm_is_security_group" "vpc_sg_virtualserver_bastion_proxy_connection" {
  name           = "${var.module_var_resource_prefix}-vpc-bastion-proxy-connection-sg"
  vpc            = local.target_vpc_id
  resource_group = var.module_var_resource_group_id
}

# Security Group Rule for Virtual Server - Allow Inbound Proxy Connection on SSH Port 22 via the Bastion/Jump Host to Virtual Server
resource "ibm_is_security_group_rule" "vpc_sg_rule_virtualserver_bastion_proxy_connection_inbound_ssh" {
  group     = ibm_is_security_group.vpc_sg_virtualserver_bastion_proxy_connection.id
  direction = "inbound"
  remote    = ibm_is_security_group.vpc_sg_bastion.id

  tcp {
    port_min = 22
    port_max = 22
  }
}


# Create security group for a bastion inside VPC
# (available to use by all Subnets in all Zones)
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
#
# Create Security Group with standalone declarations of Security Group Rules.
# Alternative is to use in-line rules nested in ibm_is_vpc or ibm_is_security_group Terraform Resources. Use of both will cause conflict of rule settings.
# Uses depends_on to provide an order to the rules

# Security Group for Bastion/Jump Host - Allow Connection from remote (i.e. Public Internet)
resource "ibm_is_security_group" "vpc_sg_bastion" {
  name           = "${var.module_var_resource_prefix}-vpc-bastion-sg"
  vpc            = local.target_vpc_id
  resource_group = var.module_var_resource_group_id
}

# Security Group Rule for Bastion/Jump Host - Allow Inbound SSH Port 22 connection from remote (i.e. Public Internet)
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_ssh_all_initial" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}


# Security Group Rule for Bastion/Jump Host - Allow Inbound SSH Port chosen by user for connection from remote (i.e. Public Internet)
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_ssh_all" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = var.module_var_bastion_ssh_port
    port_max = var.module_var_bastion_ssh_port
  }
}

# Security Group Rule for Bastion/Jump Host - Allow Outbound SSH Port 22 connection from remote (i.e. Public Internet) to Virtual Server
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_ssh_to_virtualserver" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "outbound"
  remote    = ibm_is_security_group.vpc_sg_virtualserver_bastion_proxy_connection.id

  tcp {
    port_min = 22
    port_max = 22
  }
}


# Security Group Rule for Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers; avoids SSH lag
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_dns_tcp" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "outbound"
  remote    = "161.26.0.0/28"

  tcp {
    port_min = 53
    port_max = 53
  }
}

# Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers; avoids SSH lag
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_dns_udp" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "outbound"
  remote    = "161.26.0.0/28"

  udp {
    port_min = 53
    port_max = 53
  }
}

# Allow Inbound/Outbound any protocol or port to Classic IaaS Endpoints range using adn.networklayer.com domain
# Required for access to OS Packages, e.g. Red Hat Satellite
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_ibmcloud_classic_iaas" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "inbound"
  remote    = "161.26.0.0/16"
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_ibmcloud_classic_iaas" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "outbound"
  remote    = "161.26.0.0/16"
}

# Allow any protocol or port to Cloud Service Endpoints (CSE) range using serviceendpoint.cloud.ibm.com domain
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_ibmcloud_cse" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "inbound"
  remote    = "166.8.0.0/14"
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_ibmcloud_cse" {
  group     = ibm_is_security_group.vpc_sg_bastion.id
  direction = "outbound"
  remote    = "166.8.0.0/14"
}

