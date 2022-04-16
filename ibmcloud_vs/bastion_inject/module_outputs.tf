
output "output_bastion_ip" {
  value = ibm_is_floating_ip.bastion_floating_ip.address
}

output "output_bastion_security_group_id" {
  value = ibm_is_security_group.vpc_sg_bastion.id
}

output "output_bastion_connection_security_group_id" {
  value = ibm_is_security_group.vpc_sg_virtualserver_bastion_proxy_connection.id
}
