# Terraform Module - Ansible - SAP S/4HANA installation from SAP Maintenance Planner

Terraform Module to inject Terraform Input Variables into Ansible Extra Vars file, ready for Ansible Playbook execution.

## Default Templates defined for sap_swpm Ansible Role

This Terraform Module uses the Default Templates mode of the sap_swpm Ansible Role. By defining various deployments in the Ansible Extra Vars, Terraform is able to use 1 variable to define all of the SAP SWPM Product Catalog IDs and all parameters to generate the inifile.params for SAP SWPM execution.

The sequence of a Distributed installation is:
- `hdblcm`: Install SAP HANA database server
- `SWPM`: Install SAP NetWeaver Application Server - Central Services (ASCS). This runs the MS and EN.
- `SWPM`: Install Installation Export to Database (i.e. Database Load)
- `SWPM`: OPTIONAL - Install SAP NetWeaver Application Server - Enqueue Replication Services (ERS). This runs the mirrored MS and EN.
- `SWPM`: Install SAP NetWeaver Application Serer - Primary Application Server (PAS); formerly Central Instance (CI). This runs the GW and WP.
- `SWPM`: OPTIONAL - Install SAP NetWeaver Application Server - Additional Application Server (AAS); formerly Dialog Instance (DI). This runs additional WP.

This therefore matches to the SAP SWPM Product ID prefixes that are executed in sequence:
- `NW_ABAP_ASCS`, Central Services Instance for ABAP (ASCS) Installation
- `NW_ABAP_DB`, Database Instance Installation
- `NW_ERS`, Enqueue Replication Server Installation
- `NW_ABAP_CI`, Primary Application Server Instance Installation
- `NW_DI`, Application Server Instance Installation

These Default Templates for the `sap_swpm` Ansible Role are:

| Ansible Role `sap_swpm` Default Template name | SAP SWPM Product Catalog IDs | Description |
| --- | --- | --- |
| `sap_s4hana_2021_distributed` | <ol><li>`NW_ABAP_ASCS:S4HANA2021.CORE.HDB.ABAP`</li><li>`NW_ABAP_DB:S4HANA2021.CORE.HDB.ABAP`</li><li>`NW_ABAP_CI:S4HANA2021.CORE.HDB.ABAP`</li><li>`NW_DI:S4HANA2021.CORE.HDB.PD`</li></ol> | Install SAP S/4HANA 2021 Distributed installation from initial shipment or feature pack versions, using a created plan name from SAP Maintenance Planner with the Stack XML file to run SUM and SPAM / SAINT |
| `sap_s4hana_2022_distributed` | <ol><li>`NW_ABAP_ASCS:S4HANA2022.CORE.HDB.ABAP`</li><li>`NW_ABAP_DB:S4HANA2022.CORE.HDB.ABAP`</li><li>`NW_ABAP_CI:S4HANA2022.CORE.HDB.ABAP`</li><li>`NW_DI:S4HANA2022.CORE.HDB.PD`</li></ol> | Install SAP S/4HANA 2022 Distributed installation from initial shipment or feature pack versions, using a created plan name from SAP Maintenance Planner with the Stack XML file to run SUM and SPAM / SAINT |
