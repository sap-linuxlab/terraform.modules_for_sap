
data "ibm_resource_instance" "dns_services_instance" {
  name              = var.module_var_dns_services_instance
  resource_group_id = var.module_var_resource_group_id
}

data "ibm_dns_zones" "dns_private_zone" {
  instance_id = data.ibm_resource_instance.dns_services_instance.guid
}

locals {

  target_dns_zone_id = join("",
    compact([
      for key, value in data.ibm_dns_zones.dns_private_zone.dns_zones :
      data.ibm_dns_zones.dns_private_zone.dns_zones[key].name == var.module_var_dns_root_domain_name
      ? data.ibm_dns_zones.dns_private_zone.dns_zones[key].zone_id
      : ""
      ]
    )
  )

}

data "ibm_pi_network" "vlan_network" {
  pi_network_name      = var.module_var_power_group_networks[0]
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid
}
