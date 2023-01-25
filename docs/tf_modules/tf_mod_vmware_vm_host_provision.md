# Terraform Module - VMware Virtual Machine

## VMware VM Template setup

- **OS Image with cloud-init installed**
  - Edit the default cloud-init configuration file, found at `/etc/cloud`. It must contain the data source for VMware (and not OVF), and force use of cloud-init metadata and userdata files.
  ```
  disable_vmware_customization: true
  datasource:
    VMware:
      allow_raw_data: true
      vmware_cust_file_max_wait: 10 # seconds
  ```
  - Prior to VM shutdown and marking as a VMware VM Template, run command `vmware-toolbox-cmd config set deployPkg enable-custom-scripts true`
  - Prior to VM shutdown and marking as a VMware VM Template, run command `sudo cloud-init clean --seed --logs --machine-id` to remove cloud-init logs, remove cloud-init seed directory /var/lib/cloud/seed , and remove /etc/machine-id. If using cloud-init versions prior to 22.3.0 then do not use `--machine-id` parameter
  - Once VM is shutdown, then run 'Convert to VM Template'
  - Debug by checking `grep userdata /var/log/vmware-imc/toolsDeployPkg.log` and `/var/log/cloud-init.log`
  - See documentation for further information:
    - VMware KB 59557 - How to switch vSphere Guest OS Customization engine for Linux virtual machine (https://kb.vmware.com/s/article/59557)
    - VMware KB 74880 - Setting the customization script for virtual machines in vSphere 7.x and 8.x (https://kb.vmware.com/s/article/74880)
    - cloud-init documentation - Reference - Datasources - VMware (https://cloudinit.readthedocs.io/en/latest/reference/datasources/vmware.html)


## VMware vCenter and vSphere clusters with VMware NSX virtualized network overlays

For VMware vCenter and vSphere clusters with VMware NSX virtualized network overlays using Segments (e.g. 192.168.0.0/16) connected to Tier-0/Tier-1 Gateways (which are bound to the backbone network subnet, e.g. 10.0.0.0/8), the following are required:

- **CRITICAL: Routable access from host executing Terraform Template for SAP (and thereby Ansible subsequently triggered by the Terraform Template)**. For example, if the Terraform Template for SAP is executed on a macOS laptop running a VPN with connectivity to the VMware vCenter - then the VPN must also have access to the provisioned Subnet, otherwise initialised SSH connections to the VMware VM from Terraform and Ansible will not be successful.
  - It is recommended to investigate proper DNAT configuration for any VMware NSX Segments (this could be automated using Terraform Provider for VMware NSX-T, i.e. https://registry.terraform.io/providers/vmware/nsxt/latest/docs/resources/policy_nat_rule).
- **DHCP Server** must be created (e.g. NSX > Networking > Networking Profiles > DHCP Profile), set in the Gateway (e.g. NSX > Networking > Gateway > Edit > DHCP Config > ), then set for the Subnet (e.g. NSX > Networking > Segment > <<selected subnet>> > Set DHCP Config) which the VMware VM Template is attached to; this allows subsequent cloned VMs to obtain an IPv4 Address
- **Internet Access**: Option 1 - Configured SNAT (e.g. rule added on NSX Gateway) set for the Subnet which the VMware VM Template is attached to; this allows Public Internet access. Option 2 - Web Proxy.
- **DNS Server (Private)** is recommended to assist custom/private root domain resolution (e.g. poc.cloud)


## VMware vCenter and vSphere clusters with direct network subnet IP allocation

For VMware vCenter and vSphere clusters with direct network subnet IP allocations to the VMXNet network adapter (no VMware NSX network overlays), the following are required:

- **CRITICAL: Routable access from host executing Terraform Template for SAP (and thereby Ansible subsequently triggered by the Terraform Template)**. For example, if the Terraform Template for SAP is executed on a macOS laptop running a VPN with connectivity to the VMware vCenter - then the VPN must also have access to the provisioned Subnet, otherwise initialised SSH connections to the VMware VM from Terraform and Ansible will not be successful.
- **DHCP Server** must be created (e.g. NSX > Networking > Networking Profiles > DHCP Profile), set in the Gateway (e.g. NSX > Networking > Gateway > Edit > DHCP Config > ), then set for the Subnet (e.g. NSX > Networking > Segment > <<selected subnet>> > Set DHCP Config) which the VMware VM Template is attached to; this allows subsequent cloned VMs to obtain an IPv4 Address
- **Internet Access**: Option 1 - Configured SNAT (e.g. rule added on NSX Gateway) set for the Subnet which the VMware VM Template is attached to; this allows Public Internet access. Option 2 - Web Proxy.
- **DNS Server (Private)** is recommended to assist custom/private root domain resolution (e.g. poc.cloud)
