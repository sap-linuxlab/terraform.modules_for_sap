
output "output_dns_zone_id" {
  value = aws_route53_zone.dns_services_zone.id
}

output "output_dns_domain_name" {
  value = aws_route53_zone.dns_services_zone.name
}

output "output_dns_nameserver_list" {
  value = aws_route53_zone.dns_services_zone.name_servers
}

output "output_bastion_ssh_key_name" {
  value = aws_key_pair.bastion_ssh.key_name
}

output "output_bastion_ssh_key_id" {
  value = aws_key_pair.bastion_ssh.id
}

output "output_bastion_public_ssh_key" {
  value = tls_private_key.bastion_ssh.public_key_openssh
}

output "output_bastion_private_ssh_key" {
  value = tls_private_key.bastion_ssh.private_key_pem
}


output "output_host_ssh_key_name" {
  value = aws_key_pair.host_ssh.key_name
}

output "output_host_ssh_key_id" {
  value = aws_key_pair.host_ssh.id
}

output "output_host_public_ssh_key" {
  value = tls_private_key.host_ssh.public_key_openssh
}

output "output_host_private_ssh_key" {
  value = tls_private_key.host_ssh.private_key_pem
}


output "output_host_security_group_id" {
  value = aws_security_group.vpc_sg.id
}
