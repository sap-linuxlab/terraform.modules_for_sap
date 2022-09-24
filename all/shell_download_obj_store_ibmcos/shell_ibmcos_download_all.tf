
resource "null_resource" "build_script_cos_download_all" {

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type                = "ssh"
    user                = "root"
    host                = var.module_var_host_private_ip
    private_key         = var.module_var_host_private_ssh_key
    bastion_host        = var.module_var_bastion_floating_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_ibm_cos_download_all.sh"
    content     = <<EOF
    #!/bin/bash

    # If this script fails to execute with error \r command not found, use below to convert CRLF to LF
    #sed -i "s/\r$//" FileName

    function ibmcos_api_download_bucket_all(){

    ## Download and run binary, do not install.
    ## Code replicated from official installation for Linux > https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli
    ## Removed validation checks, use Terraform to report failure if ibmcloud CLI does not work

    host="download.clis.cloud.ibm.com"
    metadata_host="$host/ibm-cloud-cli-metadata"
    os_name=$(uname -s | tr '[:upper:]' '[:lower:]')


    if [ "$os_name" = "linux" ]; then
        arch=$(uname -m | tr '[:upper:]' '[:lower:]')
        if echo "$arch" | grep -q 'x86_64'
        then
            platform="linux64"
        elif echo "$arch" | grep -q -E '(x86)|(i686)'
        then
            platform="linux32"
        elif echo "$arch" | grep -q 'ppc64le'
        then
            platform="ppc64le"
        elif echo "$arch" | grep -q 's390x'
        then
            platform="s390x"
        else
            echo "Unsupported Linux architecture: $${arch}. Quit installation."
            exit 1
        fi
    else
        echo "Unsupported platform: $${os_name}. Quit installation."
        exit 1
    fi


    # fetch version metadata of CLI
    info_endpoint="https://$metadata_host/info.json"
    info=$(curl -f -L -s "$info_endpoint")

    # parse latest version from metadata
    latest_version=$(echo "$info" | grep -Eo '"latestVersion"[^,]*' | grep -Eo '[^:]*$' | tr -d '"' | tr -d '[:space:]')

    # fetch all versions metadata of CLI
    all_versions_endpoint="https://$metadata_host/all_versions.json"
    all_versions=$(curl -f -L -s "$all_versions_endpoint")

    # get the section of the metadata that we need, starting from the matching version text to the text 'archives'
    metadata_section=$(echo "$all_versions" | sed -ne '/'\""$latest_version"\"'/,/'"archives"'/p')

    # get the section for the appropriate platform
    platform_binaries=$(echo "$metadata_section" | sed -ne '/'"$platform"'/,/'"checksum"'/p')

    # get the installer url
    installer_url=$(echo "$platform_binaries" | grep -Eo '"url"[^,]*' | cut -d ":" -f2- | tr -d '"' | tr -d '[:space:]')
    # get the checksum
    sh1sum=$(echo "$platform_binaries" | grep -Eo '"checksum"[^,]*' | cut -d ":" -f2- | tr -d '"' | tr -d '[:space:]')

    # define file name and path of download
    file_name="terraform_exec_IBM_Cloud_CLI.tar.gz"
    file_full_path="$${HOME}/$${file_name}"

    # download file
    curl -L $installer_url --output $file_full_path

    # calculate SHA and ensure match
    calculated_sha1sum=$(sha1sum $file_full_path | awk '{print $1}')
    if [ "$sh1sum" != "$calculated_sha1sum" ]; then
        echo "Downloaded file is corrupted. Quit installation."
        exit 1
    fi

    # extract IBM Cloud CLI and chmod the binary
    mkdir --parents ibmcloud_cli
    tar -xvf $file_full_path --strip-components=1 -C ./ibmcloud_cli
    chmod 755 $HOME/ibmcloud_cli/bin/ibmcloud


    # Begin login to IBM Cloud CLI, use full path to binary

    $HOME/ibmcloud_cli/bin/ibmcloud login --no-region --apikey ${var.module_var_ibmcloud_api_key}
    $HOME/ibmcloud_cli/bin/ibmcloud plugin install -f cloud-object-storage

    if [ "$platform" = "ppc64le" ]; then
      echo "Confirm IBM Cloud Object Storage paths are reachable"
      endpoint_locations="us eu ap us-south us-east eu-gb eu-de au-syd jp-tok jp-osa ca-tor br-sao ams03 che01 hkg02 mex01 mil01 mon01 par01 sjc04 seo01 sng01"
      for i in $endpoint_locations; do
          echo "Silent execution of dig and nslookup for s3.$i.cloud-object-storage.appdomain.cloud"
          dig +short "s3.$i.cloud-object-storage.appdomain.cloud" > /dev/null 2>&1
          nslookup "s3.$i.cloud-object-storage.appdomain.cloud" | grep "Address" | tail -1 > /dev/null 2>&1
          echo "Silent execution of dig and nslookup for s3.direct.$i.cloud-object-storage.appdomain.cloud"
          dig +short "s3.direct.$i.cloud-object-storage.appdomain.cloud" > /dev/null 2>&1
          nslookup "s3.direct.$i.cloud-object-storage.appdomain.cloud" | grep "Address" | tail -1 > /dev/null 2>&1
      done
    fi

    # List all instances
    #$HOME/ibmcloud_cli/bin/ibmcloud resource service-instances --long --all-resource-groups --service-name cloud-object-storage

    # Identify information about 1 object storage instance
    #IBMCOS_SERVICE_INSTANCE="name-of-instance"
    #IBMCOS_SERVICE_INSTANCE_CRN=$($HOME/ibmcloud_cli/bin/ibmcloud resource service-instance $IBMCOS_SERVICE_INSTANCE | awk '$1 == "ID:" { print $2 }')
    #$HOME/ibmcloud_cli/bin/ibmcloud cos buckets --ibm-service-instance-id $IBMCOS_SERVICE_INSTANCE_CRN


    # Download all files in object storage bucket

    BUCKET_INPUT="${var.module_var_ibmcos_bucket}"

    if [[ "$BUCKET_INPUT" == *\/* ]]
    then
        IBMCOS_BUCKET=$(echo $BUCKET_INPUT | awk -F'/' '{print $1}')
        IBMCOS_BUCKET_PREFIX=$(echo $BUCKET_INPUT | awk -F'/' '{print $2}')
        IBMCOS_REGION=$($HOME/ibmcloud_cli/bin/ibmcloud cos bucket-location-get --bucket $IBMCOS_BUCKET | awk '$1 == "Region:" { print $2 }')
        IBMCOS_BUCKET_FILES_LIST=$($HOME/ibmcloud_cli/bin/ibmcloud cos objects --bucket $IBMCOS_BUCKET --region $IBMCOS_REGION --prefix $IBMCOS_BUCKET_PREFIX | awk '/^Name/{p=1;next}p {print $1}')
        IBMCOS_BUCKET_FILES_LIST=$(echo $IBMCOS_BUCKET_FILES_LIST | awk '{gsub("'$IBMCOS_BUCKET_PREFIX'/ ", ""); print}')
    else
        IBMCOS_BUCKET="$BUCKET_INPUT"
        IBMCOS_REGION=$($HOME/ibmcloud_cli/bin/ibmcloud cos bucket-location-get --bucket $IBMCOS_BUCKET | awk '$1 == "Region:" { print $2 }')
        IBMCOS_BUCKET_FILES_LIST=$($HOME/ibmcloud_cli/bin/ibmcloud cos objects --bucket $IBMCOS_BUCKET --region $IBMCOS_REGION | awk '/^Name/{p=1;next}p {print $1}')
    fi

    IBMCOS_DOWNLOAD_DIRECTORY="${var.module_var_ibmcos_download_directory}"
    mkdir --parents $IBMCOS_DOWNLOAD_DIRECTORY

    echo 'Prepare IBM Cloud CLI with IBM COS and IBM Aspera protocol'
    echo 'Show help menu and trigger first-time use download of IBM Aspera Transferd binary to $HOME/.aspera_sdk/bin/asperatransferd'
    export IBMCLOUD_API_KEY="${var.module_var_ibmcloud_api_key}"
    ibmcloud cos aspera-download || true

    for FILENAME in $IBMCOS_BUCKET_FILES_LIST
    do
      echo "Downloading $FILENAME"
      FILENAME_ONLY=$(echo $FILENAME | awk '{gsub(".*/", ""); print}')
      if [ ! -f $IBMCOS_DOWNLOAD_DIRECTORY/$FILENAME_ONLY ]; then
        # Re-login in case of session invalidated 'due to inactivity' between file downloads
        $HOME/ibmcloud_cli/bin/ibmcloud login --no-region --apikey ${var.module_var_ibmcloud_api_key}
#        $HOME/ibmcloud_cli/bin/ibmcloud cos object-get --bucket $IBMCOS_BUCKET --key $FILENAME --region=$IBMCOS_REGION $IBMCOS_DOWNLOAD_DIRECTORY/$FILENAME_ONLY
        $HOME/ibmcloud_cli/bin/ibmcloud cos aspera-download --bucket $IBMCOS_BUCKET --key $FILENAME --region=$IBMCOS_REGION $IBMCOS_DOWNLOAD_DIRECTORY/$FILENAME_ONLY
      else
        echo "File already exists"
      fi
    done

    }

    ibmcos_api_download_bucket_all

EOF
  }

}


resource "null_resource" "exec_cos_download_all" {

  depends_on = [null_resource.build_script_cos_download_all]

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/terraform_ibm_cos_download_all.sh ; bash $HOME/terraform_ibm_cos_download_all.sh"
    ]
  }

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type                = "ssh"
    user                = "root"
    host                = var.module_var_host_private_ip
    private_key         = var.module_var_host_private_ssh_key
    bastion_host        = var.module_var_bastion_floating_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}
