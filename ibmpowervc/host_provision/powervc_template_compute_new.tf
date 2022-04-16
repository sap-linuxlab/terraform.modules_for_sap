
# Create IBM PowerVC LPAR Compute Template
# https://www.ibm.com/docs/en/powervc-cloud/2.0?topic=apis-flavors-extra-specs
resource "openstack_compute_flavor_v2" "powervc_compute_template" {
  count = var.module_var_ibmpowervc_template_compute_name_create_boolean ? 1 : 0

  name      = "${var.module_var_resource_prefix}-compute-template"
  vcpus     = max(format("%.f", (var.module_var_ibmpowervc_compute_cpu_threads / 8)), 4) // Virtual Processors (i.e. IBM Power CPU Cores), Desired
  ram       = (var.module_var_ibmpowervc_compute_ram_gb * 1024) // Memory (MiB), Desired
  disk      = 96
  swap      = 0 // Must be set to 0 otherwise error "failed with exception: Build of instance xxxx was re-scheduled: list index out of range"
  is_public = true

  # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
  extra_specs = {

    # Assume SMT-8, 1 IBM Power CPU Core therefore divide by 8 = CPU Threads

    ####  Virtual Processors (i.e. IBM Power CPU Cores)  ####
    "powervm:min_vcpu" : max(format("%.f", ((var.module_var_ibmpowervc_compute_cpu_threads / 8) * 0.75)), 4) // Virtual Processors (i.e. IBM Power CPU Cores), Minimum (which must be at least 4)
    "powervm:max_vcpu" : format("%.f", (var.module_var_ibmpowervc_compute_cpu_threads / 8) * 1.20)           // Virtual Processors (i.e. IBM Power CPU Cores), Maximum

    ####  Dynamic LPAR Entitled Capacity of Virtual Processor units (i.e. IBM Power CPU Cores guaranteed to be available)  ####
    # Set minimum to 80% of the minimum Virtual Processors (i.e. IBM Power CPU Cores)
    # Set standard to 80% of the Virtual Processors (i.e. IBM Power CPU Cores)
    # Set maximum to 120% of the Virtual Processors (i.e. IBM Power CPU Cores)
    "powervm:min_proc_units" : format("%.f", (((var.module_var_ibmpowervc_compute_cpu_threads / 8) * 0.75) * 0.8))
    "powervm:proc_units" : format("%.f", ((var.module_var_ibmpowervc_compute_cpu_threads / 8) * 0.8))
    "powervm:max_proc_units" : format("%.f", ((var.module_var_ibmpowervc_compute_cpu_threads / 8) * 1.20))

    "powervm:dedicated_proc" : "false"
    "powervm:uncapped" : "true"
    "powervm:shared_weight" : "128"
    "powervm:processor_compatibility" : "default"

    "powervm:min_mem" : format("%.f", ((var.module_var_ibmpowervc_compute_ram_gb * 1024) - (0.25 * (var.module_var_ibmpowervc_compute_ram_gb * 1024)))) // Memory, Minimum
    "powervm:max_mem" : (var.module_var_ibmpowervc_compute_ram_gb * 1024) // Memory, Maximum

    "powervm:enforce_affinity_check" : "true"
    "powervm:enable_lpar_metric" : "true"
    "powervm:availability_priority" : "127" // Default is 127, Higher Priority default is 191
    #"powervm:ppt_ratio": "1:1024"
    "powervm:secure_boot" : "0"

  }

}
