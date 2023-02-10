
resource "aws_efs_file_system" "file_storage_sapmnt" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0
  creation_token = "${var.module_var_resource_prefix}-nfs-sapmnt"

  tags = {
    Name = "${var.module_var_resource_prefix}-nfs-sapmnt"
  }

  availability_zone_name = local.target_vpc_availability_zone # One Zone storage class
  encrypted = true
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

#  lifecycle_policy {
#    transition_to_ia = "AFTER_90_DAYS"
#  }

}

resource "aws_efs_mount_target" "file_storage_attach_sapmnt" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0

  file_system_id  = aws_efs_file_system.file_storage_sapmnt[0].id
  subnet_id       = var.module_var_aws_vpc_subnet_id
  security_groups = [var.module_var_host_sg_id]
}

resource "aws_efs_access_point" "file_storage_shared_mount_point" {
  file_system_id = aws_efs_file_system.file_storage_sapmnt[0].id

  root_directory {
    path = "/"
  }

}
