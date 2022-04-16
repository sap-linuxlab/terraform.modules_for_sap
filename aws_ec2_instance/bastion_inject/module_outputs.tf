
output "output_bastion_connection_security_group_id" {
  value = aws_security_group.bastion_connection_sg.id
}

output "output_bastion_security_group_id" {
  value = aws_security_group.bastion_sg.id
}

output "output_bastion_subnet_id" {
  value = aws_subnet.vpc_bastion_subnet.id
}

output "output_bastion_ip" {
  value = aws_instance.bastion_host.public_ip
}
