
# List all Stock OS Images for IBM Power Virtual Server
# Equivalent to ibmcloud pi image-list-catalog --long
data "ibm_pi_catalog_images" "stock_os_images_list" {
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid
  sap                  = true
}

locals {
  target_catalog_os_image_full = [for x in data.ibm_pi_catalog_images.stock_os_images_list.images : x if x.name == var.module_var_host_os_image]
  target_catalog_os_image_id = compact(
    [
      for key, value in
      data.ibm_pi_catalog_images.stock_os_images_list.images :
      length(regexall("${var.module_var_host_os_image}", data.ibm_pi_catalog_images.stock_os_images_list.images[key].name)) > 0 ?
      data.ibm_pi_catalog_images.stock_os_images_list.images[key].image_id
      : ""
    ]
  )[0]
}
