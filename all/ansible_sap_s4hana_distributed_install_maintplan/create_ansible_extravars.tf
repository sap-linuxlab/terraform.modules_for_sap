
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_extravars" {
  filename        = "${path.root}/tmp/s4hana_distributed/ansible_vars.yml"
  file_permission = "0755"
  content         = <<EOF

# ---- Mandatory parameters : Ansible Defaults ---- #

#ansible_python_interpreter: python3

# Default Ansible Facts populate into default variables for all Ansible Roles
sap_hostname: "{{ ansible_hostname }}"
sap_domain: "{{ ansible_domain }}"
sap_ip: "{{ ansible_default_ipv4.address }}"


# ---- Mandatory parameters : Ansible Inventory variables ---- #

sap_inventory_hana_primary_hostname: "{{ hostvars[inventory_hostname].groups.hana_primary[0] }}"
sap_inventory_nw_ascs_hostname: "{{ hostvars[inventory_hostname].groups.nwas_ascs[0] }}"
sap_inventory_nw_pas_hostname: "{{ hostvars[inventory_hostname].groups.nwas_pas[0] }}"
sap_inventory_nw_aas_hostname: "{{ hostvars[inventory_hostname].groups.nwas_aas[0] }}"

sap_inventory_hana_primary_ip: "{{ hostvars[sap_inventory_hana_primary_hostname].ansible_host }}"
sap_inventory_nw_ascs_ip: "{{ hostvars[sap_inventory_nw_ascs_hostname].ansible_host }}"
sap_inventory_nw_pas_ip: "{{ hostvars[sap_inventory_nw_pas_hostname].ansible_host }}"
sap_inventory_nw_aas_ip: "{{ hostvars[sap_inventory_nw_aas_hostname].ansible_host }}"


# ---- Mandatory parameters : Preconfigure OS for SAP Software ---- #

# Configuration of Ansible Roles for preconfigure SAP (general, hana, netweaver)
sap_general_preconfigure_modify_etc_hosts: false
sap_general_preconfigure_reboot_ok: no
sap_general_preconfigure_fail_if_reboot_required: no
sap_hana_preconfigure_reboot_ok: yes
sap_hana_preconfigure_fail_if_reboot_required: no
sap_hana_preconfigure_update: yes
sap_hana_update_etchosts: yes
sap_netweaver_preconfigure_fail_if_not_enough_swap_space_configured: no



# ---- Mandatory parameters : SAP Software installation media downloads ---- #

dry_run_test: "${var.module_var_dry_run_test}"

# SAP ONE Support Launchpad credentials
suser_id: "${var.module_var_sap_id_user}"
suser_password: '${var.module_var_sap_id_user_password}'

# SAP Maintenance Planner transaction name
sap_mp_transaction_name: '${var.module_var_sap_maintenance_planner_transaction_name}'

# Directory for SAP installation media
sap_install_media_detect_directory: "${var.module_var_sap_software_download_directory}"

# Configuration for SAP installation media detection
# sap_install_media_detect_** variables are set for each Ansible Task to the respective host


# SAP SWPM may not be included in the Maintenance Planner stack generated, please check and if not included then append to list 
softwarecenter_search_list_sapcar_x86_64:
  - 'SAPCAR_1115-70006178.EXE'
softwarecenter_search_list_sapcar_ppc64le:
  - 'SAPCAR_1115-70006238.EXE'


# ---- Mandatory parameters : SAP HANA installation ---- #

# Install directory of SAP HANA must contain:
#   1.  IMDB_SERVER*SAR file
#   2.  IMDB_*SAR files for all SAP HANA components to install
#   3.  SAPCAR executable
sap_hana_install_software_directory: "${var.module_var_sap_software_download_directory}/sap_hana"

# SAP HANA master password
sap_hana_install_use_master_password: "${var.module_var_sap_hana_install_use_master_password}"
sap_hana_install_master_password: "${var.module_var_sap_hana_install_master_password}"

# SAP HANA database server instance details
sap_hana_install_sid: "${var.module_var_sap_hana_install_sid}"
sap_hana_install_instance_number: "${var.module_var_sap_hana_install_instance_number}"



# ---- Optional parameters : SAP HANA installation ---- #

# List of components to be installed, default 'all'
# Components should be comma separated
# sap_hana_install_components: 'all'

# Unix User
# Leave this blank if you want this set automatically by hdblcm
# For production systems, it's highly advisable to set this manually according to your environment's Unix ID policies
# sap_hana_install_userid:
# sap_hana_install_groupid:

# Adjust these accordingly for your installation type
# sap_hana_install_env_type: 'production'
# sap_hana_install_mem_restrict: 'n'
# sap_hana_install_max_mem:
# sap_hana_install_system_restart: 'n'

# Pass some extra arguments to the hdblcm cli, e.g.  --ignore=<check1>[,<check2>]...
# sap_hana_install_hdblcm_extraargs:

# Update hosts file
sap_hana_install_update_etchosts: 'false'

# For more optional parameters please consult the documentation or
# Check the file <role path>/defaults/main.yml



# ---- Mandatory parameters : Ansible Dictionary for SAP HANA installation media ---- #

sap_hana_install_media_dictionary:

  sap_hana_2_sps06_install:

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_*'
      - 'SAPHOSTAGENT*'



# ---- Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input_prefix: "${var.module_var_sap_swpm_template_selected}" # sap_s4hana_2021_distributed, sap_s4hana_2022_distributed
#sap_swpm_templates_product_input: # Set for each Ansible Task to the respective host

# Override any variable set in sap_swpm_inifile_dictionary
# NW Passwords
sap_swpm_master_password: "${var.module_var_sap_swpm_master_password}"
sap_swpm_ddic_000_password: "${var.module_var_sap_swpm_ddic_000_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# HDB Configuration
sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"
sap_swpm_db_host: "{{ hostvars[inventory_hostname].groups.hana_primary[0] }}" # Must be SAP HANA primary node

# Override any variable set in sap_swpm_inifile_dictionary
# HDB Passwords
sap_swpm_db_schema_abap_password: "${var.module_var_sap_swpm_db_schema_abap_password}"
sap_swpm_db_sidadm_password: "${var.module_var_sap_swpm_db_sidadm_password}"
sap_swpm_db_system_password: "${var.module_var_sap_swpm_db_system_password}"
sap_swpm_db_systemdb_password: "${var.module_var_sap_swpm_db_systemdb_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# ASCS and PAS hosts
sap_swpm_ascs_instance_hostname: "{{ hostvars[inventory_hostname].groups.nwas_ascs[0] }}"
sap_swpm_pas_instance_hostname: "{{ hostvars[inventory_hostname].groups.nwas_pas[0] }}"

# Override any variable set in sap_swpm_inifile_dictionary
# Unix User ID
sap_swpm_sapadm_uid: '3000'
sap_swpm_sapsys_gid: '3001'
sap_swpm_sidadm_uid: '3001'

# Override any variable set in sap_swpm_inifile_dictionary
# Other
sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
sap_swpm_update_etchosts: 'false'



# ---- Mandatory parameters : Ansible Dictionary for SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

# Templates and default values
sap_swpm_templates_install_dictionary:

  sap_s4hana_2022_distributed_nwas_ascs:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_ASCS:S4HANA2022.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'MP_*.xml'


  sap_s4hana_2022_distributed_nwas_pas_dbload:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_DB:S4HANA2022.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'S4CORE*'
      - 'S4HANAOP*'
      - 'HANAUMML*'
      - 'K-*'
      - 'KD*'
      - 'KE*'
      - 'KIT*'
      - 'SAPPAAPL*'
      - 'SAP_BASIS*'
      - 'MP_*.xml'


  sap_s4hana_2022_distributed_nwas_pas:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_CI:S4HANA2022.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'MP_*.xml'


  sap_s4hana_2022_distributed_nwas_aas:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_DI:S4HANA2022.CORE.HDB.PD

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_ports
      - nw_config_other
      - nw_config_additional_application_server_instance
      - nw_config_host_agent
      - sap_os_linux_user

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # Product ID suffix is not .ABAP, therefore set variables manually for sap_swpm Ansible Role to populate inifile.params
      sap_swpm_db_schema: "{{ sap_swpm_db_schema_abap }}"
      sap_swpm_db_schema_password: "{{ sap_swpm_db_schema_abap_password }}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP Maintenace Planner, ensure SAP SWPM sapinst property is not used otherwise SAP NWAS AAS will not install
      # When passing the SAP Maintenance Planner Stack XML file to SAP SWPM sapinst, the Product Catalog ID suffix .PD is rejected by SAP SWPM 2.0 with "no component with this ID was found in product catalog"
      #sap_swpm_mp_stack_path: ''

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'


  sap_s4hana_2021_distributed_nwas_ascs:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_ASCS:S4HANA2021.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'MP_*.xml'


  sap_s4hana_2021_distributed_nwas_pas_dbload:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_DB:S4HANA2021.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'S4CORE*'
      - 'S4HANAOP*'
      - 'HANAUMML*'
      - 'K-*'
      - 'KD*'
      - 'KE*'
      - 'KIT*'
      - 'SAPPAAPL*'
      - 'SAP_BASIS*'
      - 'MP_*.xml'


  sap_s4hana_2021_distributed_nwas_pas:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_ABAP_CI:S4HANA2021.CORE.HDB.ABAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - maintenance_plan_stack_tms_config
      - maintenance_plan_stack_spam_config
      - maintenance_plan_stack_sum_config

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP SWPM using SAP Maintenance Planner Stack XML
      sap_swpm_mp_stack_path: "${var.module_var_sap_software_download_directory}" # Enables search for MP Stack XML file and changes SAP SWPM execution
      sap_swpm_configure_tms: true
      sap_swpm_tmsadm_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_spam_update: false
      sap_swpm_sum_prepare: true
      sap_swpm_sum_start: true

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'
      - 'MP_*.xml'


  sap_s4hana_2021_distributed_nwas_aas:

    # Product ID for New Installation
    sap_swpm_product_catalog_id: NW_DI:S4HANA2021.CORE.HDB.PD

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm2_hana
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
      - nw_config_ports
      - nw_config_other
      - nw_config_additional_application_server_instance
      - nw_config_host_agent
      - sap_os_linux_user

    sap_swpm_inifile_dictionary:

      # NW Instance Parameters
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      #sap_swpm_virtual_hostname: "{{ ansible_hostname }}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"

      # HDB Instance Parameters
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"

      # Product ID suffix is not .ABAP, therefore set variables manually for sap_swpm Ansible Role to populate inifile.params
      sap_swpm_db_schema: "{{ sap_swpm_db_schema_abap }}"
      sap_swpm_db_schema_password: "{{ sap_swpm_db_schema_abap_password }}"

      # SAP Host Agent
      sap_swpm_install_saphostagent: 'true'

      # SAP Maintenace Planner, ensure SAP SWPM sapinst property is not used otherwise SAP NWAS AAS will not install
      # When passing the SAP Maintenance Planner Stack XML file to SAP SWPM sapinst, the Product Catalog ID suffix .PD is rejected by SAP SWPM 2.0 with "no component with this ID was found in product catalog"
      #sap_swpm_mp_stack_path: ''

    software_files_wildcard_list:
      - 'SAPCAR*'
      - 'IMDB_CLIENT*'
      - 'SWPM20*'
      - 'igsexe_*'
      - 'igshelper_*'
      - 'SAPEXE_*' # Kernel Part I (785)
      - 'SAPEXEDB_*' # Kernel Part I (785)
      - 'SUM*'
      - 'SAPHOSTAGENT*'


# ---- Mandatory parameters : SAP S/4HANA ICM HTTPS ---- #

sap_update_profile_sid: "${var.module_var_sap_swpm_sid}"
sap_update_profile_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
sap_update_profile_default_profile_params:
  - icm/server_port_1 = PROT=HTTPS,PORT=443$$,PROCTIMEOUT=600,TIMEOUT=3600
#sap_update_profile_instance_profile_params:
#  - icm/server_port_1 = PROT=HTTPS,PORT=443$$,PROCTIMEOUT=600,TIMEOUT=3600


# Use Ansible Task to convert JSON (as string) to sap_storage_setup_definition Dictionary
terraform_host_specification_storage_definition: "{{ '${replace(jsonencode(var.module_var_terraform_host_specification_storage_definition_all_hosts),"\"","\\\"")}' | from_json }}"

EOF
}
