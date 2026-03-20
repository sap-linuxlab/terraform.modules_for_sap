# Note: If login uses root, you do not need "sudo" prefix or "sudo su - root -c 'command here'"
#       For AWS, MS Azure and GCP without initial root login the sudo elevated privilege is required

resource "null_resource" "bastion_config_4" {

  depends_on = [null_resource.bastion_config_3]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.module_var_bastion_private_ssh_key
    host        = aws_instance.bastion_host.public_ip
    port        = var.module_var_bastion_ssh_port

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    # script_path = "/home/azvm-user/terraform_tmp_remote_exec_inline.sh"
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "bastion_config_4.sh"
    content     = <<EOT
    #!/bin/bash
    echo 'Disable ec2-user'
    sudo mv /home/ec2-user/.ssh/authorized_keys /home/ec2-user/.ssh/disabled_keys
    echo 'Disabled the ec2-user'
    EOT
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/bastion_config_4.sh ; sudo su - root -c 'bash /home/ec2-user/bastion_config_4.sh'"
    ]
  }

}
