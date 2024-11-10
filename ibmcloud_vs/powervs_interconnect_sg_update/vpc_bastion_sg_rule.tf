
# Security Group Rule for Bastion/Jump Host - Allow Outbound SSH Port 22 connection from remote (i.e. Public Internet) to Virtual Server
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_outbound_ssh_to_virtualserver" {
  group     = var.module_var_bastion_security_group_id
  direction = "outbound"
  remote    = var.module_var_power_network_private_subnet

  tcp {
    port_min = 22
    port_max = 22
  }
}
