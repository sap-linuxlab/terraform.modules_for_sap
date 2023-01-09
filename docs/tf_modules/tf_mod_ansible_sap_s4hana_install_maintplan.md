# Terraform Module - Ansible - SAP S/4HANA installation from SAP Maintenance Planner

Terraform Module to inject Terraform Input Variables into Ansible Extra Vars file, ready for Ansible Playbook execution.

## Default Templates defined for sap_swpm Ansible Role

This Terraform Module uses the Default Templates mode of the sap_swpm Ansible Role. By defining various deployments in the Ansible Extra Vars, Terraform is able to use 1 variable to define the SAP SWPM Product Catalog ID and all parameters to generate the inifile.params for SAP SWPM execution.

These Default Templates are:

| Default Template name | SAP SWPM Product Catalog ID | Description |
| --- | --- | --- |
| `sap_s4hana_2020_onehost_install` | `NW_ABAP_OneHost:S4HANA2020.CORE.HDB.ABAP` | Install SAP S/4HANA 2020 OneHost installation from initial shipment or feature pack versions, using a created plan name from SAP Maintenance Planner with the Stack XML file to run SUM and SPAM / SAINT |
| `sap_s4hana_2021_onehost_install` | `NW_ABAP_OneHost:S4HANA2021.CORE.HDB.ABAP` | Install SAP S/4HANA 2021 OneHost installation from initial shipment or feature pack versions, using a created plan name from SAP Maintenance Planner with the Stack XML file to run SUM and SPAM / SAINT |
| `sap_s4hana_2022_onehost_install` | `NW_ABAP_OneHost:S4HANA2022.CORE.HDB.ABAP` | Install SAP S/4HANA 2022 OneHost installation from initial shipment or feature pack versions, using a created plan name from SAP Maintenance Planner with the Stack XML file to run SUM and SPAM / SAINT |
