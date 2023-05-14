# Terraform Module - Ansible - SAP Solution Manager (ABAP/JAVA)

Terraform Module to inject Terraform Input Variables into Ansible Extra Vars file, ready for Ansible Playbook execution.

SAP Solution Manager 7.2 installations use an ABAP stack and JAVA stack.

## Installation note regarding SAP JVM

For all installations of SAP NetWeaver 7.5 JAVA before SP22, the SAP JVM 8.1 PL 63 must be used. See SAP Note 1680045 for 3 updates on SEP 17, 2020 related to  - "SAPJVM 8.1 archive you use has a patch level of 63 or lower".

## Installation note regarding SAP users

It is mandatory for the existing ABAP stack to be available prior to the installation of the Java stack, and the Java stack configuration of User Management Eengine (UME).

For example, the Administrator User, the Guest User, and the Communication User must already exist on the ABAP stack, along with the appropriate roles:
- Communication User: SAPJSF -- assign Role SAP_BC_JSF_COMMUNICATION and SAP_SM_S_RFCACL
- Administrator Role: J2EE_ADM_{{ sap_swpm_sid }} -- assign Role SAP_J2EE_ADMIN
- Guest User: J2EE_GST_{{ sap_swpm_sid }} -- assign Role SAP_J2EE_GUEST
