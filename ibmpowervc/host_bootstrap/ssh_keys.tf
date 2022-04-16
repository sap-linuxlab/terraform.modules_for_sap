
# Create private SSH key for ssh connection
resource "tls_private_key" "host_ssh" {
  algorithm = "RSA"
}


# Public SSH key used to connect to the servers
resource "openstack_compute_keypair_v2" "host_ssh" {
  name       = "${var.module_var_resource_prefix}-hosts-ssh-keypair"
  public_key = tls_private_key.host_ssh.public_key_openssh
}
