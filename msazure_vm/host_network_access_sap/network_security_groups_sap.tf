
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


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA indexserver MDC configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## In addition, there is another port offset +1 reserved for both systems to use during system replication communication.
## Source: SAP HANA Administration Guide, SAP HANA System Replication with Multi-Tenant Databases (MDC) -- https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/d20e1a973df9462fa92149f29ee2c455.html?version=latest
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana_replication" {
  name      = "tcp_inbound_saphana_replication"
  priority  = 301
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges     = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}02"]
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphana_replication" {
  name      = "tcp_outbound_saphana_replication"
  priority  = 302
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_ranges     = ["4${var.module_var_sap_hana_instance_no}01-4${var.module_var_sap_hana_instance_no}02"]
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
