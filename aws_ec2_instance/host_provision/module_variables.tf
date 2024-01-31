
variable "module_var_aws_ec2_instance_type" {}

variable "module_var_host_os_image" {}
variable "module_var_host_name" {}
variable "module_var_host_ssh_key_name" {}
variable "module_var_host_ssh_public_key" {}
variable "module_var_host_ssh_private_key" {}
variable "module_var_host_sg_id" {}
variable "module_var_aws_vpc_subnet_id" {}

variable "module_var_bastion_connection_sg_id" {}
variable "module_var_bastion_ip" {}
variable "module_var_bastion_user" {}
variable "module_var_bastion_ssh_port" {}
variable "module_var_bastion_private_ssh_key" {}


variable "module_var_dns_zone_id" {}
variable "module_var_dns_root_domain_name" {}

variable "module_var_dns_nameserver_list" {}

variable "module_var_disable_ip_anti_spoofing" {
  default = false
}

variable "module_var_storage_definition" {}
