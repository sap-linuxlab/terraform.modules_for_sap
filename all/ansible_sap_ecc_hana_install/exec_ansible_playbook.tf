
##############################################################
# Terrform and Ansible
##############################################################

# Terraform null-resource provider with Local Execution provisioner, execute Ansible on Terraform host towards single IP Address

# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "bastion_rsa" {
  count           = local.dry_run_boolean ? 0 : var.module_var_bastion_boolean ? 1 : 0
  depends_on      = [local_file.ansible_extravars]
  content         = var.module_var_bastion_private_ssh_key
  filename        = "${path.root}/tmp/${var.module_var_hostname}/bastion_rsa"
  file_permission = "0400"
}

# Use path object to store key files temporarily in module of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  count           = local.dry_run_boolean ? 0 : 1
  depends_on      = [local_file.ansible_extravars]
  content         = var.module_var_host_private_ssh_key
  filename        = "${path.root}/tmp/${var.module_var_hostname}/hosts_rsa"
  file_permission = "0400"
}


resource "null_resource" "ansible_exec" {

  depends_on = [local_file.ansible_extravars, local_file.bastion_rsa, local_file.hosts_rsa]
  count = local.dry_run_boolean ? 0 : 1

  # for ansible-playbook, use timeout set to 60 seconds to avoid error "Connection timed out during banner exchange"
  # for ansible-playbook, use debug with connection details -vvvv if errors occur
  provisioner "local-exec" {
    command = <<EOT
    # If Terraform Cloud/Enterprise, install Ansible to the Workspace Run container (Ubuntu)
    if [ ! -z "$TFC_RUN_ID" ] || [ ! -z "$TFE_RUN_ID" ] ; then echo 'Install Ansible to Terraform Cloud/Enterprise runtime' && python3 -m pip install ansible ; fi

    # Documentation regarding SSH and Timeout configurations
    # https://docs.ansible.com/ansible/latest/reference_appendices/config.html
    # https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ssh_connection.html

    # Ansible Config - Default timeout for connection plugins to use. Equivilant to 'ansible-playbook --timeout 180' command, and creates SSH connection with '-o ConnectTimeout=180'.
    export ANSIBLE_TIMEOUT=180

    # Ansible Config - Timeout for persistent connection response from remote device
    export ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=180

    # Ansible Config - Timeout for persistent connection retry to the local socket
    export ANSIBLE_PERSISTENT_CONNECT_RETRY_TIMEOUT=180

    # Ansible Config - Timeout for persistent connection idle before closed
    export ANSIBLE_PERSISTENT_CONNECT_TIMEOUT=180

    # Ansible Config - Forces color mode when run without a TTY
    export ANSIBLE_FORCE_COLOR=1

    # Ansible Config - Arguments to pass to all SSH CLI tools. To ensure larger timeouts, overwrite the default "-C -o ControlMaster=auto -o ControlPersist=60s"
    export ANSIBLE_SSH_ARGS="-C"

    # Ansible Config - Common extra args for all SSH CLI tools. Leave blank, same as default.
    export ANSIBLE_SSH_COMMON_ARGS=""

    ansible_2_9_version="$(ansible --version | awk 'NR==1{print $2}' | sed 's/]//g')"
    ansible_core_version="$(ansible --version | awk 'NR==1{print $3}' | sed 's/]//g')"

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427 . Added search_string variable and removed function to work around Windows using WSL2 and Ubuntu
    search_string="%d%03d%03d%03d\n"
    if [ $(echo $ansible_2_9_version | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') -gt $(echo "2.9.0" | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') ] && [ $(echo $ansible_2_9_version | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') -lt $(echo "2.11.0" | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') ]; then
      echo "Ansible $ansible_2_9_version detected"
      echo "Lower Ansible version than tested, may produce unexpected results"
      curl -L https://github.com/sap-linuxlab/community.sap_launchpad/archive/refs/heads/main.tar.gz -o ${path.root}/tmp/${var.module_var_hostname}/sap_launchpad-main.tar.gz
      mkdir -p ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_launchpad
      tar xvf ${path.root}/tmp/${var.module_var_hostname}/sap_launchpad-main.tar.gz --strip-components=1 -C ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_launchpad
      curl -L https://github.com/sap-linuxlab/community.sap_install/archive/refs/tags/1.2.0.tar.gz -o ${path.root}/tmp/${var.module_var_hostname}/sap_install-1.2.0.tar.gz
      mkdir -p ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_install
      tar xvf ${path.root}/tmp/${var.module_var_hostname}/sap_install-1.2.0.tar.gz --strip-components=1 -C ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_install
      curl -L https://github.com/sap-linuxlab/community.sap_operations/archive/refs/heads/main.tar.gz -o ${path.root}/tmp/${var.module_var_hostname}/sap_operations-main.tar.gz
      mkdir -p ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_operations
      tar xvf ${path.root}/tmp/${var.module_var_hostname}/sap_operations-main.tar.gz --strip-components=1 -C ${path.root}/tmp/${var.module_var_hostname}/ansible_collections/community/sap_operations
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATHS="${abspath(path.root)}/tmp/${var.module_var_hostname}"
    else
      ansible-galaxy collection install --requirements-file ${path.module}/ansible_requirements_collections.yml --collections-path ${path.root}/tmp/${var.module_var_hostname}
      #ansible-galaxy install --role-file ${path.module}/ansible_requirements_roles.yml --roles-path ${path.root}/tmp/${var.module_var_hostname}/roles
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}"
      #export ANSIBLE_ROLES_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/roles"
    fi

    bastion_boolean="${var.module_var_bastion_boolean}"

    os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
    if [ "$os_info_id" = "ubuntu" ]
    then
      echo "Running on Windows using WSL2 with Ubuntu, amending command execution to use /bin/bash instead of Dash under /bin/sh"
      # Required for running on Windows using WSL2 and Ubuntu (otherwise will default to Dash - https://wiki.ubuntu.com/DashAsBinSh)
      cat << EOF > ansible_exec.sh
      #!/bin/bash
      if [ $bastion_boolean == "true" ]; then
        ansible-playbook ${path.module}/ansible_playbook.yml \
        --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
        --connection 'ssh' \
        --user root \
        --inventory '${var.module_var_host_private_ip},' \
        --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
        --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/${var.module_var_hostname}/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
      elif [ $bastion_boolean == "false" ]; then
        ansible-playbook ${path.module}/ansible_playbook.yml \
        --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
        --connection 'ssh' \
        --user root \
        --inventory '${var.module_var_host_private_ip},' \
        --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
        --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no"
      fi
EOF
      chmod +x ansible_exec.sh
      /bin/bash ansible_exec.sh
    else
      if [ $bastion_boolean == "true" ]; then
        ansible-playbook ${path.module}/ansible_playbook.yml \
        --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
        --connection 'ssh' \
        --user root \
        --inventory '${var.module_var_host_private_ip},' \
        --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
        --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/${var.module_var_hostname}/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
      elif [ $bastion_boolean == "false" ]; then
        ansible-playbook ${path.module}/ansible_playbook.yml \
        --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
        --connection 'ssh' \
        --user root \
        --inventory '${var.module_var_host_private_ip},' \
        --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
        --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no"
      fi
    fi

    EOT
  }

}
