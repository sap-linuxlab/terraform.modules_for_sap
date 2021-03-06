
# SAP NetWeaver PAS / SAP GUI, and RFC connections
### ABAP dispatcher using 32<NN>
### ABAP gateway using 33<NN>
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_sapnwas_sapgui" {
  group     = var.module_var_bastion_connection_security_group_id
  direction = "inbound"
  remote    = var.module_var_bastion_security_group_id
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  }
}


# SAP HANA indexserver MDC System Database (SYSTEMDB) using 3<NN>13
# SAP HANA indexserver MDC Tenant #0 SYSTEMDB using 3<NN>15
# SAP HANA indexserver MDC Tenant #1--n using 3<NN>41
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana" {
  group      = var.module_var_bastion_connection_security_group_id
  direction  = "inbound"
  remote     = var.module_var_bastion_security_group_id
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}41")
  }
}


# SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) Instance Number 01
# SAP Web GUI and SAP Fiori Launchpad (HTTPS)
### ABAP ICM HTTPS using 443<NN>, default 00
### Web Dispatcher HTTPS for NWAS PAS using 443<NN>, default 01
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_sapfiori" {
  group      = var.module_var_bastion_connection_security_group_id
  direction  = "inbound"
  remote     = var.module_var_bastion_security_group_id
  tcp {
    port_min = tonumber(var.module_var_sap_hana_instance_no) < tonumber(var.module_var_sap_nwas_pas_instance_no) ? tonumber("443${var.module_var_sap_hana_instance_no}") : tonumber("443${var.module_var_sap_nwas_pas_instance_no}")
    port_max = tonumber(var.module_var_sap_hana_instance_no) > tonumber(var.module_var_sap_nwas_pas_instance_no) ? tonumber("443${var.module_var_sap_hana_instance_no}") : tonumber("443${var.module_var_sap_nwas_pas_instance_no}")
  }
}


# SAP NetWeaver sapctrl HTTP/HTTPS from SAP HANA
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_sapctrl" {
  group      = var.module_var_bastion_connection_security_group_id
  direction  = "inbound"
  remote     = var.module_var_bastion_security_group_id
  tcp {
    port_min = tonumber("5${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_hana_instance_no}14")
  }
}
