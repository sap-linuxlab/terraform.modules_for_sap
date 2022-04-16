
variable "module_var_bastion_boolean" {
}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_host_private_ip" {}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}


variable "module_var_web_proxy_url" {}

variable "module_var_web_proxy_exclusion" {}
