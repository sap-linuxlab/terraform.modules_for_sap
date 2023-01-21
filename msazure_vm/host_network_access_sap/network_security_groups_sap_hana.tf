
# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_icm_https"
  priority  = 250
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("43${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_icm_https"
  priority  = 251
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("43${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_icm_http"
  priority  = 252
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("80${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_icm_http"
  priority  = 253
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("80${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA Internal Web Dispatcher, webdispatcher process, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_webdisp"
  priority  = 254
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}06")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_webdisp"
  priority  = 255
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}06")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_index_mdc_sysdb"
  priority  = 256
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_index_mdc_sysdb"
  priority  = 257
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_index_mdc_1"
  priority  = 258
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}15")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_index_mdc_1"
  priority  = 259
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("3${var.module_var_sap_hana_instance_no}15")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA for SOAP over HTTP for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_startsrv_http_soap"
  priority  = 260
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_hana_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_startsrv_http_soap"
  priority  = 261
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_hana_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA for SOAP over HTTPS (Secure) for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_startsrv_https_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_startsrv_https_soap"
  priority  = 262
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_hana_instance_no}14")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_startsrv_https_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_startsrv_https_soap"
  priority  = 263
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_hana_instance_no}14")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}



# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_hsr1"
  priority  = 301
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges    = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}07"]
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_hsr1"
  priority  = 302
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges    = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}07"]
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_hsr2"
  priority  = 303
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("4${var.module_var_sap_nwas_abap_pas_instance_no}40")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_hsr2"
  priority  = 304
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("4${var.module_var_sap_nwas_abap_pas_instance_no}40")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_saphana_pacemaker1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_pacemaker1"
  priority  = 305
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 2224
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_saphana_pacemaker1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_pacemaker1"
  priority  = 306
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 2224
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_saphana_pacemaker2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_pacemaker2"
  priority  = 307
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 3121
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_saphana_pacemaker2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_pacemaker2"
  priority  = 308
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 3121
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_udp_inbound_pacemaker3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana_pacemaker3"
  priority  = 309
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Udp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges    = ["5404-5412"]
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_udp_outbound_pacemaker3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_outbound_saphana_pacemaker3"
  priority  = 310
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Udp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges    = ["5404-5412"]
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
