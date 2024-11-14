
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
# sap_install_media_detect_** variables are set for each Ansible Task



# ---- Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input_prefix: "${var.module_var_sap_swpm_template_selected}" # sap_solman_72_sr2_sapase_onehost

# Override any variable set in sap_swpm_inifile_dictionary
# NW Passwords
sap_swpm_master_password: "${var.module_var_sap_swpm_master_password}"
sap_swpm_ddic_000_password: "${var.module_var_sap_swpm_ddic_000_password}"

# Override any variable set in sap_swpm_inifile_dictionary
# Database Passwords
### Database System User
sap_swpm_db_schema_abap_password: "${var.module_var_sap_swpm_db_schema_abap_password}"
sap_swpm_db_sidadm_password: "${var.module_var_sap_swpm_db_sidadm_password}"
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
sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
sap_swpm_update_etchosts: 'false'



# ---- Mandatory parameters : Ansible Dictionary for SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

# Templates and default values
sap_swpm_templates_install_dictionary:


  # SAP Solution Manager 7.2 Support Release 2 > SAP Solution Manager 7.2 ABAP Support Release 2 > SAP ASE > Installation > Application Server ABAP > Standard System > Standard System
  sap_solman_72_sr2_sapase_onehost_abap:

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:SOLMAN72SR2.ABAP.SYB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "SMA"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_anydb_install_instance_number}"
      sap_swpm_db_schema_abap: "${var.module_var_sap_swpm_db_schema_abap}"
      sap_swpm_load_type: SAP
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_ume_j2ee_admin_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_update_etchosts: 'false'

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
      - nw_config_java_ume
      - nw_config_ports
      - nw_config_java_ume
      - nw_config_host_agent
      - sap_os_linux_user
      - solman_credentials_swpm1
      - solman_abap_swpm1

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SWPM10SP42_1-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      - '51054655_1' # SAP Solution Manager 7.2 SR2 Installation Export I, ZIP. Contains EXP1, EXP2 (SAP:SOLMAN:SR27.2:DVD_EXPORT(1/2):SAP SOLUTION MANAGER 7.2 SR2 Installation Export DVD 1/2:Dxxxxxxxx_1)
      - '51054655_2' # SAP Solution Manager 7.2 SR2 Installation Export II, ZIP. Contains EXP3, EXP4 (SAP:SOLMAN:SR27.2:DVD_EXPORT(2/2):SAP SOLUTION MANAGER 7.2 SR2 Installation Export DVD 2/2:Dxxxxxxxx_2)
#      - '51054655_3' # SAP Solution Manager 7.2 SR2 Language, ZIP. (SAP:SAP:SAP:MM:SAP:Dxxxxxxxx_3)
      - '51056521_1' # SAP ASE 16.0.04.04 RDBMS Linux on x86_64 64bit
      - 'ASEBC16004P_3-20012477.SAR' # SAP ASE 16.0 FOR BUS. SUITE DBCLIENT SP04 PL02
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753 Patch 1000)
      - 'SAPEXEDB_1000-80002616.SAR' # Kernel Part II (753 Patch 1000), SAP ASE 16.0 FOR BUS. SUITE
#      - '51051806_1' # NetWeaver AS ABAP 7.52 Innovation Pkg - Installation Exp 1/2, RAR
#      - '51051806_2' # NetWeaver AS ABAP 7.52 Innovation Pkg - Installation Exp 2/2, RAR

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'


  # SAP Solution Manager 7.2 Support Release 2 > SAP Solution Manager 7.2 Java Support Release 2 > SAP ASE > Installation > Application Server Java > Standard System > Standard System
  sap_solman_72_sr2_sapase_onehost_java:

    sap_swpm_product_catalog_id: NW_Java_OneHost:SOLMAN72SR2.JAVA.SYB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "SMJ"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_anydb_install_sid}"
      sap_swpm_load_type: SAP
      sap_swpm_ascs_instance_nr: "01" # NW ABAP ASCS
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_nwas_java_instance_nr}" # NW JAVA re-uses param NW_CI_Instance.ciInstanceNumber
      sap_swpm_ume_instance_nr: "${var.module_var_sap_swpm_nwas_java_instance_nr}"
      sap_swpm_java_scs_instance_nr: "21"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_hostname: "${var.module_var_hostname}" # NW JAVA re-uses param NW_CI_Instance.ciVirtualHostname
      sap_swpm_java_scs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_ume_j2ee_admin_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_ume_sapjsf_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_ume_type: db # db, abap
      sap_swpm_update_etchosts: 'false'

    sap_swpm_inifile_list:
      - swpm_installation_media
      - swpm_installation_media_swpm1_exportfiles
      - swpm_installation_media_swpm1_sapase
      - credentials
      - credentials_anydb_sapase
      - db_config_anydb_sapase
      - nw_config_anydb
      - nw_config_other
      - nw_config_central_services_abap
      - nw_config_central_services_java
      - nw_config_primary_application_server_instance
      - nw_config_java_ume
      - nw_config_ports
      - nw_config_host_agent
      #- sap_os_linux_user # Ignore, and SAP SWPM will auto-assign UID and GID
      - solman_credentials_swpm1
      - nw_config_java_feature_template_ids

    sap_swpm_java_template_id_selected_list:
      - java_solman

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SWPM10SP42_1-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      #- 'SAPJVM8_90-80000202.SAR' # SAP JVM 8.1 PL 90
      - 'SAPJVM8_63-80000202.SAR' # SAP JVM 8.1 PL 63. See SAP Note 1680045 for 3 updates on SEP 17, 2020 related to SAP NetWeaver 7.5 JAVA before SP22 - "SAPJVM 8.1 archive you use has a patch level of 63 or lower"
      - '51054655_4' # SAP Solution Manager 7.2 SR2 - Java, ZIP. Uses SAP Netweaver 7.5 SP19 JAVA. Contains SOLMAN72_JAVA_UT (SAP:UT_SOLMAN:SR2SOLMAN72:SP00:*:*), JAVA_EXPORT (SAP:JEXPORT:SR2_72SOLMAN_2020S4:*:*:*), JAVA_EXPORT_JDMP (SAP:JDMP:SR2_72SOLMAN_2020S4:*:*:*), JAVA_J2EE_OSINDEP (SAP:J2EE-CD:SR2_72SOLMAN_2020S4:J2EE-CD:j2ee-cd:*), JAVA_J2EE_OSINDEP_J2EE_INST (SAP:J2EE-INST:SR2_72SOLMAN_2020S4:*:*:*), JAVA_J2EE_OSINDEP_UT (SAP:UT:SR2_72SOLMAN_2020S4:*:*:*)
      - '51056521_1' # SAP ASE 16.0.04.04 RDBMS Linux on x86_64 64bit
      - 'ASEBC16004P_3-20012477.SAR' # SAP ASE 16.0 FOR BUS. SUITE DBCLIENT SP04 PL02
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753 Patch 1000)
      - 'SAPEXEDB_1000-80002616.SAR' # Kernel Part II (753 Patch 1000), SAP ASE 16.0 FOR BUS. SUITE

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'


sap_storage_setup_sid: "${var.module_var_sap_swpm_sid}"

# hana_primary, hana_secondary, nwas_abap_ascs, nwas_abap_ers, nwas_abap_pas, nwas_abap_aas, nwas_java_scs, nwas_java_ers
sap_storage_setup_host_type:
  - nwas_abap_ascs
  - nwas_abap_pas

# Use Ansible Task to convert JSON (as string) to sap_storage_setup_definition Dictionary
terraform_host_specification_storage_definition: "{{ '${replace(jsonencode(var.module_var_terraform_host_specification_storage_definition),"\"","\\\"")}' | from_json }}"

EOF
}
