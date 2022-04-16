
# Detect AMI
# The AMI for the OS, changes per AWS Region

# From command line look for RHEL 8.x images in the Region (defined in aws configure). Search is case-sensitive
# aws ec2 describe-images --filters 'Name=name,Values=*SAP-7.6*' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*RHEL-SAP-7.7*' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*RHEL-SAP-7.9*' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*RHEL-8.1.0-SAP*' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*RHEL-8.2.0-SAP*' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'

# From command line look for SLES 15.x images in the Region (defined in aws configure). Search is case-sensitive
# aws ec2 describe-images --filters 'Name=name,Values=*suse-sles-12-sp5-v202*-hvm-ssd-x86_64' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*suse-sles-15-sp1-v202*-hvm-ssd-x86_64' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*suse-sles-15-sp2-v202*-hvm-ssd-x86_64' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'
# aws ec2 describe-images --filters 'Name=name,Values=*suse-sles-15-sp3-v202*-hvm-ssd-x86_64' 'Name=architecture,Values=x86_64' | jq '.Images[] | .Name, .ImageId'


data "aws_ami" "host_os_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.module_var_host_os_image}"]
  }

  owners = ["self", "amazon", "aws-marketplace"]

}

# Display everything about OS Image
#output "output_aws_ami_detail" {
#  value = data.aws_ami.host_os_image.image_id
#}

