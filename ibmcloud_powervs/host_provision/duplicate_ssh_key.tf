
resource "ibm_pi_key" "host_ssh" {
  provider             = ibm.powervs_secure_enclave
  pi_key_name          = "${var.module_var_resource_prefix}-host-ssh-key-for-power"
  pi_ssh_key           = var.module_var_host_public_ssh_key
  pi_cloud_instance_id = var.module_var_ibm_power_guid
}
