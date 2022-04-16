
# Find latest OS Image for RHEL
# az account list-locations | jq .[].displayName
# az vm image list --all --publisher redhat --offer RHEL-SAP-APPS --sku 8 --query "[?starts_with(version,'8.4')]" | jq .[].version --raw-output | sort -r | head -1
# az vm image list --all --publisher redhat --offer RHEL-SAP-HA --sku 8 --query "[?starts_with(version,'8.4')]" | jq .[].version --raw-output | sort -r | head -1

# Find latest OS Image for SLES
# az account list-locations | jq .[].displayName
# az vm image list --all --publisher suse --offer sles-sap-12-sp5 --sku gen2 --query "[?contains(urn,'sp5:gen2')]" | jq .[].version --raw-output | sort -r | head -1
# az vm image list --all --publisher suse --offer sles-sap-15-sp1 --sku gen2 --query "[?contains(urn,'sp1:gen2')]" | jq .[].version --raw-output | sort -r | head -1
# az vm image list --all --publisher suse --offer sles-sap-15-sp2 --sku gen2 --query "[?contains(urn,'sp2:gen2')]" | jq .[].version --raw-output | sort -r | head -1
# az vm image list --all --publisher suse --offer sles-sap-15-sp3 --sku gen2 --query "[?contains(urn,'sp3:gen2')]" | jq .[].version --raw-output | sort -r | head -1


data "azurerm_platform_image" "host_os_image" {
  location  = var.module_var_az_region
  publisher = var.module_var_host_os_image.publisher
  offer     = var.module_var_host_os_image.offer
  sku       = var.module_var_host_os_image.sku
}

#output "debug_host_os_image" {
#  value = data.azurerm_platform_image.host_os_image.id
#}
