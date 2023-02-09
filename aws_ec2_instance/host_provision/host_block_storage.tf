
# Create Block Storage

resource "aws_ebs_volume" "block_volume_hana_data_voltype" {
  count = var.module_var_disk_volume_type_hana_data != "custom" ? var.module_var_disk_volume_count_hana_data : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_data
  size              = var.module_var_disk_volume_capacity_hana_data

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-data-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_hana_data_custom" {
  count = var.module_var_disk_volume_type_hana_data == "custom" ? var.module_var_disk_volume_count_hana_data : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_data
  size              = var.module_var_disk_volume_capacity_hana_data
  iops              = var.module_var_disk_volume_iops_hana_data

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-data-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}



resource "aws_ebs_volume" "block_volume_hana_log_voltype" {
  count = var.module_var_disk_volume_type_hana_log != "custom" ? var.module_var_disk_volume_count_hana_log : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_log
  size              = var.module_var_disk_volume_capacity_hana_log

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-log-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_hana_log_custom" {
  count = var.module_var_disk_volume_type_hana_log == "custom" ? var.module_var_disk_volume_count_hana_log : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_log
  size              = var.module_var_disk_volume_capacity_hana_log
  iops              = var.module_var_disk_volume_iops_hana_log

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-log-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}



resource "aws_ebs_volume" "block_volume_hana_shared_voltype" {
  count = var.module_var_disk_volume_type_hana_shared != "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_shared
  size              = var.module_var_disk_volume_capacity_hana_shared

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-shared-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_hana_shared_custom" {
  count = var.module_var_disk_volume_type_hana_shared == "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_hana_shared
  size              = var.module_var_disk_volume_capacity_hana_shared
  iops              = var.module_var_disk_volume_iops_hana_shared

  tags = {
    Name = "${var.module_var_host_name}-volume-hana-shared-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}



resource "aws_ebs_volume" "block_volume_anydb_voltype" {
  count = var.module_var_disk_volume_type_anydb != "custom" ? var.module_var_disk_volume_count_anydb : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_anydb
  size              = var.module_var_disk_volume_capacity_anydb

  tags = {
    Name = "${var.module_var_host_name}-volume-anydb-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_anydb_custom" {
  count = var.module_var_disk_volume_type_anydb == "custom" ? var.module_var_disk_volume_count_anydb : 0

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_anydb
  size              = var.module_var_disk_volume_capacity_anydb
  iops              = var.module_var_disk_volume_iops_anydb

  tags = {
    Name = "${var.module_var_host_name}-volume-anydb-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}



resource "aws_ebs_volume" "block_volume_usr_sap_voltype" {
  count = var.module_var_disk_volume_count_usr_sap

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_usr_sap
  size              = var.module_var_disk_volume_capacity_usr_sap

  tags = {
    Name = "${var.module_var_host_name}-volume-usr-sap-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_sapmnt_voltype" {
  count = var.module_var_nfs_boolean_sapmnt ? 0 : var.module_var_disk_volume_count_sapmnt

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_sapmnt
  size              = var.module_var_disk_volume_capacity_sapmnt

  tags = {
    Name = "${var.module_var_host_name}-volume-sapmnt-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_swap_voltype" {
  count = var.module_var_disk_volume_count_swap

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_swap
  size              = var.module_var_disk_volume_capacity_swap

  tags = {
    Name = "${var.module_var_host_name}-volume-swap-${count.index}"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_ebs_volume" "block_volume_software_voltype" {

  availability_zone = local.target_vpc_availability_zone
  type              = var.module_var_disk_volume_type_software
  size              = var.module_var_disk_volume_capacity_software

  tags = {
    Name = "${var.module_var_host_name}-volume-software"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
