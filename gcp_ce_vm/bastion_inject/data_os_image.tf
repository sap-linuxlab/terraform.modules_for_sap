
# Detect OS Images

# From command line, look for OS Images in the Region for SAP
#gcloud compute images list --format=json --sort-by="~name" --filter="family~sap AND family~rhel" | jq '.[] | [.family, .name, .id]'
#gcloud compute images list --format=json --sort-by="~name" --filter="family~sap AND family~sles" | jq '.[] | [.family, .name, .id]'

# Google Cloud CLI commands debug with --log-http to show the http parsed filter command
#gcloud compute images list --regexp ".*sles.*sp5.*sap.*"
#/images?filter=name+eq+".*(^.*sles.*sp5.*sap.*$).*"
#gcloud compute images list --filter="name~sles.*sp5.*sap"
#/images?filter=name+eq+".*(sles.*sp5.*sap).*"

# Replicating either of these regex commands, do not work and return 0 items
#gcloud compute images list --filter='name eq ".*(^.*sles.*sp5.*sap.*$).*"'
#gcloud compute images list --standard-images --filter='name eq ".*(sles.*sp5.*sap).*"'


# There is no Terraform Resource for data lookup of all GCP OS Images, use family to provide latest of an OS major.minor release

data "google_compute_image" "bastion_os_image" {
  project = var.module_var_bastion_os_image.project // The project must be set to the GCP Marketplace Product owner as the GCP OS 'Public Image Project', e.g. rhel-cloud, rhel-sap-cloud, suse-cloud, suse-sap-cloud
  family  = var.module_var_bastion_os_image.family
}
