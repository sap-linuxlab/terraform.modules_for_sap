
resource "google_filestore_instance" "file_storage_sapmnt" {
  name            = "${var.module_var_resource_prefix}-sapmnt"  // Letters, Numbers, Hyphens only
  location        = var.module_var_gcp_region_zone
  tier            = "BASIC_HDD" // "BASIC_SSD"

  file_shares {
    name          = "${var.module_var_resource_prefix}_sapmnt_share"  // Letters, Numbers, Underscores only
    capacity_gb   = 2048 // 2560  // Minimum GB capacity for the Basic SSD if 2,560GB

    nfs_export_options {
      ip_ranges   = ["${local.target_vpc_subnet_range}"]
      access_mode = "READ_WRITE"
      squash_mode = "NO_ROOT_SQUASH"
    }
  }

  networks {
    network      = basename(local.target_vpc_id)
    modes        = ["MODE_IPV4"]
    connect_mode = "DIRECT_PEERING" # DIRECT_PEERING or PRIVATE_SERVICE_ACCESS
  }

}
