
output "output_vpc_subnet_name" {
  value = data.ibm_is_subnet.vpc_subnet.name
}

output "output_dns_services_guid" {
  value = ibm_resource_instance.dns_services_instance.guid
}

output "output_dns_services_zone_id" {
  value = ibm_dns_zone.dns_services_zone.zone_id
}

output "output_dns_services_domain_name" {
  value = ibm_dns_zone.dns_services_zone.name
}

output "output_host_dns_services_instance" {
  value = ibm_resource_instance.dns_services_instance.name
}

output "output_host_dns_root_name" {
  value = ibm_dns_zone.dns_services_zone.name
}


output "output_bastion_ssh_key_id" {
  value = ibm_is_ssh_key.bastion_ssh.id
}

output "output_bastion_public_ssh_key" {
  value = tls_private_key.bastion_ssh.public_key_openssh
}

output "output_bastion_private_ssh_key" {
  value = tls_private_key.bastion_ssh.private_key_pem
}


output "output_host_ssh_key_id" {
  value = ibm_is_ssh_key.host_ssh.id
}

output "output_host_public_ssh_key" {
  value = tls_private_key.host_ssh.public_key_openssh
}

output "output_host_private_ssh_key" {
  value = tls_private_key.host_ssh.private_key_pem
}


output "output_host_security_group_id" {
  value = ibm_is_security_group.vpc_sg.id
}
