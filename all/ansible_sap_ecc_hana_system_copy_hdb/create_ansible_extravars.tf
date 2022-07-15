
# Use path object to store key files temporarily in module of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "ansible_extravars" {
  filename        = "${path.root}/tmp/${var.module_var_hostname}/ansible_vars.yml"
  file_permission = "0755"
  content         = <<EOF
#ansible_python_interpreter: python3

dry_run_test: "${var.module_var_dry_run_test}"

sap_swpm_ansible_role_mode: default_templates
sap_swpm_templates_product_input: "${var.module_var_sap_swpm_template_selected}"

suser_id: "${var.module_var_sap_id_user}"
suser_password: '${var.module_var_sap_id_user_password}'

softwarecenter_search_list_ecc_syscopy_x86_64:
  - 'SAPCAR_1115-70006178.EXE'
  - 'IMDB_SERVER20_059_4-80002031.SAR'
  - 'IMDB_LCAPPS_2059_0-20010426.SAR'
  - 'IMDB_AFL20_059_0-80001894.SAR'
  - 'VCH202000_2059_0-80005463.SAR'
  - 'SWPM10SP35_3-20009703.SAR'
  - 'igsexe_12-80003187.sar'
  - 'igshelper_17-10010245.sar'
  - 'SAPEXE_800-80002573.SAR'
  - 'SAPEXEDB_800-80002572.SAR'
  - 'IMDB_CLIENT20_007_26-80002082.SAR'
  - 'SAPHOSTAGENT51_51-20009394.SAR'

softwarecenter_search_list_ecc_syscopy_ppc64le:
  - 'SAPCAR_1115-70006238.EXE'
  - 'IMDB_SERVER20_059_4-80002046.SAR'
  - 'IMDB_LCAPPS_2059_0-80002183.SAR'
  - 'IMDB_AFL20_059_0-80002045.SAR'
  - 'VCH202000_2059_0-80005464.SAR'
  - 'SWPM10SP35_3-70002492.SAR'
  - 'igsexe_12-80003246.sar'
  - 'igshelper_17-10010245.sar'
  - 'SAPEXE_800-80002630.SAR'
  - 'SAPEXEDB_800-80002629.SAR'
  - 'IMDB_CLIENT20_007_26-80002095.SAR'
  - 'SAPHOSTAGENT51_51-70002261.SAR'

sap_install_media_detect_directory: "${var.module_var_sap_software_download_directory}"



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



# ------ Mandatory parameters : SAP SWPM installation using Defaults Templates mode of the Ansible Role ------ #

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


# Templates and default values
sap_swpm_templates_install_dictionary:

  sap_ecc6_ehp7_hana_onehost_system_copy:
    sap_swpm_product_catalog_id: NW_ABAP_OneHost:BS2013SR2.ERP607SR2.HDB.CP
    sap_swpm_inifile_list:
    - installation_media
    - installation_media_swpm1
    - credentials
    - db_hana_config
    - db_hana_restore
    - db_hana_nw_connection
    - nw_other_config
    - nw_central_instance
    - nw_instance_config
    - nw_ports_config
    - unix_user
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
      sap_swpm_backup_location: "${var.module_var_sap_hana_backup_directory}"
      sap_swpm_backup_prefix: "${var.module_var_sap_hana_backup_filename_prefix}"
      sap_swpm_backup_system_password: "${var.module_var_sap_swpm_backup_system_password}"
      #sap_swpm_cd_rdms_path:
      sap_swpm_load_type: HBR


EOF
}
