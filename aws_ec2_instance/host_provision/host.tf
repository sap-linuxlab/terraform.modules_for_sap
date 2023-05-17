
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

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 8
    http_tokens                 = "optional" // IMDSv1 = optional, IMDSv2 = required
    instance_metadata_tags      = "disabled"
  }

  source_dest_check = var.module_var_disable_ip_anti_spoofing ? false : true  // When disable the Anti IP Spoofing = true, then Source/Destination Check = false

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
# AWS EBS does not accept /dev/sdaa.
resource "aws_volume_attachment" "block_volume_attachment" {
  count       = length(aws_ebs_volume.block_volume_provision.*.id)
  device_name = "/dev/sd${element(["d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"], count.index)}"
  instance_id = aws_instance.host.id
  volume_id   = element(aws_ebs_volume.block_volume_provision.*.id, count.index)
}
