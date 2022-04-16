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
| SAP NetWeaver | | |
| | `*` SAP NetWeaver AS Primary App Server (PAS Dialog) Instance `01` **[SAP GUI]** | 32`01` |
| | SAP NetWeaver AS PAS Gateway Instance `01` | 33`01` |
| | SAP NetWeaver AS Central Services Messenger Server (ASCS MS) Instance `02` | 36`02` |
| | SAP NetWeaver AS PAS Gateway (with SNC Enabled) Instance `01` | 48`01` |
| | SAP NetWeaver AS ICM HTTP (Port 80 prefix) Instance Number `01` | 80`01` |
| | `*` SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) Instance Number `01` **[SAP Web GUI and SAP Fiori Launchpad (HTTPS)]** | 443`01` |
| | SAP NetWeaver sapctrl HTTP _(Dual Host install)_ | 5`01`13 |
| | SAP NetWeaver sapctrl HTTPS _(Dual Host install)_ | 5`01`14 |
| SAP HANA | | |
| | SAP HANA sapctrl HTTP _(One Host install)_ | 5`00`13 |
| | SAP HANA sapctrl HTTPS _(One Host install)_ | 5`00`14 |
| | SAP HANA Internal Web Dispatcher | 3`00`06 |
| | SAP HANA indexserver MDC System Tenant SYSDB | 3`00`13 |
| | SAP HANA indexserver MDC Tenant 1 | 3`00`15 |
| | SAP HANA ICM HTTP Internal Web Dispatcher | 80`00` |
| | SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher | 43`00` |
| SAP Web Dispatcher | | |
| | SAP Web Dispatcher ICM HTTP (Port 80 prefix) Instance Number `90` | 80`90` |
| | SAP Web Dispatcher ICM HTTPS (Secure, Port 443 prefix) Instance Number `90` | 443`90` |
| SAP HANA XSA | | |
| | SAP HANA XSA Instance `00` Client HTTPS for the connection to the xscontroller-managed Web Dispatcher (platform router) for purposes of user authentication. | 3`00`32 |
| | SAP HANA XSA Instance `00` Internal HTTPS for the connection from the xscontroller-managed Web Dispatcher (platform router) to xsuaaserver for purposes of user authentication. | 3`00`31 |
| | SAP HANA XSA Instance `00` Client HTTPS for the connection to the xscontroller-managed Web Dispatcher for purposes of data access.  | 3`00`30 |
| | SAP HANA XSA Instance `00` Dynamic Range Internal HTTPS for the connection from the client to the xscontroller-managed Web Dispatcher (Platform Router) for access to the application instance. | 510`00`-515`00` |
| | SAP HANA XSA Instance `00` Internal HTTPS xsexecagent to xscontroller | 3`00`29 |
| | SAP HANA XSA Instance `00` Web Dispatcher HTTP(S) routing | 3`00`33 |
| SAP NetWeaver JAVA | | |
| | SAP NetWeaver AS JAVA P4 Port | 50304 |
| | SAP NetWeaver AS JAVA P4 Port | 50404 |
| | SAP NetWeaver AS JAVA Message Server | 81`01` |

`*` Terraform Module
