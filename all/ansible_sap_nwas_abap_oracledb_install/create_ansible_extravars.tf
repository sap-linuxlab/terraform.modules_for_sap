
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
sap_install_media_detect_db: "oracledb"
sap_install_media_detect_swpm: true
sap_install_media_detect_hostagent: true
sap_install_media_detect_igs: true
sap_install_media_detect_kernel: true
sap_install_media_detect_webdisp: false
sap_install_media_detect_export: "sapnwas_abap"
#sap_install_media_detect_backup_directory:
#sap_install_media_detect_backup:



# ---- Mandatory parameters : Oracle DB installation ---- #

sap_anydb_install_oracle_prep_reboot_ok: yes
sap_anydb_install_oracle_prep_fail_if_reboot_required: no
sap_anydb_install_oracle_prep_precheck: no
sap_anydb_install_oracle_method: minimal
sap_anydb_install_oracle_sid: "${var.module_var_sap_anydb_install_sid}"
sap_anydb_install_oracle_base: /oracle
sap_anydb_install_oracle_filesystem_storage: /oradata
sap_anydb_install_oracle_inventory_central: /oraInventory
sap_anydb_install_oracle_system_password: "${var.module_var_sap_swpm_db_system_password}"
#sap_anydb_install_oracle_extract_path: # Use auto-detect from sap_install_media_detect



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
#sap_swpm_db_schema_java: "${var.module_var_sap_swpm_db_schema_abap}"

# Override any variable set in sap_swpm_inifile_dictionary
# Database Passwords
### DBA User
sap_swpm_db_system_password: "${var.module_var_sap_swpm_db_system_password}"
### Database Administrator User
sap_swpm_sap_sidadm_password: "${var.module_var_sap_swpm_db_sidadm_password}"
### DB Schema Password
sap_swpm_db_schema_abap_password: "${var.module_var_sap_swpm_db_schema_abap_password}"

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

  # SAP NetWeaver AS for ABAP 7.52 > Oracle > Installation > Application Server ABAP > Standard System
  sap_nwas_752_sp00_abap_oracledb_onehost:

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:NW752.ORA.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_pas_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_anydb_install_instance_number}"
      sap_swpm_db_schema_abap: "SAPSR3"
      sap_swpm_update_etchosts: 'false'
      sap_swpm_load_type: SAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_oracledb_19
      - credentials
      - credentials_anydb_oracledb
      - db_config_anydb_all
      - db_config_anydb_oracledb
      - db_config_anydb_oracledb_19
      - db_connection_nw_anydb_oracledb
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
      - 'SAPEXEDB_1000-80002605.SAR' # Kernel Part II (753 Patch 1000), Oracle DB
      - 'SAPHOSTAGENT51_51-20009394.SAR'
      - 'SWPM10SP36_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'DBATL740O11_48-80002605.SAR' # DBATOOLS Package for Oracle 11g, 12c and higher, Support Package SAP KERNEL 7.53 64-BIT UNICODE Linux on x86_64 64bit ORACLE
#      - '51047708'   # Oracle 12.1 RDBMS Linux on x86_64 64bit (AKA. Oracle Database 12c Release 1), ZIP. Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_1' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 1/3, RAR EXE (AKA. Oracle Database 12c Release 2). Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_2' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 2/3, RAR. Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_3' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 3/3, RAR. Compatible with RHEL 7.x and SLES 12.x
      - '51053828'   # Oracle 19.0.0.0 RDBMS Linux on x86_64 64bit, ZIP. Compatible with RHEL 7.x/8.x and SLES 12.x/15.x
#      - '51054219'   # Oracle Client 12.1.0.2. Compatible with RHEL 7.x and SLES 12.x
#      - '51054433'   # Oracle 12.2.0.1 Client V2 64bit (All), ZIP. Compatible with RHEL 7.x and SLES 12.x
      - '51055071'   # Oracle 19.0.0.0 RDBMS Client 64bit (All), ZIP (AKA. Oracle Database 19c Base Release). Compatible with RHEL 7.x/8.x and SLES 12.x/15.x
      - '51051806_1' # NetWeaver AS ABAP 7.52 Innovation Pkg - Installation Exp 1/2, RAR
      - '51051806_2' # NetWeaver AS ABAP 7.52 Innovation Pkg - Installation Exp 2/2, RAR

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'


  # SAP NetWeaver 7.5 > Oracle > Installation > Application Server ABAP > Standard System
  sap_nwas_750_sp00_abap_oracledb_onehost:

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:NW750.ORA.ABAP

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_pas_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_anydb_install_instance_number}"
      sap_swpm_db_schema_abap: "SAPSR3"
      sap_swpm_update_etchosts: 'false'
      sap_swpm_load_type: SAP

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_oracledb_19
      - credentials
      - credentials_anydb_oracledb
      - db_config_anydb_all
      - db_config_anydb_oracledb
      - db_config_anydb_oracledb_19
      - db_connection_nw_anydb_oracledb
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
      - 'SAPEXEDB_1000-80002605.SAR' # Kernel Part II (753 Patch 1000), Oracle DB
      - 'SAPHOSTAGENT51_51-20009394.SAR'
      - 'SWPM10SP36_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'DBATL740O11_48-80002605.SAR' # DBATOOLS Package for Oracle 11g, 12c and higher, Support Package SAP KERNEL 7.53 64-BIT UNICODE Linux on x86_64 64bit ORACLE
#      - '51047708'   # Oracle 12.1 RDBMS Linux on x86_64 64bit (AKA. Oracle Database 12c Release 1), ZIP. Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_1' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 1/3, RAR EXE (AKA. Oracle Database 12c Release 2). Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_2' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 2/3, RAR. Compatible with RHEL 7.x and SLES 12.x
#      - '51052773_3' # Oracle 12.2.0.1 RDBMS Linux on x86_64 64bit 3/3, RAR. Compatible with RHEL 7.x and SLES 12.x
      - '51053828'   # Oracle 19.0.0.0 RDBMS Linux on x86_64 64bit, ZIP. Compatible with RHEL 7.x/8.x and SLES 12.x/15.x
#      - '51054219'   # Oracle Client 12.1.0.2. Compatible with RHEL 7.x and SLES 12.x
#      - '51054433'   # Oracle 12.2.0.1 Client V2 64bit (All), ZIP. Compatible with RHEL 7.x and SLES 12.x
      - '51055071'   # Oracle 19.0.0.0 RDBMS Client 64bit (All), ZIP (AKA. Oracle Database 19c Base Release). Compatible with RHEL 7.x/8.x and SLES 12.x/15.x
      - '51050829_3' # SAP Netweaver 7.5 Installation Export, ZIP
#      - '51050829_4' # NW 7.5 Language 1/2
#      - '51050829_5' # NW 7.5 Language 2/2
#      - '51050829_6' # NW 7.5 Upgrade Export Part I 1/2
#      - '51050829_7' # NW 7.5 Upgrade Export Part I 2/2
#      - '51050829_8' # NW 7.5 Upgrade Export Part II 1/2
#      - '51050829_9' # NW 7.5 Upgrade Export Part II 2/2

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'

EOF
}
