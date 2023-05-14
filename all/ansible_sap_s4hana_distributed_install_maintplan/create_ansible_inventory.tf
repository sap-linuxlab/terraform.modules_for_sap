
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/tmp/s4hana_distributed/ansible_inventory.ini"
  file_permission = "0755"
  content         = <<EOF
[hana_primary]
${var.module_var_inventory_hana_primary}

[nwas_ascs]
${var.module_var_inventory_nwas_ascs}

[nwas_pas]
${var.module_var_inventory_nwas_pas}

[nwas_aas]
${var.module_var_inventory_nwas_aas}

EOF
}
