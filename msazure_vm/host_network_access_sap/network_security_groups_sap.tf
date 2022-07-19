
# SAP NetWeaver PAS / SAP GUI, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_sapgui" {
  name      = "tcp_inbound_sapnwas_sapgui"
  priority  = 201
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP NetWeaver PAS Gateway, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_gw" {
  name      = "tcp_inbound_sapnwas_gw"
  priority  = 202
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_icm_https" {
  name      = "tcp_inbound_saphana_icm_https"
  priority  = 203
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

# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_icm_http" {
  name      = "tcp_inbound_saphana_icm_http"
  priority  = 204
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

# SAP NetWeaver AS JAVA Message Server, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_sapnwas_java_ms" {
  name      = "tcp_inbound_sapnwas_java_ms"
  priority  = 205
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP HANA Internal Web Dispatcher, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_webdisp" {
  name      = "tcp_inbound_saphana_webdisp"
  priority  = 206
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

# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_index_mdc_sysdb" {
  name      = "tcp_inbound_saphana_index_mdc_sysdb"
  priority  = 207
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

# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_index_mdc_1" {
  name      = "tcp_inbound_saphana_index_mdc_1"
  priority  = 208
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


# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapfiori" {
  name      = "tcp_inbound_sapfiori"
  priority  = 209
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("443${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_ctrl" {
  name      = "tcp_inbound_sapnwas_ctrl"
  priority  = 210
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_nwas_pas_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_hsr1" {
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
  name      = "tcp_inbound_saphana_hsr2"
  priority  = 303
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("4${var.module_var_sap_nwas_pas_instance_no}40")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_saphana_hsr2" {
  name      = "tcp_outbound_saphana_hsr2"
  priority  = 304
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("4${var.module_var_sap_nwas_pas_instance_no}40")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_saphana_pacemaker1" {
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
