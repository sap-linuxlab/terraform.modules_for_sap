
##############################################################
# Terrform and Ansible
##############################################################

# Terraform null-resource provider with Local Execution provisioner, execute Ansible on Terraform host towards single IP Address

# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "bastion_rsa" {
  depends_on      = [local_file.ansible_extravars]
  content         = var.module_var_bastion_private_ssh_key
  filename        = "${path.root}/tmp/bastion_rsa"
  file_permission = "0400"
}

# Use path object to store key files temporarily in module of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  depends_on      = [local_file.ansible_extravars]
  content         = var.module_var_host_private_ssh_key
  filename        = "${path.root}/tmp/hosts_rsa"
  file_permission = "0400"
}


resource "null_resource" "ansible_exec" {

  depends_on = [local_file.ansible_extravars, local_file.bastion_rsa, local_file.hosts_rsa]

  # for ansible-playbook, use timeout set to 180 seconds to avoid error "Connection timed out during banner exchange"
  # for ansible-playbook, use debug with connection details -vvvv if errors occur
  provisioner "local-exec" {
    command = <<EOT

    sap_scenario_selection="${var.module_var_ansible_sap_scenario_selection}"

    # If Terraform Cloud/Enterprise, install Ansible Core to the Workspace Run container (Ubuntu)
    if [ ! -z "$TFC_RUN_ID" ] || [ ! -z "$TFE_RUN_ID" ] ; then echo 'Install Ansible to Terraform Cloud/Enterprise runtime' && python -m pip install ansible-core ; fi

    # Documentation regarding SSH and Timeout configurations
    # https://docs.ansible.com/ansible/latest/reference_appendices/config.html
    # https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ssh_connection.html

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427 . Added search_string variable and removed function to work around Windows using WSL2 and Ubuntu
    search_string="%d%03d%03d%03d\n"

    ansible_2_9_version="$(ansible --version | awk 'NR==1{print $2}' | sed 's/]//g')"
    ansible_core_version="$(ansible --version | awk 'NR==1{print $3}' | sed 's/]//g')"
    ansible_core_version_int="$(echo $ansible_core_version | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }')"
    ansible_core_min_version_int="$(echo "2.12.0" | awk -F '.' '{ printf "'$search_string'", $1,$2,$3,$4; }')"

    if $(grep -q "2.9" <<< "$ansible_2_9_version") ; then echo 'Ansible 2.9 is very out of date, exit' && exit 1 ; fi
    if [ $ansible_core_version_int -gt $ansible_core_min_version_int ] ; then echo 'Ansible 2.12.0+ detected, ready to execute' ; fi

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

    # Ansible Config - Arguments to pass to all SSH CLI tools
    # Default is "-C -o ControlMaster=auto -o ControlPersist=60s", if set to "-C" and using --ssh-extra-args operator for Ansible, then sftp and scp will have errors "transfer mechanism failed on"
    export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=3600s"

    # Ansible Config - Common extra args for all SSH CLI tools. Leave blank, same as default.
    export ANSIBLE_SSH_COMMON_ARGS=""

    echo "### Download Ansible Playbooks for SAP ###"
    mkdir -p ${abspath(path.root)}/tmp/ansible_playbooks_for_sap
    ansible_playbooks_for_sap_latest=$(curl -s https://api.github.com/repos/sap-linuxlab/ansible.playbooks_for_sap/releases/latest | grep "tarball_url" | cut -d ':' -f 2,3 | tr -d '"' | tr -d ' ' | tr -d ',')
    curl -L -J -O $ansible_playbooks_for_sap_latest --output-dir ${abspath(path.root)}/tmp
    tar xf ${abspath(path.root)}/tmp/sap-linuxlab-ansible.playbooks_for_sap-*.tar.gz -C ${abspath(path.root)}/tmp/ansible_playbooks_for_sap --strip-components 1

    echo "### Amend Requirements for Ansible Playbooks for SAP ###"
    sed -i .bak '/# Collections for Infrastructure from Ansible Galaxy.*$/,$d' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_requirements.yml
    ansible-galaxy collection install --requirements-file ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_requirements.yml --collections-path ${path.root}/tmp
    # Must export the Shell Variable, otherwise it cannot be read by Ansible binaries
    export ANSIBLE_COLLECTIONS_PATH="${abspath(path.root)}/tmp"

    echo "### Edit selected SAP scenario from Ansible Playbooks for SAP ###"
    sed -i .bak 's|sap_vm_provision_iac_type: "ENTER_STRING_VALUE_HERE"|sap_vm_provision_iac_type: "existing_hosts"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_vm_provision_iac_platform: "ENTER_STRING_VALUE_HERE"|sap_vm_provision_iac_platform: "existing_hosts"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_vm_provision_dns_root_domain: "ENTER_STRING_VALUE_HERE"|sap_vm_provision_dns_root_domain: "${var.module_var_dns_root_domain}"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_vm_provision_host_specification_plan: "ENTER_STRING_VALUE_HERE"|sap_vm_provision_host_specification_plan: "${var.module_var_host_specification_plan}"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_software_product: "ENTER_STRING_VALUE_HERE"|sap_software_product: "${var.module_var_ansible_sap_software_product}"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_id_user: "ENTER_STRING_VALUE_HERE"|sap_id_user: "${var.module_var_ansible_sap_id_user}"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak "s|sap_id_user_password: 'ENTER_STRING_VALUE_HERE'|sap_id_user_password: '${var.module_var_ansible_sap_id_user_password}'|" ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_install_media_detect_source_directory: "ENTER_STRING_VALUE_HERE"|sap_install_media_detect_source_directory: "${var.module_var_ansible_sap_software_download_directory}"|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_sid\:.*#|sap_system_sid: \"${var.module_var_ansible_sap_system_sid}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_hana_db_sid\:.*#|sap_system_hana_db_sid: \"${var.module_var_ansible_sap_system_hana_db_sid}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_hana_db_instance_nr\:.*#|sap_system_hana_db_instance_nr: \"${var.module_var_ansible_sap_system_hana_db_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_anydb_sid\:.*#|sap_system_anydb_sid: \"${var.module_var_ansible_sap_system_anydb_sid}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_nwas_abap_ascs_instance_nr\:.*#|sap_system_nwas_abap_ascs_instance_nr: \"${var.module_var_ansible_sap_system_nwas_abap_ascs_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_nwas_abap_pas_instance_nr\:.*#|sap_system_nwas_abap_pas_instance_nr: \"${var.module_var_ansible_sap_system_nwas_abap_pas_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_nwas_abap_aas_instance_nr\:.*#|sap_system_nwas_abap_aas_instance_nr: \"${var.module_var_ansible_sap_system_nwas_abap_aas_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_nwas_java_scs_instance_nr\:.*#|sap_system_nwas_java_scs_instance_nr: \"${var.module_var_ansible_sap_system_nwas_java_scs_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_system_nwas_java_ci_instance_nr\:.*#|sap_system_nwas_java_ci_instance_nr: \"${var.module_var_ansible_sap_system_nwas_java_ci_instance_nr}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    sed -i .bak 's|sap_maintenance_planner_transaction_name\:.*#|sap_maintenance_planner_transaction_name: "${var.module_var_ansible_sap_maintenance_planner_transaction_name}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml
    if [ "${strcontains(var.module_var_ansible_sap_scenario_selection, "solman")}" == "true" ] ; then sed -i .bak 's|sap_system_sid_abap\:.*#|sap_system_sid_abap: \"${var.module_var_ansible_sap_system_sid}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml ; fi
    if [ "${strcontains(var.module_var_ansible_sap_scenario_selection, "solman")}" == "true" ] ; then sed -i .bak 's|sap_system_sid_java\:.*#|sap_system_sid_java: \"${format("%s%s%s",substr(var.module_var_ansible_sap_system_sid,0,1),"J",substr(var.module_var_ansible_sap_system_sid,2,1))}\" #|' ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml ; fi

    echo "### Execute Ansible Playbooks for SAP ###"
    ansible-playbook -vv ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_playbook.yml \
    --extra-vars "@${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_extravars.yml" \
    --extra-vars "@${abspath(path.root)}/tmp/ansible_extravars_generated.yml" \
    --inventory "${abspath(path.root)}/tmp/ansible_inventory.ini" \
    --private-key '${abspath(path.root)}/tmp/hosts_rsa' \
    --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"


#     bastion_boolean="${var.module_var_bastion_boolean}"

#     os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
#     if [ "$os_info_id" = "ubuntu" ]
#     then
#       echo "Running on Windows using WSL2 with Ubuntu, amending command execution to use /bin/bash instead of Dash under /bin/sh"
#       # Required for running on Windows using WSL2 and Ubuntu (otherwise will default to Dash - https://wiki.ubuntu.com/DashAsBinSh)
#       cat << EOF > ansible_exec.sh
#       #!/bin/bash
#       if [ $bastion_boolean == "true" ]; then
#         ansible-playbook ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_playbook.yml \
#         --extra-vars "@${path.root}/tmp/ansible_vars.yml" \
#         --connection 'ssh' \
#         --user root \
#         --inventory '$${var.module_var_host_private_ip},' \
#         --private-key '${path.root}/tmp/hosts_rsa' \
#         --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
#       elif [ $bastion_boolean == "false" ]; then
#         ansible-playbook ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_playbook.yml \
#         --extra-vars "@${path.root}/tmp/ansible_vars.yml" \
#         --connection 'ssh' \
#         --user root \
#         --inventory '$${var.module_var_host_private_ip},' \
#         --private-key '${path.root}/tmp/hosts_rsa' \
#         --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no"
#       fi
# EOF
#       chmod +x ansible_exec.sh
#       /bin/bash ansible_exec.sh
#     else
#       if [ $bastion_boolean == "true" ]; then
#         ansible-playbook ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_playbook.yml \
#         --extra-vars "@${path.root}/tmp/ansible_vars.yml" \
#         --connection 'ssh' \
#         --user root \
#         --inventory '$${var.module_var_host_private_ip},' \
#         --private-key '${path.root}/tmp/hosts_rsa' \
#         --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o ProxyCommand='ssh -W %h:%p ${var.module_var_bastion_user}@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/tmp/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
#       elif [ $bastion_boolean == "false" ]; then
#         ansible-playbook ${abspath(path.root)}/tmp/ansible_playbooks_for_sap/deploy_scenarios/$sap_scenario_selection/ansible_playbook.yml \
#         --extra-vars "@${path.root}/tmp/ansible_vars.yml" \
#         --connection 'ssh' \
#         --user root \
#         --inventory '$${var.module_var_host_private_ip},' \
#         --private-key '${path.root}/tmp/hosts_rsa' \
#         --ssh-extra-args="-o ControlMaster=auto -o ControlPersist=3600s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no"
#       fi
#     fi

    EOT
  }

}
