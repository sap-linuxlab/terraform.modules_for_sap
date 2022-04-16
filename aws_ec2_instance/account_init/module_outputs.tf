
output "output_aws_vpc_id" {
  value = var.module_var_aws_vpc_subnet_create_boolean ? aws_vpc.vpc[0].id : local.target_vpc_id
}

output "output_aws_vpc_subnet_id" {
  value = var.module_var_aws_vpc_subnet_create_boolean ? aws_subnet.vpc_subnet_private[0].id : var.module_var_aws_vpc_subnet_id
}

output "output_aws_vpc_igw_id" {
  value = var.module_var_aws_vpc_subnet_create_boolean ? aws_internet_gateway.vpc_igw.id : local.target_vpc_igw
}
