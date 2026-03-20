
# Create Bastion/Jump host

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.bastion_os_image.image_id
  instance_type               = "c4.xlarge"
  key_name                    = var.module_var_bastion_ssh_key_name
  vpc_security_group_ids      = [aws_security_group.bastion_connection_sg.id, aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.vpc_bastion_subnet.id
  tenancy                     = "default"
  associate_public_ip_address = "true"

  # Pass cloud-init or bash script payloads with user_data
  # Stored into /var/lib/cloud/instance/user-data.txt
  # Scripts entered as user data are executed as the root user
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
  # user_data = ""

  # Change Hostname, use EOF with dash to trim whitespace
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
  # https://stackoverflow.com/questions/603351/can-we-set-easy-to-remember-hostnames-for-ec2-instances
  # https://github.com/brikis98/terraform-up-and-running-code/issues/12#issuecomment-294375284

  user_data = <<-EOF
   #! /bin/bash
   sudo hostnamectl set-hostname ${var.module_var_resource_prefix}-bastion
 EOF

  root_block_device {
    delete_on_termination = "true"
    volume_size           = "50"
    volume_type           = "standard"
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-bastion"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
