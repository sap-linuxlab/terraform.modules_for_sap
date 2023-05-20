
# Create Block Storage

resource "aws_ebs_volume" "block_volume_provision" {
#  count = sum([ for storage_item in var.module_var_storage_definition: try(storage_item.disk_count,1) ])

  for_each = {
    for disk in flatten(
      [ for storage_item in var.module_var_storage_definition:
        [ for index, count in range(0,try(storage_item.disk_count,1)) :
          tomap({"name" = replace("${storage_item.name}-${index}","_","-"), "disk_type" = try(storage_item.disk_type, null), "disk_size" = storage_item.disk_size, "disk_iops" = try(storage_item.disk_iops,null)})
        ]
      ]
    ):
    disk.name => disk
  }

  availability_zone = local.target_vpc_availability_zone
  type              = each.value.disk_type
  size              = each.value.disk_size
  iops              = each.value.disk_iops

  tags = {
    Name = "${var.module_var_host_name}-vol-${each.value.name}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}
