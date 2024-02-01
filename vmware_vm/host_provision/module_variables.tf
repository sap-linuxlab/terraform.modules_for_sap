
variable "module_var_resource_prefix" {}

variable "module_var_vmware_vcenter_user" {}

variable "module_var_vmware_vcenter_user_password" {}

variable "module_var_vmware_vcenter_server" {}

variable "module_var_vmware_vsphere_datacenter_name" {
  description = "Target vSphere Datacenter name"
}

variable "module_var_vmware_vsphere_datacenter_compute_cluster_name" {
  description = "Target vSphere Datacenter Compute Cluster name, to host the VMware Virtual Machine"
}

variable "module_var_vmware_vsphere_datacenter_compute_cluster_host_fqdn" {
  description = "Target vSphere Datacenter Compute specificed vSphere Host FQDN, to host the VMware Virtual Machine"
}

variable "module_var_vmware_vsphere_datacenter_compute_cluster_folder_name" {
  description = "Target vSphere Datacenter Compute Cluster Folder name, the logical directory for the VMware Virtual Machine"
}

variable "module_var_vmware_vsphere_datacenter_storage_datastore_name" {}

variable "module_var_vmware_vsphere_datacenter_network_primary_name" {}


variable "module_var_vmware_vm_template_name" {
  description = "VMware VM Template name to use for provisioning"
}

variable "module_var_vmware_vm_compute_cpu_threads" {}

variable "module_var_vmware_vm_compute_ram_gb" {}

variable "module_var_vmware_vm_hostname" {
  description = "Hostname of Virtual Machine"
  validation {
    condition     = length(var.module_var_vmware_vm_hostname) <= 13
    error_message = "Hostname must be equal to or lower than 13 characters in length."
  }
}

variable "module_var_vmware_vm_dns_root_domain_name" {
  description = "Domain Name of virtual machine"
}


variable "module_var_host_public_ssh_key" {}

variable "module_var_host_private_ssh_key" {}


variable "module_var_web_proxy_enable" {
  default = true
}

variable "module_var_web_proxy_url" {}
variable "module_var_web_proxy_exclusion" {}

variable "module_var_os_vendor_enable" {
  default = true
}

variable "module_var_os_vendor_account_user" {}
variable "module_var_os_vendor_account_user_passcode" {}
variable "module_var_os_systems_mgmt_host" {
  default = ""
}


variable "module_var_storage_definition" {}
