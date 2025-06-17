# CPU Architecture detection

Added flag for IBM Power. With the homogenised approach leveraging 'existing hosts' created by Terraform and execution of the Ansible Playbooks for SAP, there is no Terraform Variable that indicates the hosts are IBM Power.


# Alternative data conversion

Data conversion from Terraform Map of host specifications, to a Python (Ansible) Dictionary can be achieved instead using Jinja:

```yaml
    # For end user ease of use, the host specifications dictionary uses disk_count to indicate how many disks will be provisioned
    # However the sap_storage_setup Ansible Role can not detect disk_count, and requires the key to be renamed lvm_lv_stripes
    - name: Convert sap_vm_provision_*_host_specifications_dictionary.storage_definition to sap_storage_setup.sap_storage_setup_definition
      ansible.builtin.set_fact:
        sap_storage_setup_definition: "{{ sap_storage_setup_definition | default([]) + [converted_element] }}"
      vars:
        converted_element: |
          {% set current_element = (convert_item | dict2items) %}
          {% set new_element = [] %}
          {% for entry in current_element %}
            {%- if "disk_count" in entry.key %}
              {%- set conv = new_element.extend([
                {
                  'key': 'lvm_lv_stripes',
                  'value': entry.value,
                }
              ]) %}
            {%- elif not "disk_type" in entry.key %}
              {%- set add_entry = new_element.extend([
                {
                  'key': entry.key,
                  'value': entry.value,
                }
              ]) %}
            {%- endif -%}
          {% endfor %}
          {{ new_element | items2dict }}
      loop: "{{ terraform_host_specification_storage_definition | list }}"
      # loop: "{{ terraform_host_specification[inventory_hostname]['storage_definition'] | list }}"
      loop_control:
        loop_var: convert_item
        label: "{{ convert_item.name }}"
```
