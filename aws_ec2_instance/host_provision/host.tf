
# Create new host

resource "aws_instance" "host" {
  ami                    = data.aws_ami.host_os_image.image_id
  instance_type          = var.module_var_aws_ec2_instance_type
  key_name               = var.module_var_host_ssh_key_name
  vpc_security_group_ids = [var.module_var_host_sg_id, var.module_var_bastion_connection_sg_id]
  subnet_id              = var.module_var_aws_vpc_subnet_id
  tenancy                = "default"

  # Pass cloud-init or bash script payloads with user_data
  # Stored into /var/lib/cloud/instance/user-data.txt
  # Scripts entered as user data are executed as the root user
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html

  # Change Hostname, use EOF with prefix dash to trim the whitespace
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
  # https://stackoverflow.com/questions/603351/can-we-set-easy-to-remember-hostnames-for-ec2-instances

  #  user_data = <<-EOF
  #   #! /bin/bash
  #   sudo hostnamectl set-hostname ${var.module_var_host_name}.${var.module_var_dns_root_domain_name}
  # EOF

  root_block_device {
    delete_on_termination = "true"
    volume_size           = "100"
    volume_type           = "gp2"
    tags = {
      "Name" = "${var.module_var_host_name}-volume-root"
    }
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 8
    http_tokens                 = "required" // IMDSv2
    instance_metadata_tags      = "disabled"
  }

  source_dest_check = var.module_var_enable_ip_anti_spoofing ? false : true // To enable IP Anti Spoofing, must disable the Source/Destination Check

  tags = {
    Name = var.module_var_host_name
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}



# Attach EBS block disk volumes to host

resource "aws_volume_attachment" "volume_attachment_hana_data" {
  count       = length(aws_ebs_volume.block_volume_hana_data_voltype.*.id)
  device_name = "/dev/sd${element(["c", "d", "e", "f"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_data_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_hana_data_custom" {
  count       = length(aws_ebs_volume.block_volume_hana_data_custom.*.id)
  device_name = "/dev/sd${element(["c", "d", "e", "f"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_data_custom.*.id, count.index)
}


resource "aws_volume_attachment" "volume_attachment_hana_log" {
  count       = length(aws_ebs_volume.block_volume_hana_log_voltype.*.id)
  device_name = "/dev/sd${element(["g", "h", "i", "j"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_log_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_hana_log_custom" {
  count       = length(aws_ebs_volume.block_volume_hana_log_custom.*.id)
  device_name = "/dev/sd${element(["g", "h", "i", "j"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_log_custom.*.id, count.index)
}


resource "aws_volume_attachment" "volume_attachment_hana_shared" {
  count       = length(aws_ebs_volume.block_volume_hana_shared_voltype.*.id)
  device_name = "/dev/sd${element(["k", "l", "m", "n"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_shared_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_hana_shared_custom" {
  count       = length(aws_ebs_volume.block_volume_hana_shared_custom.*.id)
  device_name = "/dev/sd${element(["k", "l", "m", "n"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_hana_shared_custom.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_usr_sap" {
  count       = length(aws_ebs_volume.block_volume_usr_sap_voltype.*.id)
  device_name = "/dev/sd${element(["o", "p", "q", "r"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_usr_sap_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_sapmnt" {
  count       = length(aws_ebs_volume.block_volume_sapmnt_voltype.*.id)
  device_name = "/dev/sd${element(["s", "t", "u", "v"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_sapmnt_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_swap" {
  count       = length(aws_ebs_volume.block_volume_swap_voltype.*.id)
  device_name = "/dev/sd${element(["w", "x", "y", "z"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_swap_voltype.*.id, count.index)
}

# AWS EBS does not accept /dev/sdaa. Only 1 software drive is expected therefore put to front of Linux device naming i.e. /dev/sdb
resource "aws_volume_attachment" "volume_attachment_software" {
  count       = length(aws_ebs_volume.block_volume_software_voltype.*.id)
  device_name = "/dev/sdb"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_software_voltype.*.id, count.index)
}


resource "aws_volume_attachment" "volume_attachment_anydb" {
  count       = length(aws_ebs_volume.block_volume_anydb_voltype.*.id)
  device_name = "/dev/sd${element(["aa", "ab", "ac", "ad"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_anydb_voltype.*.id, count.index)
}

resource "aws_volume_attachment" "volume_attachment_anydb_custom" {
  count       = length(aws_ebs_volume.block_volume_anydb_custom.*.id)
  device_name = "/dev/sd${element(["aa", "ab", "ac", "ad"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_anydb_custom.*.id, count.index)
}
