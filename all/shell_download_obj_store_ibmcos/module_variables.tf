
variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_host_private_ip" {}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_ssh_key_id" {}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}

variable "module_var_ibmcloud_api_key" {}

variable "module_var_ibmcos_bucket" {
  description = "IBM Cloud Object Storage bucket name, optional prefix (e.g. bucketname/prefix)"
}

variable "module_var_ibmcos_download_directory" {
  description = "Directory to download files from bucket (no trailing forward slash)"
}
