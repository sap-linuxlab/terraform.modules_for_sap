
resource "null_resource" "ansible_exec_dry_run" {

  depends_on = [local_file.ansible_extravars, local_file.bastion_rsa, local_file.hosts_rsa]
  count = local.dry_run_boolean ? 1 : 0

  # for ansible-playbook, use timeout set to 60 seconds to avoid error "Connection timed out during banner exchange"
  # for ansible-playbook, use debug with connection details -vvvv if errors occur
  provisioner "local-exec" {
    command = <<EOT
    # Git 2.32.0 and above - ignore the global Git config (e.g. ~/.gitconfig) and system Git config (e.g. /usr/local/etc/gitconfig)
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null

    # Ansible Config - Forces color mode when run without a TTY
    export ANSIBLE_FORCE_COLOR=1

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
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATHS="${abspath(path.root)}/tmp/${var.module_var_hostname}"
    else
      ansible-galaxy collection install git+https://github.com/sap-linuxlab/community.sap_launchpad.git,main --collections-path ${path.root}/tmp/${var.module_var_hostname}
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}"
      #export ANSIBLE_ROLES_PATH="${abspath(path.root)}/tmp/${var.module_var_hostname}/roles"
    fi

    # Find Python used by Ansible on the localhost
    #export ANSIBLE_PYTHON_INTERPRETER="auto_silent"
    #ansible_python=$(ansible --inventory 'localhost,' --connection 'local' --module-name setup localhost | awk '/ansible_python/{f=1} f{print; if (/}/) exit}' | awk '/executable/ { gsub("\"",""); gsub(",",""); print $NF }')

    os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
    if [ "$os_info_id" = "ubuntu" ]
    then
      echo "Running on Windows using WSL2 with Ubuntu, amending command execution to use /bin/bash instead of Dash under /bin/sh"
      # Required for running on Windows using WSL2 and Ubuntu (otherwise will default to Dash - https://wiki.ubuntu.com/DashAsBinSh)
      cat << EOF > ansible_dry_run.sh
      #!/bin/bash
      ansible-playbook ${path.module}/ansible_playbook_dry_run.yml \
      --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
      --inventory 'localhost,' \
      --connection 'local'
EOF
      chmod +x ansible_dry_run.sh
      /bin/bash ansible_dry_run.sh
    else
      ansible-playbook ${path.module}/ansible_playbook_dry_run.yml \
      --extra-vars "@${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml" \
      --inventory 'localhost,' \
      --connection 'local'
    fi

    EOT
  }

}
