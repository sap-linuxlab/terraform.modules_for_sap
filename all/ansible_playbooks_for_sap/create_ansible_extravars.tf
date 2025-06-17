
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_extravars" {
  filename        = "${path.root}/tmp/ansible_extravars_generated.yml"
  file_permission = "0755"
  content         = <<EOF

#### Instructions for using existing_hosts ####

# When existing_hosts are used, execution of provisioning role sap_vm_provision will be skipped.
# This results in the need to define additional variables below, e.g. sap_general_preconfigure_domain.

# Ansible Role sap_storage_setup will be searching for block devices based on their definition in storage_definition
# under sap_vm_provision_existing_hosts_host_specifications_dictionary. These devices must not be partitioned!

####

# Existing Hosts - ensure Domain is set
sap_general_preconfigure_modify_etc_hosts: true
sap_general_preconfigure_domain: "${var.module_var_dns_root_domain}"

# Import host specification dictionary from Terraform Template
# Convert 'disk_count' key (logical name for provisioning X disks) to 'lvm_lv_stripes' expected by sap_storage_setup Ansible Role
# Remove 'disk_type' key (for provisioning disks) which is not expected by sap_storage_setup Ansible Role
# Then convert JSON payload from Terraform to Python Dictionary type using from_json built-in function
sap_vm_provision_existing_hosts_host_specifications_dictionary: "{{ '${ local.generate_host_specifications }' | from_json }}"

# Ansible Role sap_storage_setup variable assignment per host
sap_storage_setup_definition:
  "{{ sap_vm_provision_existing_hosts_host_specifications_dictionary[sap_vm_provision_host_specification_plan]
    [inventory_hostname_short].storage_definition }}"
${ strcontains(var.module_var_ansible_sap_scenario_selection, "sandbox") ? "# Ansible Role sap_storage_setup variable assignment if Sandbox. Override any System ID (SID) value stored in the host specifications dictionary" : "" }
${ strcontains(var.module_var_ansible_sap_scenario_selection, "sandbox") ? format("sap_storage_setup_sid: \"%s\"",var.module_var_ansible_sap_system_sid) : "" }

# Ansible Playbooks for SAP - multiple hosts
sap_vm_provision_ssh_host_private_key_file_path: "${abspath(path.root)}/tmp/hosts_rsa"

${ strcontains(var.module_var_ansible_sap_scenario_selection, "hana") ? "# Ansible Playbooks for SAP - SAP HANA variables when multiple hosts (HA or Scale-Out)" : "" }
${ strcontains(var.module_var_ansible_sap_scenario_selection, "hana") ? "sap_hana_install_update_firewall: true" : "" }

${ var.module_var_ibmpower_flag ? "# Ansible Playbooks for SAP - IBM Power" : "" }
${ var.module_var_ibmpower_flag ? "sap_storage_setup_multipath_enable_and_detect: true" : "" }

EOF
}
