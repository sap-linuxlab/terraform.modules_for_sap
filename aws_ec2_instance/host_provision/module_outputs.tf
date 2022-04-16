
output "output_host_private_ip" {
  value = aws_instance.host.private_ip
}

output "output_host_name" {
  value = var.module_var_host_name
}
