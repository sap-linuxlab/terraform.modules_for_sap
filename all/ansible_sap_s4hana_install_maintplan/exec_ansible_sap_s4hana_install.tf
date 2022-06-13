
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
    # Git 2.32.0 and above - ignore the global Git config (e.g. ~/.gitconfig) and system Git config (e.g. /usr/local/etc/gitconfig)
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null

    ansible_version="$(ansible --version | awk 'NR==1{print $3}' | sed 's/]//g')"

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427
    function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

    ansible-galaxy collection install --requirements-file ${path.module}/ansible_requirements_collections.yml --collections-path ${path.root}/tmp/${var.module_var_hostname}/collections
    #ansible-galaxy install --role-file ${path.module}/ansible_requirements_roles.yml --roles-path ${path.root}/tmp/${var.module_var_hostname}/roles

    # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
    export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/collections"
    #export ANSIBLE_ROLES_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/roles"

    # Ansible Config - Default timeout for connection plugins to use. Equivilant to 'ansible-playbook --timeout 60' command
    export ANSIBLE_TIMEOUT=90

    # Ansible Config - Timeout for persistent connection response from remote device
    export ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=120

    # Ansible Config - Timeout for persistent connection retry to the local socket
    export ANSIBLE_PERSISTENT_CONNECT_RETRY_TIMEOUT=120

    # Ansible Config - Timeout for persistent connection idle before closed
    export ANSIBLE_PERSISTENT_CONNECT_TIMEOUT=120

    # Ansible Config - Forces color mode when run without a TTY
    export ANSIBLE_FORCE_COLOR=1

    if [ $(version $ansible_version) -gt $(version "2.9.0") ] && [ $(version $ansible_version) -lt $(version "2.11.0") ]; then
        echo "Lower Ansible version than tested, may produce unexpected results"
        export ANSIBLE_COLLECTIONS_PATHS="${abspath(path.root)}/tmp/${var.module_var_hostname}/collections"
    fi

  bastion_boolean="${var.module_var_bastion_boolean}"

  if [ $bastion_boolean == "true" ]; then
    ansible-playbook ${path.module}/ansible_playbook.yml \
    --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
    --connection 'ssh' \
    --user root \
    --inventory '${var.module_var_host_private_ip},' \
    --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
    --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=1800s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/${var.module_var_hostname}/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
  elif [ $bastion_boolean == "false" ]; then
    ansible-playbook ${path.module}/ansible_playbook.yml \
    --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
    --connection 'ssh' \
    --user root \
    --inventory '${var.module_var_host_private_ip},' \
    --private-key '${path.root}/tmp/${var.module_var_hostname}/hosts_rsa' \
    --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=1800s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
  fi

    EOT
  }

}
