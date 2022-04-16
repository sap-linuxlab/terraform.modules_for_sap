# Create security group for public access to instances inside VPC
# (available to use by all Subnets in all Zones)
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
#
# Create Security Group with standalone declarations of Security Group Rules.
# Alternative is to use in-line rules nested in ibm_is_vpc or ibm_is_security_group Terraform Resources. Use of both will cause conflict of rule settings.
# Uses depends_on to provide an order to the rules
#
#
# Isolated security group and rules for SAP Fiori Launchpad and SAP Web GUI
#
# Remote is set to a Floating IP assigned to the Virtual Server.
# Any SAP Fiori Launchpad and SAP Web GUI traffic from an internet source
# (e.g. end user) to the Virtual Server's Floating IP will be permitted

#resource "ibm_is_security_group" "vpc_sg_sap_public" {
#  name = "${var.module_var_resource_prefix}-vpc-sg-sap-public"
#  vpc  = local.target_vpc_id
#  resource_group = var.module_var_resource_group_id
#}

# SAP GUI
#resource "ibm_is_security_group_rule" "vpc_sg_rule_sapgui" {
#  group     = ibm_is_security_group.vpc_sg_sap_public.id
#  direction = "inbound"
#  remote    = local.target_vpc_subnet_range
#  tcp {
#    port_min = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
#    port_max = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
#  }
#}

# SAP Web GUI and SAP Fiori Launchpad (HTTPS)
#resource "ibm_is_security_group_rule" "vpc_sg_rule_sapfiori" {
#  group     = ibm_is_security_group.vpc_sg_sap_public.id
#  direction = "inbound"
#  remote    = local.target_vpc_subnet_range
#  tcp {
#    port_min = tonumber("443${var.module_var_sap_nwas_pas_instance_no}")
#    port_max = tonumber("443${var.module_var_sap_nwas_pas_instance_no}")
#  }
#}
