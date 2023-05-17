
# Create Block Storage

resource "aws_ebs_volume" "block_volume_provision" {
  count = length(var.module_var_storage_definition)

  availability_zone = local.target_vpc_availability_zone
  type              = try(var.module_var_storage_definition[count.index]["disk_type"], "gp3")
  size              = var.module_var_storage_definition[count.index]["disk_size"]
  iops              = try(var.module_var_storage_definition[count.index]["disk_iops"], null)

  tags = {
    Name = "${var.module_var_host_name}-vol-${var.module_var_storage_definition[count.index].name}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}
