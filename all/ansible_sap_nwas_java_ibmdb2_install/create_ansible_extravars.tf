
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
sap_install_media_detect_db: "ibmdb2"
sap_install_media_detect_swpm: true
sap_install_media_detect_hostagent: true
sap_install_media_detect_igs: true
sap_install_media_detect_kernel: true
sap_install_media_detect_webdisp: false
sap_install_media_detect_export: "sapnwas_java"
#sap_install_media_detect_backup_directory:
#sap_install_media_detect_backup:



# ---- Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input: "${var.module_var_sap_swpm_template_selected}"

# Override any variable set in sap_swpm_inifile_dictionary
# NW Passwords
sap_swpm_master_password: "${var.module_var_sap_swpm_master_password}"
sap_swpm_ddic_000_password: "${var.module_var_sap_swpm_ddic_000_password}"

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

  # SAP NetWeaver 7.5 > IBM Db2 for Linux, UNIX, and Windows > Installation > Application Server Java > Standard System > Standard System
  sap_nwas_750_sp22_java_ibmdb2_onehost_ads:

    sap_swpm_product_catalog_id: NW_Java_OneHost:NW750.DB6.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "${var.module_var_sap_swpm_sid}"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_load_type: SAP
      sap_swpm_java_scs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_nwas_java_instance_nr}" # NW JAVA re-uses param NW_CI_Instance.ciInstanceNumber
      sap_swpm_ume_instance_nr: "${var.module_var_sap_swpm_nwas_java_instance_nr}"
      sap_swpm_ume_j2ee_admin_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_ume_sapjsf_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_ume_type: db # db, abap

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_ibmdb2
      - credentials
      - credentials_anydb_ibmdb2
      - db_config_anydb_ibmdb2
      - nw_config_anydb
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_central_services_java
      - nw_config_primary_application_server_instance
      - nw_config_java_ume
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - nw_config_java_feature_template_ids

    sap_swpm_java_template_id_selected_list:
      - java_adobe_document_services

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SWPM10SP36_4-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      - 'SAPJVM8_90-80000202.SAR' # SAP JVM 8.1
      - '51055106' # SAP Netweaver 7.5 SP22 Java, ZIP. Contains JAVA_EXPORT (SAP:JEXPORT:750:SP22:*:*), JAVA_EXPORT_JDMP (SAP:JDMP:750:SP22:*:SW-LABEL), JAVA_J2EE_OSINDEP (SAP:J2EE-CD:750:J2EE-CD:j2ee-cd:*), JAVA_J2EE_OSINDEP_J2EE_INST (SAP:J2EE-INST:750:SP22:*:*), JAVA_J2EE_OSINDEP_UT (SAP:UT:750:SP22:*:*)
      - '51055282' # IBM DB2 FOR LUW 11.5 MP7 FP0 SAP LINUX x86_64, ZIP
      - '73554900102000002424' # IBM DB2 LUW 11.5 SAP OEM license (Note 816773), ZIP
      - '51055284' # IBM DB2 FOR LUW 11.5 MP7 FP0 SAP Client, ZIP
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753 Patch 1000)
      - 'SAPEXEDB_1000-80002603.SAR' # Kernel Part II (753 Patch 1000), IBM DB2

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'

EOF
}
