# Create security group for instances inside VPC
# (available to use by all Subnets in all Zones)
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
#
# Create Security Group with standalone declarations of Security Group Rules.
# Alternative is to use in-line rules nested in ibm_is_vpc or ibm_is_security_group Terraform Resources. Use of both will cause conflict of rule settings.
# Uses depends_on to provide an order to the rules

resource "ibm_is_security_group" "vpc_sg" {
  name           = "${var.module_var_resource_prefix}-vpc-sg"
  vpc            = local.target_vpc_id
  resource_group = var.module_var_resource_group_id
}

# Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers; avoids SSH lag
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_dns_tcp" {
  group     = ibm_is_security_group.vpc_sg.id
  direction = "outbound"
  remote    = "161.26.0.0/28"

  tcp {
    port_min = 53
    port_max = 53
  }
}

# Allow Outbound DNS Port 53 connection to IBM Cloud VPC DNS resolvers; avoids SSH lag
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_dns_udp" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_outbound_dns_tcp]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "161.26.0.0/28"

  udp {
    port_min = 53
    port_max = 53
  }
}

# Loopback traffic on any protocol or port
#resource "ibm_is_security_group_rule" "vpc_sg_rule_loopback_inbound_all" {
#  group     = ibm_is_security_group.vpc_sg.id
#  direction = "inbound"
#  remote    = "127.0.0.1"
#}

# Allow Outbound HTTP Port 80 connection to any (e.g. via Public Gateway)
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_http_80" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_outbound_dns_udp]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"

  tcp {
    port_min = 80
    port_max = 80
  }
}

# Allow Outbound HTTPS Port 443 connection to any (e.g. via Public Gateway)
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_https_443" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_outbound_http_80]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"

  tcp {
    port_min = 443
    port_max = 443
  }
}

# TCP Outbound from Private, equivilant to allow_all outbound basic rule (e.g. via Public Gateway)
#resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_all" {
#  group     = ibm_is_security_group.vpc_sg.id
#  direction = "outbound"
#  remote = "0.0.0.0/0"
#  tcp {
#    port_min = 1
#    port_max = 65535
#  }
#}

# UDP Outbound from private VPC Subnet, equivilant to allow_all outbound basic rule (e.g. via Public Gateway)
#resource "ibm_is_security_group_rule" "vpc_sg_rule_udp_outbound_all" {
#  group     = ibm_is_security_group.vpc_sg.id
#  direction = "outbound"
#  remote = "0.0.0.0/0"
#  udp {
#    port_min = 1
#    port_max = 65535
#  }
#}


# Allow ping inbound from other Virtual Servers within the same Subnet
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "ibm_is_security_group_rule" "vpc_sg_rule_icmp_inbound" {
  group     = ibm_is_security_group.vpc_sg.id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  icmp {
    #code = 20
    #type = 30
  }
}

# Allow ping outbound from Virtual Servers to any network, only for Subnet containing Virtual Servers (i.e. not for Bastion Subnet)
# Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
resource "ibm_is_security_group_rule" "vpc_sg_rule_icmp_outbound" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_icmp_inbound]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
  icmp {
    #code = 20
    #type = 30
  }
}

# SSH Inbound from hosts within private VPC Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_ssh_private" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_icmp_outbound]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 22
    port_max = 22
  }
}

# SSH Outbound from hosts within private VPC Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_ssh_private" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_icmp_outbound]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 22
    port_max = 22
  }
}

# Allow Inbound/Outbound any protocol or port to Classic IaaS Endpoints range using adn.networklayer.com domain
# Required for access to OS Packages, e.g. Red Hat Satellite
resource "ibm_is_security_group_rule" "vpc_sg_rule_inbound_ibmcloud_classic_iaas" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_ssh_private]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "inbound"
  remote     = "161.26.0.0/16"
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_ibmcloud_classic_iaas" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_inbound_ibmcloud_classic_iaas]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "161.26.0.0/16"
}

# Allow any protocol or port to Cloud Service Endpoints (CSE) range using serviceendpoint.cloud.ibm.com domain
resource "ibm_is_security_group_rule" "vpc_sg_rule_inbound_ibmcloud_cse" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_outbound_ibmcloud_classic_iaas]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "inbound"
  remote     = "166.8.0.0/14"
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_ibmcloud_cse" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_inbound_ibmcloud_cse]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "166.8.0.0/14"
}

# Allow any protocol or port to Additional Cloud Services (e.g. update services used with IBM Cloud for VMware Solutions)
resource "ibm_is_security_group_rule" "vpc_sg_rule_inbound_ibmcloud_additional_services" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_outbound_ibmcloud_cse]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "inbound"
  remote     = "52.117.132.0/24"
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_outbound_ibmcloud_additional_services" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_inbound_ibmcloud_additional_services]
  group      = ibm_is_security_group.vpc_sg.id
  direction  = "outbound"
  remote     = "52.117.132.0/24"
}

