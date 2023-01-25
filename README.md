# Terraform Modules for SAP
[![Terraform Validate Tests](https://github.com/sap-linuxlab/terraform.modules_for_sap/actions/workflows/terraform_validate.yml/badge.svg?branch=main)](https://github.com/sap-linuxlab/terraform.modules_for_sap/actions/workflows/terraform_validate.yml)
[![SAP Software Availability Tests](https://github.com/sap-linuxlab/terraform.modules_for_sap/actions/workflows/terraform_ansible_software_availability.yml/badge.svg?branch=main)](https://github.com/sap-linuxlab/terraform.modules_for_sap/actions/workflows/terraform_ansible_software_availability.yml)

Terraform Modules for SAP are a subcomponent designed to be used from the [Terraform Templates for SAP](https://github.com/sap-linuxlab/terraform.templates_for_sap), but can be executed individually.

These custom Terraform Modules for SAP enable different solution scenarios of SAP software installations, and are used where there is siginificant repeated code, such as bootstraping a new Cloud Account with a new Resource Group, VPC and Subnets - i.e. a 'Minimal Landing Zone'.

Every Terraform Template (e.g. `/sap_hana_single_node_install/aws_ec2_instance`):
- will reference Terraform Modules for SAP infrastructure platforms (e.g. `/aws_ec2_instance/host_provision`)
- will reference Terraform Modules for SAP solution scenarios (e.g. `/all/ansible_sap_s4hana_install_maintplan`)

It is possible to create your own Terraform Templates and re-use [other Terraform Modules from the Terraform Registry](https://registry.terraform.io/browse/modules), although these combinations are not tested; for example:
- Terraform Module for the Cloud Service Provider's defined landing zone patterns (e.g. [Azure Cloud Adoption Framework (CAF)](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest))
- Terraform Module for SAP Host provision to a specified Infrastructure Platform (e.g. `/msazure_vm/host_provision` subdirectory)
- any of the Terraform Modules for SAP installations using Ansible (e.g. `/all/ansible_sap_s4hana_install_maintplan` subdirectory)

For more information which explains Terraform Modules, please see:
- [Terraform HCL Language - Syntax of Module Blocks](https://www.terraform.io/docs/language/modules/syntax.html)
- [Terraform HCL Language - Creating Modules](https://www.terraform.io/docs/language/modules/develop/index.html)

## Parity across all Terraform Modules for SAP

Each Cloud and Hypervisor are not designed the same, each will have different interpretations and implementation of computing concepts.

Additionally, the implementations change over time - whether this is "Previous Generation" environments from a Cloud Service Provider, or a "Major.Minor" version update from a Hypervisor vendor.

Therefore it is not possible to match precisely the same functionality when bootstrapping and installing SAP software. For this reason the bootstrap of an environment is kept separate from existing resources.

In addition, dependant upon the additional configuration and policies within an existing configured environment - these Terraform Modules for SAP may not work at all and may require custom changes to fit the bespoke environment.

Contributions to these Terraform Modules need to retain as much parity across each infrastructure platform.

## Execution time

Please note, for all SAP software installations the execution time will vary based on multiple factors:
- Infrastructure provision time
- Installation media downloads time from SAP.com
- Storage volume used for downloads and database backup files (default is lowest cost / slowest speed when using Cloud IaaS)

## Execution permissions

All detailed execution permissions are listed in the documentation for the Terraform Modules of each Infrastructure Platform. See the next section.

## List of Terraform Modules for SAP

The below table lists the Terraform Modules for SAP, and any detailed documentation:

| **Terraform Modules for SAP** | **Link** |
|:---|:---|
| **TF Modules for Infrastructure Platforms** | - |
| &emsp;Amazon Web Services Elastic Compute Cloud (EC2) Virtual Server | |
| &emsp;~~Google Cloud Platform Compute Engine (CE) Virtual Machine~~ | N/A |
| &emsp;IBM Cloud Virtual Servers | N/A |
| &emsp;IBM Cloud, IBM Power Virtual Servers | |
| &emsp;IBM Power Virtualization Center | N/A |
| &emsp;Microsoft Azure Virtual Machine| N/A |
| &emsp;~~oVirt KVM Virtual Machine~~ | N/A |
| &emsp;VMware vSphere Virtual Machine | [/vmware_vm/host_provision](/docs/tf_modules/tf_mod_vmware_vm_host_provision.md) |
| &emsp;Generic documentation | <ul><li>[**/host_network_access_sap](/docs/tf_modules/tf_mod_host_network_access_sap.md)</li></ul> |
| **TF Modules as wrapper to Ansible for SAP solution scenarios** | - |
| &emsp; SAP BW/4HANA single-node | /all/ansible_sap_bw4hana_install |
| &emsp; SAP ECC on SAP HANA single-node | /all/ansible_sap_ecc_hana_install |
| &emsp; SAP ECC on SAP HANA single-node System Copy<br/>&emsp;  (Homogeneous with SAP HANA Backup / Recovery) | /all/ansible_sap_ecc_hana_system_copy_hdb |
| &emsp; SAP ECC on IBM Db2 single-node | /all/ansible_sap_ecc_ibmdb2_install |
| &emsp; SAP ECC on Oracle DB single-node | /all/ansible_sap_ecc_oracledb_install |
| &emsp; SAP ECC on SAP ASE single-node | /all/ansible_sap_ecc_sapase_install |
| &emsp; SAP ECC on SAP MaxDB single-node | /all/ansible_sap_ecc_sapmaxdb_install |
| &emsp; SAP HANA 2.0 single-node | /all/ansible_sap_hana_install |
| &emsp; SAP NetWeaver AS (ABAP) with SAP HANA single-node | /all/ansible_sap_nwas_abap_hana_install |
| &emsp; SAP NetWeaver AS (ABAP) with IBM Db2 single-node | /all/ansible_sap_nwas_abap_ibmdb2_install |
| &emsp; SAP NetWeaver AS (ABAP) with Oracle DB single-node | /all/ansible_sap_nwas_abap_oracledb_install |
| &emsp; SAP NetWeaver AS (ABAP) with SAP ASE single-node | /all/ansible_sap_nwas_abap_sapase_install |
| &emsp; SAP NetWeaver AS (ABAP) with SAP MaxDB single-node | /all/ansible_sap_nwas_abap_sapmaxdb_install |
| &emsp; SAP NetWeaver AS (JAVA) with IBM Db2 single-node | /all/ansible_sap_nwas_java_ibmdb2_install |
| &emsp; SAP NetWeaver AS (JAVA) with SAP ASE single-node | /all/ansible_sap_nwas_java_sapase_install |
| &emsp; SAP S/4HANA single-node | /all/ansible_sap_s4hana_install |
| &emsp; SAP S/4HANA single-node,<br/>&emsp; using SAP Maintenance Planner Stack XML<br/>&emsp; (to run SUM and SPAM / SAINT) | [/all/ansible_sap_s4hana_install_maintplan](/docs/tf_modules/tf_mod_ansible_sap_s4hana_install_maintplan.md) |
| &emsp; SAP S/4HANA single-node System Copy<br/>&emsp; (Homogeneous with SAP HANA Backup / Recovery) | /all/ansible_sap_s4hana_system_copy_hdb |

## Infrastructure provisioning parity comparison

| Infrastructure Platform | **Amazon Web Services (AWS)** | **Microsoft Azure** | **IBM Cloud** | **IBM Cloud** | **IBM PowerVC** |
|:---|:---:|:---:|:---:|:---:|:---:|
| &emsp;&emsp;*Product* | EC2 Virtual Server | VM | Virtual Server | IBM Power Virtual Server | LPAR |
| &emsp;&emsp;*Compute*<br/>&emsp;&emsp;*Type* | Virtual Machine<br> (Type 1) | Virtual Machine<br> (Type 1) | Virtual Machine<br> (Type 1) | Virtual Machine<br> (Type 1) | Virtual Machine<br> (Type 1) |
| &emsp;&emsp;*Compute*<br/>&emsp;&emsp;*Hypervisor* | KVM | HyperV | KVM | IBM PowerVM<br> (PHYP LE) | IBM PowerVM<br> (PHYP LE) |
| <br/><br/>***Account Init*** |   |   |   |   |   |
| Create Resource Group, or re-use existing Resource Group | :x: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create VPC/VNet, or re-use existing VPC/VNet | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Subnet, or re-use existing Subnet | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Many-to-One NAT Gateway (Public Internet access for hosts) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| <br/>***Account Bootstrap<br/>(aka. minimal landing zone)*** |   |   |   |   |   |
| Create Private DNS | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Network Interconnectivity hub (e.g. Transit Gateway) | :white_check_mark: | :x: | :white_check_mark: | :white_check_mark: | N/A |
| Create Network Security for Subnet/s (e.g. ACL, NSG) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Network Security for Host/s (e.g. Security Groups) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create TLS key pair for SSH (using RSA algorithm) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Import public key to Cloud platform | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| <br/>***Account IAM*** |   |   |   |   |   |
| Create IAM Access Group/s and contained Policies | :x: | :x: | :warning: WIP | :x: | N/A |
| <br/>***Bastion Injection*** |   |   |   |   |   |
| Find OS Image | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Subnet for Bastion (using small CIDR prefix) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Network Security for Host/s connection from Bastion (e.g. Security Groups) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Network Security for Bastion (e.g. Security Groups) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Public IP address for Bastion | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Bastion host | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Build scripts for Bastion host:<br>     - Create OS User for bastion access<br>     - Amend SSH Authorized Keys of OS User for bastion access<br>     - Activate firewalld<br>     - Change SSH Port to within IANA Dynamic Ports range<br>     - Update SELinux of port change<br>     - Deny root login from Public IP | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| <br/>***Host Network Access for SAP*** |   |   |   |   |   |
| Append Network Security rules for SAP (e.g. Security Group Rules)<br>     - SAP NetWeaver AS (ABAP)<br>     - SAP NetWeaver AS (JAVA)<br>     - SAP HANA<br>     - SAP HANA XSA<br>     - SAP Web Dispatcher | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| <br/>***Proxy interconnect provision for increased security hosts*** |   |   |   |   |   |
| Find OS Image | N/A | N/A | N/A | :white_check_mark: | N/A |
| Create Proxy host | N/A | N/A | N/A | :white_check_mark: | N/A |
| Create DNS Records (i.e. A, CNAME, PTR) | N/A | N/A | N/A | :white_check_mark: | N/A |
| Build scripts for Bastion host:<br>     - Setup BIND/named for DNS Proxy<br>     - Setup Squid for Web Forward Proxy<br>     - Setup Nginx for Web Reverse Proxy | N/A | N/A | N/A | :white_check_mark: | N/A |
| <br/>***Host Provision*** |   |   |   |   |   |
| Find OS Image with SAP-relevant OS   Package Repositories | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark:<br/><sub>clone from Stock OS Image</sub> | :white_check_mark: |
| Create DNS Records (i.e. A, CNAME, PTR) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | N/A |
| Create Storage Volumes (defined storage   profile with IOPS/GB, or custom IOPS) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:<br/><sub>no custom IOPS</sub> | :white_check_mark: |
| Create Host/s | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Attach Storage Volumes to Host/s | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Build scripts for Host:<br>     - Enable root login<br>     - Set hostname<br>     - Set DNS in resolv.conf<br>     - Disks and Filesystem setup (LVM with XFS and striping, or Physical with XFS) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Build scripts for increased security Hosts:<br>     - Set DNS Proxy in resolv.conf<br>     - Set Web Proxy for non-interactive login shell | N/A | N/A | N/A | :white_check_mark: | :white_check_mark: |
| Build scripts for BYOL OS:<br>     - Enable OS Subscription with BYOL, setup OS Package Repositories | N/A | N/A | N/A | :white_check_mark: | :white_check_mark: |
