
resource "null_resource" "ansible_exec_dry_run" {

  depends_on = [local_file.ansible_extravars, local_file.bastion_rsa, local_file.hosts_rsa]
  count = local.dry_run_boolean ? 1 : 0

  # for ansible-playbook, use timeout set to 180 seconds to avoid error "Connection timed out during banner exchange"
  # for ansible-playbook, use debug with connection details -vvvv if errors occur
  provisioner "local-exec" {
    command = <<EOT
    # If Terraform Cloud/Enterprise, install Ansible to the Workspace Run container (Ubuntu)
    if [ ! -z "$TFC_RUN_ID" ] || [ ! -z "$TFE_RUN_ID" ] ; then echo 'Install Ansible to Terraform Cloud/Enterprise runtime' && python3 -m pip install ansible ; fi

    # Git 2.32.0 and above - ignore the global Git config (e.g. ~/.gitconfig) and system Git config (e.g. /usr/local/etc/gitconfig)
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null

    # Documentation regarding SSH and Timeout configurations
    # https://docs.ansible.com/ansible/latest/reference_appendices/config.html
    # https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ssh_connection.html

    # Ansible Config - Default timeout for connection plugins to use. Equivilant to 'ansible-playbook --timeout 180' command, and creates SSH connection with '-o ConnectTimeout=180'.
    export ANSIBLE_TIMEOUT=180

    # Ansible Config - Forces color mode when run without a TTY
    export ANSIBLE_FORCE_COLOR=1

    ansible_2_9_version="$(ansible --version | awk 'NR==1{print $2}' | sed 's/]//g')"
    ansible_core_version="$(ansible --version | awk 'NR==1{print $3}' | sed 's/]//g')"

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427 . Added search_string variable and removed function to work around Windows using WSL2 and Ubuntu
    search_string="%d%03d%03d%03d\n"
    if [ $(echo $ansible_2_9_version | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') -gt $(echo "2.9.0" | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') ] && [ $(echo $ansible_2_9_version | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') -lt $(echo "2.11.0" | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }') ]; then
      echo "Ansible $ansible_2_9_version detected"
      echo "Lower Ansible version than tested, may produce unexpected results"
      curl -L https://github.com/sap-linuxlab/community.sap_launchpad/archive/refs/heads/main.tar.gz -o ${path.root}/tmp/s4hana_distributed/sap_launchpad-main.tar.gz
      mkdir -p ${path.root}/tmp/s4hana_distributed/ansible_collections/community/sap_launchpad
      tar xvf ${path.root}/tmp/s4hana_distributed/sap_launchpad-main.tar.gz --strip-components=1 -C ${path.root}/tmp/s4hana_distributed/ansible_collections/community/sap_launchpad
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATHS="${abspath(path.root)}/tmp/s4hana_distributed"
    else
      ansible-galaxy collection install git+https://github.com/sap-linuxlab/community.sap_launchpad.git,main --collections-path ${path.root}/tmp/s4hana_distributed
      # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
      export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp/s4hana_distributed"
      #export ANSIBLE_ROLES_PATH="${abspath(path.root)}/tmp/s4hana_distributed/roles"
    fi

    # Find Python used by Ansible on the localhost
    #export ANSIBLE_PYTHON_INTERPRETER="auto_silent"
    #ansible_python=$(ansible --inventory 'localhost,' --connection 'local' --module-name setup localhost | awk '/ansible_python/{f=1} f{print; if (/}/) exit}' | awk '/executable/ { gsub("\"",""); gsub(",",""); print $NF }')
    # For dry-run, test if using venv and enforce use by Ansible instead of system detection
    python_venv_test=$(python -c $'import sys\nif sys.prefix != sys.base_prefix: print("true");')
    if [ $python_venv_test="true" ]; then python_venv_path=$(python -c 'import sys; print(sys.prefix)') && export ANSIBLE_PYTHON_INTERPRETER="$${python_venv_path}/bin/python3" ; fi

    os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
    if [ "$os_info_id" = "ubuntu" ]
    then
      echo "Running on Windows using WSL2 with Ubuntu, amending command execution to use /bin/bash instead of Dash under /bin/sh"
      # Required for running on Windows using WSL2 and Ubuntu (otherwise will default to Dash - https://wiki.ubuntu.com/DashAsBinSh)
      cat << EOF > ansible_dry_run.sh
      #!/bin/bash
      # For local dry-run, override any callback config
      export ANSIBLE_STDOUT_CALLBACK="default"
      ansible-playbook ${path.module}/ansible_playbook_dry_run.yml \
      --extra-vars "@${path.root}/tmp/s4hana_distributed/ansible_vars.yml" \
      --inventory 'localhost,' \
      --connection 'local'
EOF
      chmod +x ansible_dry_run.sh
      /bin/bash ansible_dry_run.sh
    else
      # For local dry-run, override any callback config
      export ANSIBLE_STDOUT_CALLBACK="default"
      ansible-playbook ${path.module}/ansible_playbook_dry_run.yml \
      --extra-vars "@${path.root}/tmp/s4hana_distributed/ansible_vars.yml" \
      --inventory 'localhost,' \
      --connection 'local'
    fi

    EOT
  }

}
