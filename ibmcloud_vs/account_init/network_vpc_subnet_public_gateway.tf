
# Create Public Gateway (PGW) for attachment to Subnet in a Zone as a source network address translation (SNAT)
#
# Auto-attachment of newly created Public Gateway (PGW) in Terraform, is handled from the Subnet resource in the public_gateway argument
#
# Allows entire Subnet (every Virtual Server) to communicate with public internet as
# a Many-to-One NAT (i.e. all IPs on Subnet use one Public IP Address),
# whereby the entire Subnet shares the same outbound Floating IP (Public IP / Public endpoint).
#
# The Public Gateway (PGW) does not enable the Internet to initiate a connection with those instances (this will still require a Jump/Bastion host)
#
# Only one Public Gateway per Zone, but Public Gateway can attach to multiple Subnets in the Zone
#
# From an individual Virtual Server, obtain the network's external IP address by running...
#  curl ipecho.net/plain ; echo

resource "ibm_is_public_gateway" "vpc_subnet_public_gateway" {

  count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : (local.target_subnet_public_gateway == "" ? 1 : 0)

  name = var.module_var_ibmcloud_vpc_subnet_create_boolean ? "${var.module_var_resource_prefix}-vpc-subnet-public-gateway" : "${var.module_var_ibmcloud_vpc_subnet_name}-public-gateway"
  vpc  = var.module_var_ibmcloud_vpc_subnet_create_boolean ? join(",", ibm_is_vpc.vpc[*].id) : join(",", local.target_vpc_id)

  zone           = var.module_var_ibmcloud_vpc_subnet_create_boolean ? var.module_var_ibmcloud_vpc_availability_zone : join(",", local.target_vpc_availability_zone)
  resource_group = var.module_var_resource_group_create_boolean ? ibm_resource_group.resource_group[0].id : data.ibm_resource_group.resource_group[0].id

}


resource "ibm_is_subnet_public_gateway_attachment" "vpc_subnet_public_gateway_attach" {

  depends_on = [ibm_is_public_gateway.vpc_subnet_public_gateway]

  count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 0 : (local.target_subnet_public_gateway == "" ? 1 : 0)

  subnet         = local.target_subnet_id
  public_gateway = ibm_is_public_gateway.vpc_subnet_public_gateway[0].id

}
