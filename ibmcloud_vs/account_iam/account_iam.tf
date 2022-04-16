# Create an IAM Access Group
# Which will contain the IAM Access Policies (which contain an Access Role for the service access and platform access)

resource "ibm_iam_access_group" "sap_host_access_group" {
  name        = "${var.module_var_resource_prefix}-host-iam-access-group"
  description = "Personnel who can provision resources into the Resource Group"
}

# IAM Access Policy assigned to IAM Access Group
# For the specified Resource Group, provide access to the Resource Group with Role as Editor
# Access to a Resource Group provides users the ability to view, edit, or manage access for the group; but does not provide access to the resources within the resource group
resource "ibm_iam_access_group_policy" "sap_host_resource_group_access_policy" {
  access_group_id = ibm_iam_access_group.sap_host_access_group.id
  roles           = ["Editor"]

  resources {
    resource          = var.module_var_resource_group_id
    resource_type     = "resource-group"
    resource_group_id = var.module_var_resource_group_id
  }

}
