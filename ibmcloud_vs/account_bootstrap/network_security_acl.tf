
# Create ACL for VPC Subnet/s
# (available to use by all Subnets in all Zones)
# Name of Network ACL must be unique within the Account
#
# For subnet-level protection, the access control lists (ACLs) limit a subnet’s inbound and outbound traffic

resource "ibm_is_network_acl" "vpc_subnet_acl" {
  name           = "${var.module_var_resource_prefix}-vpc-subnet-acl"
  vpc            = local.target_vpc_id
  resource_group = var.module_var_resource_group_id

  # Allow ping outbound only
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  rules {
    name        = "icmp-outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    icmp {
      #type = 1
      #code = 1
    }
  }
  rules {
    name        = "tcp-outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    tcp {
      #source_port_min = 1
      #source_port_max = 1
      #port_min = 1
      #port_max = 1
    }
  }
  rules {
    name        = "tcp-inbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
    tcp {
      #source_port_min = 1
      #source_port_max = 1
      #port_min = 1
      #port_max = 1
    }
  }
  rules {
    name        = "udp-outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    udp {
      #source_port_min = 1
      #source_port_max = 1
      #port_min = 1
      #port_max = 1
    }
  }
  rules {
    name        = "udp-inbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
    udp {
      #source_port_min = 1
      #source_port_max = 1
      #port_min = 1
      #port_max = 1
    }
  }
}

