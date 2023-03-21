
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

# Configuration of Ansible Roles for preconfigure SAP (general, netweaver)
sap_general_preconfigure_modify_etc_hosts: false
sap_general_preconfigure_reboot_ok: yes
sap_general_preconfigure_fail_if_reboot_required: no
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
sap_install_media_detect_db: "sapase"
sap_install_media_detect_swpm: true
sap_install_media_detect_hostagent: true
sap_install_media_detect_igs: true
sap_install_media_detect_kernel: true
sap_install_media_detect_webdisp: false
#sap_install_media_detect_backup_directory:
#sap_install_media_detect_backup:



# ---- Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input: "${var.module_var_sap_swpm_template_selected}"



# ------ Mandatory parameters : Overrides for SAP SWPM installation using Default Templates mode of the Ansible Role ------ #

# Override any variable set in sap_swpm_inifile_dictionary
# NW Passwords
sap_swpm_master_password: "${var.module_var_sap_swpm_master_password}"
sap_swpm_ddic_000_password: "${var.module_var_sap_swpm_ddic_000_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# Database Configuration
sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"

# Override any variable set in sap_swpm_inifile_dictionary
# Database Passwords
### Database System User
sap_swpm_db_system_password: "${var.module_var_sap_swpm_db_system_password}"
### Database Administrator User
sap_swpm_sap_sidadm_password: "${var.module_var_sap_swpm_db_sidadm_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# Unix User ID
sap_swpm_sapadm_uid: '3000'
sap_swpm_sapsys_gid: '3001'
sap_swpm_sidadm_uid: '3001'

# Override any variable set in sap_swpm_inifile_dictionary
# Other
sap_swpm_update_etchosts: 'false'



# ---- Mandatory parameters : Ansible Dictionary for SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

# Templates and default values
sap_swpm_templates_install_dictionary:

  # SAP Business Suite 7i 2016 > EHP8 for SAP ERP 6.0 ABAP > SAP ASE > Installation > Application Server ABAP > Standard System > Standard System
  # uses SAP NetWeaver 7.5
  sap_ecc6_ehp8_sapase_onehost:

    sap_install_media_detect_export: "sapecc"

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2016.ERP608.SYB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_anydb_install_instance_number}"
      sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"
      sap_swpm_update_etchosts: 'false'
      sap_swpm_load_type: SAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_sapase
      - credentials
      - credentials_anydb_sapase
      - db_config_anydb_all
      - db_config_anydb_sapase
      - nw_config_anydb
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753 Patch 1000)
      - 'SAPEXEDB_1000-80002616.SAR' # Kernel Part II (753 Patch 1000), SAP ASE 16.0 FOR BUS. SUITE
      - 'SAPHOSTAGENT51_51-20009394.SAR'
      - 'SWPM10SP37_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SYBCTRL_1110-80002616.SAR'
      - '51056224_1' # SAP ASE 16.0.03.13 RDBMS Linux on x86_64 64bit
      - 'ASEBC16004P_3-20012477.SAR' # SAP ASE 16.0 FOR BUS. SUITE DBCLIENT SP04 PL03
      - '51050708_1' # SAP ERP 6.0 EHP8 Installation Export 1/4, Self-extract RAR EXE
      - '51050708_2'
      - '51050708_3'
      - '51050708_4'
#      - '51050610_1' # SAP ERP 6.0 EHP8 Language I 1/3, Self-extract RAR EXE
#      - '51050610_2'
#      - '51050610_3'
#      - '51050610_4' # SAP ERP 6.0 EHP8 Language II 1/2, Self-extract RAR EXE
#      - '51050610_5'
#      - '51050610_6' # SAP ERP 6.0 EHP8 Language III, ZIP
#      - '51050610_16' # SAP ERP 6.0 EHP8 SAP Components, ZIP
#      - '51050610_17' # BS7i2016 Java Components - NW 7.5, ZIP

    # Not available for IBM Power Little Endian (ppc64le), leave code to keep similarity of code structure across all Terraform Modules for SAP that wrap Ansible Playbooks
    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'

  # SAP Business Suite 7i 2016 > EHP8 for SAP ERP 6.0 ABAP > SAP ASE > Installation > Application Server ABAP > Standard System > Standard System
  # uses SAP NetWeaver 7.5
  sap_ides_ecc6_ehp8_sapase_onehost:

    sap_install_media_detect_export: "sapecc_ides"

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2016.ERP608.SYB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_anydb_install_instance_number}"
      sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"
      sap_swpm_update_etchosts: 'false'
      sap_swpm_load_type: SAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_sapase
      - credentials
      - credentials_anydb_sapase
      - db_config_anydb_all
      - db_config_anydb_sapase
      - nw_config_anydb
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_primary_application_server_instance
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753 Patch 1000)
      - 'SAPEXEDB_1000-80002616.SAR' # Kernel Part II (753 Patch 1000), SAP ASE 16.0 FOR BUS. SUITE
      - 'SAPHOSTAGENT51_51-20009394.SAR'
      - 'SWPM10SP37_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SYBCTRL_1110-80002616.SAR'
      - '51056224_1' # SAP ASE 16.0.03.13 RDBMS Linux on x86_64 64bit
      - 'ASEBC16004P_3-20012477.SAR' # SAP ASE 16.0 FOR BUS. SUITE DBCLIENT SP04 PL03
      - '51053216_1' # IDES SAP ERP 6.0 EHP8 - INSTALL. EXP. (1/2) 1/22
      - '51053216_2'
      - '51053216_3'
      - '51053216_4'
      - '51053216_5'
      - '51053216_6'
      - '51053216_7'
      - '51053216_8'
      - '51053216_9'
      - '51053216_10'
      - '51053216_11'
      - '51053216_12'
      - '51053216_13'
      - '51053216_14'
      - '51053216_15'
      - '51053216_16'
      - '51053216_17'
      - '51053216_18'
      - '51053216_19'
      - '51053216_20'
      - '51053216_21'
      - '51053216_22'

    # Not available for IBM Power Little Endian (ppc64le), leave code to keep similarity of code structure across all Terraform Modules for SAP that wrap Ansible Playbooks
    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'

EOF
}
