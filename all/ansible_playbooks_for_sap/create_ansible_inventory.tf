
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/tmp/ansible_inventory.ini"
  file_permission = "0755"
  content         = <<EOF
# Ansible Inventory Group names must match Ansible Playbooks for SAP - hana_primary, hana_secondary, anydb_primary, anydb_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas

[hana_primary]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "hana_primary"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[hana_secondary]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "hana_secondary"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[nwas_ascs]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "nwas_ascs"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[nwas_ers]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "nwas_ers"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[nwas_pas]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "nwas_pas"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[nwas_aas]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "nwas_aas"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[anydb_primary]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "anydb_primary"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

[anydb_secondary]
${ join(", ", [ for k1 in [for k2,v2 in var.module_var_host_specifications[var.module_var_host_specification_plan] : k2 if v2.sap_host_type == "anydb_secondary"] : format("%s ansible_host=%s ansible_connection=ssh ansible_user=root",k1,var.module_var_host_provision_outputs[k1].output_host_private_ip) ]  ) }

EOF
}
