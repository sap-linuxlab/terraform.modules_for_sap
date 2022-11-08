# Terraform Module - Cloud Service Providers - 

Terraform Module to dynamically open the correct Ports for access to SAP Systems endpoints.

This documentation is `WIP`.


## SAP System networking ports

The following information is a brief summary of [SAP Help Portal - TCP/IP Ports of All SAP Products](https://help.sap.com/viewer/ports).

Depending on the SAP Technical Applications used and the business scenarios being addressed, different hosts will need ports to be opened.

The below table includes some of the key Ports to use with SAP Systems that use SAP NetWeaver and SAP HANA, which depend on the instance number; the instance numbers 00, 01, 02 are the defaults.

| **SAP Technical Application** | **Component** | **Port** |
| --- | --- | --- |
| SAP Router | | |
| | SAP Router | 3200 |
| | SAP Router | 3299 |
| SAP NetWeaver AS ABAP CS,<br/>using Instance Number `01` | | |
| | SAP NetWeaver AS Central Services Messenger Server (ASCS MS) | 36`01` |
| SAP NetWeaver AS ABAP PAS,<br/>using Instance Number `00` | | |
| | `*` SAP NetWeaver AS Primary App Server (PAS Dialog) **[SAP GUI]** | 32`00` |
| | SAP NetWeaver AS PAS Gateway | 33`00` |
| | SAP NetWeaver AS PAS Gateway (with SNC Enabled) | 48`00` |
| | SAP NetWeaver AS ICM HTTP (Port 80 prefix) | 80`00` |
| | `*` SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) **[SAP Web GUI and SAP Fiori Launchpad (HTTPS)]** | 443`00` |
| | SAP NetWeaver sapctrl HTTP _(Dual Host install)_ | 5`00`13 |
| | SAP NetWeaver sapctrl HTTPS _(Dual Host install)_ | 5`00`14 |
| SAP HANA,<br/>using Instance Number `10` | | |
| | SAP HANA sapctrl HTTP _(One Host install)_ | 5`10`13 |
| | SAP HANA sapctrl HTTPS _(One Host install)_ | 5`10`14 |
| | SAP HANA Internal Web Dispatcher | 3`10`06 |
| | SAP HANA indexserver MDC System Tenant SYSDB | 3`10`13 |
| | SAP HANA indexserver MDC Tenant 1 | 3`10`15 |
| | SAP HANA ICM HTTP Internal Web Dispatcher | 80`10` |
| | SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher | 43`10` |
| SAP HANA XSA,<br/>using Instance Number `10` | | |
| | SAP HANA XSA Client HTTPS for the connection to the xscontroller-managed Web Dispatcher (platform router) for purposes of user authentication. | 3`10`32 |
| | SAP HANA XSA Internal HTTPS for the connection from the xscontroller-managed Web Dispatcher (platform router) to xsuaaserver for purposes of user authentication. | 3`10`31 |
| | SAP HANA XSA Client HTTPS for the connection to the xscontroller-managed Web Dispatcher for purposes of data access.  | 3`10`30 |
| | SAP HANA XSA Dynamic Range Internal HTTPS for the connection from the client to the xscontroller-managed Web Dispatcher (Platform Router) for access to the application instance. | 510`10`-515`10` |
| | SAP HANA XSA Internal HTTPS xsexecagent to xscontroller | 3`10`29 |
| | SAP HANA XSA Web Dispatcher HTTP(S) routing | 3`10`33 |
| SAP Web Dispatcher,<br/>using Instance Number `90` | | |
| | SAP Web Dispatcher ICM HTTP (Port 80 prefix) | 80`90` |
| | SAP Web Dispatcher ICM HTTPS (Secure, Port 443 prefix) | 443`90` |
| SAP NetWeaver AS JAVA Central Services (SCS),<br/>using Instance Number `21` | | |
| | SAP NetWeaver AS JAVA Message Server | 81`21` |
| SAP NetWeaver AS JAVA Central Instance (CI) ICM server process 0..n,<br/>using Instance Number `20`<br/>*(+5 on all ports for subsequent server processes)* | | |
| | SAP NetWeaver AS JAVA HTTP port | 5`20`00 |
| | SAP NetWeaver AS JAVA HTTP SSL port | 5`20`01 |
| | SAP NetWeaver AS JAVA IIOP Initial Context port | 5`20`02 |
| | SAP NetWeaver AS JAVA IIOP SSL port | 5`20`03 |
| | SAP NetWeaver AS JAVA P4 and JMS port | 5`20`04 |
| | SAP NetWeaver AS JAVA P4 SSL port | 5`20`05 |
| | SAP NetWeaver AS JAVA IIOP port | 5`20`06 |
| | ~~SAP NetWeaver AS JAVA Telnet port~~ | ~~5`20`07~~ |
| SAP NetWeaver AS JAVA Central Instance (CI) Access server process 0..n,<br/>using Instance Number `20`<br/>*(+5 on all ports for subsequent server processes)* | | |
| | SAP NetWeaver AS JAVA Server Join port | 5`20`20 |
| | SAP NetWeaver AS JAVA Server Debug port | 5`20`21 |
| | SAP NetWeaver AS JAVA Server DSR Infrastructure port | 5`20`22 |
| SAP NetWeaver AS JAVA Central Instance (CI) Administrative Services server process 0,<br/>using Instance Number `20` | | |
| | SAP NetWeaver AS JAVA Admin Start Service HTTP port | 5`20`13 |
| | SAP NetWeaver AS JAVA Admin Start Service HTTPS port | 5`20`14 |
| | SAP NetWeaver AS JAVA Admin SL Controller port/s | 5`20`17-5`20`19 |

`*` Terraform Module

### SAP HANA System Replication

For SAP HANA System Replication, the port offset is +10000 from the SAP HANA indexserver MDC configured ports (e.g. `3<<sap_hana_instance_no>>15` for MDC Tenant #1). This is controlled by the parameter 'replication_port_offset' in the global.ini file.

This replaces the old-style port offset +100, and replaces the additional +1 offset used for SAP HANA with single container/tenant (which is not supported after SAP HANA 2.0 SPS 01).

The SAP HANA System Replication using SAP HANA 2.0 with MDC Tenants port calculations are therefore:

| **SAP Technical Application** | **Component** | **Port** |
| --- | --- | --- |
| SAP HANA Sytem Replication | | |
| | hdbnameserver, used for log and data shipping from a primary site to a secondary site.<br/>System DB port number plus 10,000 | 4`<sap_hana_instance_no>`01 |
| | hdbnameserver, unencrypted metadata communication between sites.<br/>System DB port number plus 10,000 | 4`<sap_hana_instance_no>`02 |
| | hdbnameserver, used for encrypted metadata communication between sites.<br/>System DB port number plus 10,000 | 4`<sap_hana_instance_no>`06 |
| | hdbindexserver, used for first MDC Tenant database schema | 4`<sap_hana_instance_no>`03 |
| | hdbxsengine, used for SAP HANA XSC/XSA | 4`<sap_hana_instance_no>`07 |
| | hdbscriptserver, used for log and data shipping from a primary site to a secondary site.<br/>Tenant port number plus 10,000 | 4`<sap_hana_instance_no>`40-97 |
| | hdbxsengine, used for log and data shipping from a primary site to a secondary site.<br/>Tenant port number plus 10,000 | 4`<sap_hana_instance_no>`40-97 |
| Linux Pacemaker | | |
| | pcsd | 2224 (TCP), cluster nodes requirement for node-to-node communication  |
| | pacemaker | 3121 (TCP), cluster nodes requirement for Pacemaker Remote service daemon |
| | corosync | 5404-5412 (UDP), cluster nodes requirement for node-to-node communcation |


The Ansible Role `sap_ha_install_hana_hsr` assumes these ports are open within the Subnet and on each host OS, otherwise errors such as "unable to contact primary site" will be shown.

Sources:
- [SAP Note 2477204 - FAQ: SAP HANA Services and Ports](https://launchpad.support.sap.com/#/notes/2477204)
- Question 29 on [SAP Note 1999880 - FAQ: SAP HANA System Replication](https://launchpad.support.sap.com/#/notes/1999880)
- [SAP HANA Administration Guide - SAP HANA System Replication with Multi-Tenant Databases (MDC)](https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/d20e1a973df9462fa92149f29ee2c455.html?version=latest)
- [SAP HANA Security Checklists and Recommendations - Recommendations for Network Configuration](https://help.sap.com/docs/SAP_HANA_PLATFORM/742945a940f240f4a2a0e39f93d3e2d4/eccef06eabe545e68d5019bcb6d8e342.html?version=latest)
- [High-Availability cluster with Pacemaker - Enabling ports](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_high_availability_clusters/assembly_creating-high-availability-cluster-configuring-and-managing-high-availability-clusters#proc_enabling-ports-for-high-availability-creating-high-availability-cluster)
