
# SSH Key approaches:
# 1. Metadata enabled on the VM Instance, the SSH Key is stored in the GCP VM Instance Metadata.
# 2. Metadata enabled for the GCP Project, the SSH Key is stored in the GCP Project Metadata under key 'ssh-keys', and the SSH Key will be propagated to every Compute Instance within the GCP Project.
# 3. OS Login enabled for the GCP Project, the SSH Key is stored in the GCP Project and enabled for the VM Instance. Does not maintain authorized_keys on OS.

# Require disable of GCP Project OS Login, otherwise any provisioned host will not have authorized_keys maintained and therefore SSH login by Terraform and Ansible are not possible
# Instead of GCP Project OS Login:
# - use GCP Project Metadata to create SSH Public Key for all hosts
# - use GCP VM Instance Metadata to create SSH Public Key for specific hosts

# Use GCP VM Instance Metadata provisioned by Terraform with an SSH Key specified because these SSH Key approaches, it is not possible to create/store a key pair within GCP and:
# - assign thereafter to provisioned GCP VMs
# - assign to GCP VMs with a specificed tag


# Create private SSH key only for Bastion/Jump Host usage
resource "tls_private_key" "bastion_ssh" {
  algorithm = "RSA"
}

# Create private SSH key for ssh connection of the host
resource "tls_private_key" "host_ssh" {
  algorithm = "RSA"
}



### 1. GCP VM Instance Metadata approach for SSH Keys

# This is set within each 'google_compute_instance' Terraform Resource



### 2. GCP Project Metadata approach for SSH Keys

# Google Cloud Platform Project Metadata item to enable GCP OS Login
#resource "google_compute_project_metadata_item" "enable_ssh" {
#  key   = "enable-oslogin"
#  value = "TRUE"
#}

# Google Cloud Platform Project Metadata item for SSH Keys
# Any Project Metadata (i.e. SSH Keys) will be propagated to every Compute Instance within the GCP Project
# Warning from Google Cloud: This resource configuration is prone to causing frequent diffs as Google adds SSH Keys when the SSH Button is pressed in the console. It is better to use GCP OS Login instead
#resource "google_compute_project_metadata_item" "host_ssh" {
#  key   = "ssh-keys"
#  value = trimspace(tls_private_key.host_ssh.public_key_openssh)
#}



### 3. GCP Project OS Login approach for SSH Keys

#data "google_client_openid_userinfo" "me" {
#}

# Public SSH key used to connect to the servers
### use trimspace function to avoid error "<<-EOT # forces replacement", which populates with the same value each time. Alternative: lifecycle {ignore_changes = ["public_key"]}
#resource "google_os_login_ssh_public_key" "bastion_ssh" {
#  user    = data.google_client_openid_userinfo.me.email // End user specified, must match the user in use by Terraform (e.g. Service User)
#  key     = "${trimspace(tls_private_key.bastion_ssh.public_key_openssh)}"
#  project = local.target_project_id // Project ID must be specified, even though the argument is marked Optional
#}

# Public SSH key used to connect to the servers
### use trimspace function to avoid error "<<-EOT # forces replacement", which populates with the same value each time. Alternative: lifecycle {ignore_changes = ["public_key"]}
#resource "google_os_login_ssh_public_key" "host_ssh" {
#  user = data.google_client_openid_userinfo.me.email // End user specified, must match the user in use by Terraform (e.g. Service User)
#  key  = "admin:${trimspace(tls_private_key.host_ssh.public_key_openssh)}"
#  project = local.target_project_id // Project ID must be specified, even though the argument is marked Optional
#}



##############################################################
# DEBUG Bastion - Display key values, shown after successful execution
##############################################################

#output "bastion_display_private_key" {
#  value = "\n${tls_private_key.bastion_ssh.private_key_pem}"
#}

#output "bastion_display_public_key" {
#  value = "public_key_openssh is:\n ${tls_private_key.bastion_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG Bastion - Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "bastion_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.public_key_openssh}'"
#  }
#}


##############################################################
# DEBUG Display key values, shown after successful execution
##############################################################

#output "host_display_private_key" {
#  value = "\n${tls_private_key.host_ssh.private_key_pem}"
#}

#output "host_display_public_key" {
#  value = "public_key_openssh:\n ${tls_private_key.host_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "host_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.host_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.host_ssh.public_key_openssh}'"
#  }
#}
