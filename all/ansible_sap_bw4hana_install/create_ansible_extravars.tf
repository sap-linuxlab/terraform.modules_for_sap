
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_extravars" {
  filename        = "${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml"
  file_permission = "0755"
  content         = <<EOF

# ---- Mandatory parameters : Ansible Defaults ---- #

#ansible_python_interpreter: python3

# Default Ansible Facts populate into default variables for all Ansible Roles
sap_hostname: "{{ ansible_hostname }}"
sap_domain: "{{ ansible_domain }}"
sap_ip: "{{ ansible_default_ipv4.address }}"



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

# Directory for SAP installation media
sap_install_media_detect_directory: "${var.module_var_sap_software_download_directory}"

# Configuration for SAP installation media detection
sap_install_media_detect_source: local_dir
sap_install_media_detect_db: "saphana"
sap_install_media_detect_swpm: true
sap_install_media_detect_hostagent: true
sap_install_media_detect_igs: true
sap_install_media_detect_kernel: true
sap_install_media_detect_webdisp: false
#sap_install_media_detect_export:
#sap_install_media_detect_backup_directory:
#sap_install_media_detect_backup:



# ------ Mandatory parameters : SAP HANA installation ------ #

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



# ------ Optional parameters : SAP HANA installation ------ #

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



# ------ Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ------ #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input: "${var.module_var_sap_swpm_template_selected}"

# Override any variable set in sap_swpm_inifile_dictionary
# NW Passwords
sap_swpm_master_password: "${var.module_var_sap_swpm_master_password}"
sap_swpm_ddic_000_password: "${var.module_var_sap_swpm_ddic_000_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# HDB Passwords
sap_swpm_db_system_password: "${var.module_var_sap_swpm_db_system_password}"
sap_swpm_db_systemdb_password: "${var.module_var_sap_swpm_db_systemdb_password}"
sap_swpm_db_schema_abap_password: "${var.module_var_sap_swpm_db_schema_abap_password}"
sap_swpm_db_sidadm_password: "${var.module_var_sap_swpm_db_sidadm_password}"



# ---- Mandatory parameters : Ansible Dictionary for SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

# Templates and default values
sap_swpm_templates_install_dictionary:

  sap_bw4hana_2021_onehost_install:

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BW4HANA2021.CORE.HDB.ABAP

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"
      sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"
      sap_swpm_update_etchosts: 'false'

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
      - sap_os_linux_user

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'IMDB_SERVER20_064_0-80002031.SAR'
      - 'IMDB_LCAPPS_2064_0-20010426.SAR'
      - 'IMDB_AFL20_064_1-80001894.SAR'
      - 'IMDB_CLIENT20_014_18-80002082.SAR'
      - 'SWPM20SP12_6-80003424.SAR'
      - 'igsexe_1-70005417.sar' # IGS 7.81
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_100-80005374.SAR' # Kernel Part I (785)
      - 'SAPEXEDB_100-80005373.SAR' # Kernel Part II (785), SAP HANA 2.0
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      - 'BW4HANA300_INST_EXPORT_1.zip'
      - 'BW4HANA300_INST_EXPORT_2.zip'
      - 'BW4HANA300_INST_EXPORT_3.zip'
      - 'BW4HANA300_INST_EXPORT_4.zip'
      - 'BW4HANA300_INST_EXPORT_5.zip'
      - 'BW4HANA300_INST_EXPORT_6.zip'
      - 'BW4HANA300_INST_EXPORT_7.zip'
      - 'BW4HANA300_INST_EXPORT_8.zip'
#      - 'BW4HANA300_NW_LANG_EN.SAR'

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006178.EXE'

# For dual host installation, change the sap_swpm_db_host to appropriate value


EOF
}