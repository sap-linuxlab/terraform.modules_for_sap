
locals {

  generate_host_specifications_block = replace(replace(jsonencode(var.module_var_host_specifications), "/\"disk_type\":\".+?\",/" , ""),"disk_count","lvm_lv_stripes")

  generate_host_specifications_nfs_usrsap_trans = replace(local.generate_host_specifications_block, "\"nfs_path\":\"/usr/sap/trans\",\"nfs_server\":\"\"" , "\"nfs_path\":\"/usr/sap/trans\",\"nfs_server\":\"${var.module_var_nfs_fqdn_transport}\"")
  generate_host_specifications_nfs_usrsap = replace(local.generate_host_specifications_nfs_usrsap_trans, "\"nfs_path\":\"/usr/sap\",\"nfs_server\":\"\"" , "\"nfs_path\":\"/usr/sap\",\"nfs_server\":\"${var.module_var_nfs_fqdn_sapmnt}\"")
  generate_host_specifications_nfs_sapmnt = replace(local.generate_host_specifications_nfs_usrsap, "\"nfs_path\":\"/sapmnt\",\"nfs_server\":\"\"" , "\"nfs_path\":\"/sapmnt\",\"nfs_server\":\"${var.module_var_nfs_fqdn_sapmnt}\"")

  generate_host_specifications = replace(local.generate_host_specifications_nfs_sapmnt, "\"","\\\"")

}
