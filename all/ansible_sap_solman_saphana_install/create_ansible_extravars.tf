
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
# sap_install_media_detect_** variables are set for each Ansible Task



# ------ Mandatory parameters : SAP HANA installation ------ #

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



# ---- Mandatory parameters : SAP SWPM installation using Default Templates mode of the Ansible Role ---- #

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input_prefix: "${var.module_var_sap_swpm_template_selected}" # sap_solman_72_sr2_saphana_onehost

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


  # SAP Solution Manager 7.2 Support Release 2 > SAP Solution Manager 7.2 ABAP Support Release 2 > SAP HANA > Installation > Application Server ABAP > Standard System > Standard System
  sap_solman_72_sr2_saphana_onehost_abap:

    sap_swpm_product_catalog_id: NW_ABAP_OneHost:SOLMAN72SR2.ABAP.HDB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "SMA"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"
      sap_swpm_db_schema_abap: "SAPABAP1"
      sap_swpm_load_type: SAP
      sap_swpm_ascs_instance_nr: "${var.module_var_sap_swpm_ascs_instance_nr}"
      sap_swpm_pas_instance_nr: "${var.module_var_sap_swpm_pas_instance_nr}"
      sap_swpm_ascs_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_pas_instance_hostname: "${var.module_var_hostname}"
      sap_swpm_ume_j2ee_admin_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_update_etchosts: 'false'

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
      - nw_config_java_ume
      - nw_config_ports
      - nw_config_host_agent
      - sap_os_linux_user
      - solman_credentials_swpm1
      - solman_abap_swpm1

    softwarecenter_search_list_x86_64:
      - 'SAPCAR_1115-70006178.EXE'
      - 'SWPM10SP38_3-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      - '51054655_1' # SAP Solution Manager 7.2 SR2 Installation Export I, ZIP. Contains EXP1, EXP2 (SAP:SOLMAN:SR27.2:DVD_EXPORT(1/2):SAP SOLUTION MANAGER 7.2 SR2 Installation Export DVD 1/2:Dxxxxxxxx_1)
      - '51054655_2' # SAP Solution Manager 7.2 SR2 Installation Export II, ZIP. Contains EXP3, EXP4 (SAP:SOLMAN:SR27.2:DVD_EXPORT(2/2):SAP SOLUTION MANAGER 7.2 SR2 Installation Export DVD 2/2:Dxxxxxxxx_2)
    #  - '51054655_3' # SAP Solution Manager 7.2 SR2 Language, ZIP. (SAP:SAP:SAP:MM:SAP:Dxxxxxxxx_3)
      - 'IMDB_SERVER20_067_2-80002031.SAR'
      - 'IMDB_CLIENT20_015_22-80002082.SAR'
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753)
      - 'SAPEXEDB_1000-80002572.SAR' # Kernel Part II (753), SAP HANA

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'


  # SAP Solution Manager 7.2 Support Release 2 > SAP Solution Manager 7.2 Java Support Release 2 > SAP HANA > Installation > Application Server Java > Standard System > Standard System
  sap_solman_72_sr2_saphana_onehost_java:

    sap_swpm_product_catalog_id: NW_Java_OneHost:SOLMAN72SR2.JAVA.HDB.PD

    sap_swpm_inifile_dictionary:
      sap_swpm_sid: "SMJ"
      sap_swpm_fqdn: "${var.module_var_dns_root_domain_name}"
      sap_swpm_db_host: "${var.module_var_hostname}"
      sap_swpm_db_sid: "${var.module_var_sap_hana_install_sid}"
      sap_swpm_db_instance_nr: "${var.module_var_sap_hana_install_instance_number}"
      sap_swpm_db_schema_abap: "SAPABAP1"
      sap_swpm_db_schema_java: "SAPJAVA1"
      sap_swpm_db_schema: "SAPABAP1"
      sap_swpm_db_schema_password: "${var.module_var_sap_swpm_master_password}"
      sap_swpm_db_schema_java_password: "${var.module_var_sap_swpm_master_password}"
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
      - swpm_installation_media_swpm1
      - swpm_installation_media_swpm1_exportfiles
      - credentials
      - credentials_hana
      - db_config_hana
      - db_connection_nw_hana
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
      - 'SWPM10SP38_3-20009701.SAR'
      - 'igsexe_13-80003187.sar' # IGS 7.53
      - 'igshelper_17-10010245.sar'
      - 'SAPHOSTAGENT56_56-80004822.SAR' # SAP Host Agent 7.22
      #- 'SAPJVM8_90-80000202.SAR' # SAP JVM 8.1 PL 90
      - 'SAPJVM8_63-80000202.SAR' # SAP JVM 8.1 PL 63. See SAP Note 1680045 for 3 updates on SEP 17, 2020 related to SAP NetWeaver 7.5 JAVA before SP22 - "SAPJVM 8.1 archive you use has a patch level of 63 or lower"
      - '51054655_4' # SAP Solution Manager 7.2 SR2 - Java, ZIP. Uses SAP Netweaver 7.5 SP19 JAVA. Contains SOLMAN72_JAVA_UT (SAP:UT_SOLMAN:SR2SOLMAN72:SP00:*:*), JAVA_EXPORT (SAP:JEXPORT:SR2_72SOLMAN_2020S4:*:*:*), JAVA_EXPORT_JDMP (SAP:JDMP:SR2_72SOLMAN_2020S4:*:*:*), JAVA_J2EE_OSINDEP (SAP:J2EE-CD:SR2_72SOLMAN_2020S4:J2EE-CD:j2ee-cd:*), JAVA_J2EE_OSINDEP_J2EE_INST (SAP:J2EE-INST:SR2_72SOLMAN_2020S4:*:*:*), JAVA_J2EE_OSINDEP_UT (SAP:UT:SR2_72SOLMAN_2020S4:*:*:*)
      - 'IMDB_SERVER20_067_2-80002031.SAR'
      - 'IMDB_CLIENT20_015_22-80002082.SAR'
      - 'SAPEXE_1000-80002573.SAR' # Kernel Part I (753)
      - 'SAPEXEDB_1000-80002572.SAR' # Kernel Part II (753), SAP HANA

    softwarecenter_search_list_ppc64le:
      - 'SAPCAR_1115-70006238.EXE'

EOF
}
