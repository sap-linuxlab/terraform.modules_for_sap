
resource "null_resource" "ansible_exec_dry_run" {

  depends_on = [local_file.ansible_extravars, local_file.bastion_rsa, local_file.hosts_rsa]
  count = var.module_var_dry_run_boolean ? 1 : 0

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

    ansible-galaxy collection install git+https://github.com/sap-linuxlab/community.sap_launchpad.git,main --collections-path ${path.root}/tmp/${var.module_var_hostname}/collections

    # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
    export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/collections"
    #export ANSIBLE_ROLES_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/roles"

    # Ansible Config - Forces color mode when run without a TTY
    export ANSIBLE_FORCE_COLOR=1

    if [ $(version $ansible_version) -gt $(version "2.9.0") ] && [ $(version $ansible_version) -lt $(version "2.11.0") ]; then
        echo "Lower Ansible version than tested, may produce unexpected results"
        export ANSIBLE_COLLECTIONS_PATHS="${abspath(path.root)}/tmp/${var.module_var_hostname}/collections"
    fi

    # Find Python used by Ansible on the localhost
    #export ANSIBLE_PYTHON_INTERPRETER="auto_silent"
    #ansible_python=$(ansible --inventory 'localhost,' --connection 'local' --module-name setup localhost | awk '/ansible_python/{f=1} f{print; if (/}/) exit}' | awk '/executable/ { gsub("\"",""); gsub(",",""); print $NF }')

    ansible-playbook ${path.module}/ansible_playbook_dry_run.yml \
    --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
    --inventory 'localhost,' \
    --connection 'local'

    EOT
  }

}
