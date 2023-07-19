
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
#sap_install_media_detect_export: # set below
#sap_install_media_detect_backup_directory:
#sap_install_media_detect_backup:



# ------ Mandatory parameters : SAP HANA installation ------ #

# Install directory of SAP HANA must contain:
#   1.  IMDB_SERVER*SAR file
#   2.  IMDB_*SAR files for all SAP HANA components to install
#   3.  SAPCAR executable
#sap_hana_install_software_directory: "${var.module_var_sap_software_download_directory}/sap_hana"

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



# ------ Mandatory parameters : Overrides for SAP SWPM installation using Default Templates mode of the Ansible Role ------ #

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

  # SAP Business Suite 7i 2016 > EHP8 for SAP ERP 6.0 ABAP
  # uses SAP NetWeaver 7.5
  sap_ecc6_ehp8_hana_onehost:

    sap_install_media_detect_export: "sapecc"

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2016.ERP608.HDB.PD

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
      #sap_swpm_cd_rdms_path:
      sap_swpm_load_type: HBR

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1
      - swpm_installation_media_swpm1_exportfiles
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

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'IMDB_SERVER20_059_9-80002031.SAR'
      - 'IMDB_CLIENT20_016_26-80002082.SAR' # SAP HANA Client
      - 'VCH202000_2059_0-80005463.SAR'
      - 'SWPM10SP38_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002573.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002572.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT51_51-20009394.SAR' # SAP Host Agent 7.22
      - 'SUM20SP17_3-80002470.SAR' # SUM 2.0 SP15 Patch 5
      - 'SAPKD75083' # SPAM/SAINT Update - Version 750/0083
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

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'
      - 'IMDB_SERVER20_059_9-80002046.SAR'
      - 'IMDB_CLIENT20_016_26-80002095.SAR' # SAP HANA Client
      - 'VCH202000_2059_0-80005464.SAR'
      - 'SWPM10SP38_2-70002492.SAR'
      - 'igsexe_13-80003246.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002630.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002629.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT58_58-80004831.SAR' # SAP Host Agent 7.22
      - 'SUM20SP17_3-80002470.SAR' # SUM 2.0 SP15 Patch 5
      - 'SAPKD75083' # SPAM/SAINT Update - Version 750/0083
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


  # SAP Business Suite 7i 2016 > EHP8 for SAP ERP 6.0 ABAP
  # uses SAP NetWeaver 7.5
  sap_ides_ecc6_ehp8_hana_onehost:

    sap_install_media_detect_export: "sapecc_ides"

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2016.ERP608.HDB.PD

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
      #sap_swpm_cd_rdms_path:
      sap_swpm_load_type: HBR

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1
      - swpm_installation_media_swpm1_exportfiles
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

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'IMDB_SERVER20_059_9-80002031.SAR'
      - 'IMDB_CLIENT20_016_26-80002082.SAR' # SAP HANA Client
      - 'VCH202000_2059_0-80005463.SAR'
      - 'SWPM10SP38_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002573.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002572.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT51_51-20009394.SAR' # SAP Host Agent 7.22
      - 'SUM20SP17_3-80002470.SAR' # SUM 2.0 SP15 Patch 5
      - 'SAPKD75083' # SPAM/SAINT Update - Version 750/0083
      - '51052029_1' # IDES FOR SAP ERP 6.0 EHP8 - INSTALL. EXP. HANA DB 1/21
      - '51052029_2'
      - '51052029_3'
      - '51052029_4'
      - '51052029_5'
      - '51052029_6'
      - '51052029_7'
      - '51052029_8'
      - '51052029_9'
      - '51052029_10'
      - '51052029_11'
      - '51052029_12'
      - '51052029_13'
      - '51052029_14'
      - '51052029_15'
      - '51052029_16'
      - '51052029_17'
      - '51052029_18'
      - '51052029_19'
      - '51052029_20'
      - '51052029_21'

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'
      - 'IMDB_SERVER20_059_9-80002046.SAR'
      - 'IMDB_CLIENT20_016_26-80002095.SAR' # SAP HANA Client
      - 'VCH202000_2059_0-80005464.SAR'
      - 'SWPM10SP38_2-70002492.SAR'
      - 'igsexe_13-80003246.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002630.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002629.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT58_58-80004831.SAR' # SAP Host Agent 7.22
      - 'SUM20SP17_3-80002470.SAR' # SUM 2.0 SP15 Patch 5
      - 'SAPKD75083' # SPAM/SAINT Update - Version 750/0083
      - '51052029_1' # IDES FOR SAP ERP 6.0 EHP8 - INSTALL. EXP. HANA DB 1/21
      - '51052029_2'
      - '51052029_3'
      - '51052029_4'
      - '51052029_5'
      - '51052029_6'
      - '51052029_7'
      - '51052029_8'
      - '51052029_9'
      - '51052029_10'
      - '51052029_11'
      - '51052029_12'
      - '51052029_13'
      - '51052029_14'
      - '51052029_15'
      - '51052029_16'
      - '51052029_17'
      - '51052029_18'
      - '51052029_19'
      - '51052029_20'
      - '51052029_21'


  # SAP Business Suite 7i 2013 Support Release 2 > EHP7 for SAP ERP 6.0 ABAP Support Release 2
  # uses SAP NetWeaver 7.5
  sap_ecc6_ehp7_hana_onehost:

    sap_install_media_detect_export: "sapecc"

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2013SR2.ERP607SR2.HDB.PD

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
      #sap_swpm_cd_rdms_path:
      sap_swpm_load_type: HBR

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1
      - swpm_installation_media_swpm1_exportfiles
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

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'IMDB_SERVER20_059_9-80002031.SAR'
      - 'IMDB_CLIENT20_016_26-80002082.SAR' # SAP HANA Client
      - 'SWPM10SP38_2-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002573.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002572.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT51_51-20009394.SAR' # SAP Host Agent 7.22 SP58
      - 'SUM11SP01_4-80006800.SAR' # SUM 1.1 SP00 Patch 10
      - 'SAPKD74083' # SPAM/SAINT Update - Version 740/0083
      - '51050036_1' # SAP ERP 6.0 on HANA EHP7 Installation Export 1/18
      - '51050036_2'
      - '51050036_3'
      - '51050036_4'
      - '51050036_5'
      - '51050036_6'
      - '51050036_7'
      - '51050036_8'
      - '51050036_9'
      - '51050036_10'
      - '51050036_11'
      - '51050036_12'
      - '51050036_13'
      - '51050036_14'
      - '51050036_15'
      - '51050036_16'
      - '51050036_17'
      - '51050036_18'

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'
      - 'IMDB_SERVER20_059_9-80002046.SAR'
      - 'IMDB_CLIENT20_016_26-80002095.SAR' # SAP HANA Client
      - 'SWPM10SP38_2-70002492.SAR'
      - 'igsexe_13-80003246.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPEXE_1100-80002630.SAR' # Kernel Part I (753 Patch 1100)
      - 'SAPEXEDB_1100-80002629.SAR' # Kernel Part II (753 Patch 1100), SAP HANA
      - 'SAPHOSTAGENT58_58-80004831.SAR' # SAP Host Agent 7.22 SP58
      - 'SUM11SP01_4-80006861.SAR' # SUM 1.1 SP00 Patch 10
      - 'SAPKD74083' # SPAM/SAINT Update - Version 740/0083
      - '51050036_1' # SAP ERP 6.0 on HANA EHP7 Installation Export 1/18
      - '51050036_2'
      - '51050036_3'
      - '51050036_4'
      - '51050036_5'
      - '51050036_6'
      - '51050036_7'
      - '51050036_8'
      - '51050036_9'
      - '51050036_10'
      - '51050036_11'
      - '51050036_12'
      - '51050036_13'
      - '51050036_14'
      - '51050036_15'
      - '51050036_16'
      - '51050036_17'
      - '51050036_18'

EOF
}
