
resource "null_resource" "build_script_fs_init" {

  depends_on = [
    aws_volume_attachment.volume_attachment_hana_data,
    aws_volume_attachment.volume_attachment_hana_data_custom,
    aws_volume_attachment.volume_attachment_hana_log,
    aws_volume_attachment.volume_attachment_hana_log_custom,
    aws_volume_attachment.volume_attachment_hana_shared,
    aws_volume_attachment.volume_attachment_hana_shared_custom,
    aws_volume_attachment.volume_attachment_usr_sap,
    aws_volume_attachment.volume_attachment_sapmnt,
    aws_volume_attachment.volume_attachment_swap,
    aws_volume_attachment.volume_attachment_software,
    aws_volume_attachment.volume_attachment_anydb,
    aws_volume_attachment.volume_attachment_anydb_custom
  ]

  connection {
    type                = "ssh"
    user                = "ec2-user"
    host                = aws_instance.host.private_ip
    private_key         = var.module_var_host_ssh_private_key
    bastion_host        = var.module_var_bastion_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_fs_init.sh"
    content     = <<EOF
#!/bin/bash

# If this script fails to execute with error \r command not found, use below to convert CRLF to LF
#sed -i "s/\r$//" FileName

#############################################
#	Disk Volumes and Filesystem Setup
#############################################

# Run the following as the "root" user

# Note that disk name values may be different from those seen here in actual deployments


# Note: Disks may come provisioned into partitioned volumes and will need to be erased/cleared first prior to configuration.

# Change the value for the physical disk to match your environment.


#############################################
# Verify OS distribution
#############################################

function check_os_distribution {

  export os_type=""
  export os_version=""

  os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
  os_info_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '\"')

  if [ "$os_info_id" = "sles" ] || [ "$os_info_id" = "sles_sap" ] ; then os_type="sles"
  elif [ "$os_info_id" = "rhel" ] ; then os_type="rhel" ; fi
  os_version=$os_info_version

  echo "Detected $os_type Linux Operating System Distribution"

}


#############################################
#	Enable, Multipath, swappiness and LVM
#############################################

function lvm_install() {

    touch /etc/multipath.conf

    # Install Multipath
    if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install device-mapper-multipath ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm multipath-tools ; fi

    systemctl enable multipathd
    systemctl restart multipathd

    # Checking status will cause Terraform session to break, so grep active line to confirm running
    systemctl status multipathd | grep "Active:"

    # Reduce swapping by amending vm.swappiness to 5% of free memory before swap is activated (default is 60%)
    sysctl vm.swappiness=5

    # Reboot the system


    # Install LVM
    if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install lvm2* ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm lvm2* ; fi

    systemctl enable lvm2-lvmdbusd.service
    systemctl restart lvm2-lvmdbusd.service

    # Checking status will cause Terraform session to break, so grep active line to confirm running
    systemctl status lvm2-lvmdbusd.service | grep "Active:"

}




#############################################
#	LVM disk partitioning and filesystem formatting
#############################################

function lvm_filesystem_runner() {

    mount_point="$1"
    disk_capacity_gb_specified="$2"
    lvm_pv_data_alignment="$3"
    lvm_volume_group_name="$4"
    lvm_volume_group_data_alignment="$5"
    lvm_volume_group_physical_extent_size="$6"
    lvm_logical_volume_name="lv_$${lvm_volume_group_name#vg_}"
    lvm_logical_volume_stripe_size="$7"
    filesystem_format="$8"

    # Ensure directory is available
    mkdir --parents $mount_point

    # Clear any previous data entries on previously formatted disks
    unset existing_disks_list
    unset lvm_volume_group_target_list
    unset physical_disks_list_with_gigabytes

    # Find existing disk devices and partitions
    for disk in $(blkid -o device)
    do
      existing_disk_no_partition=$(echo "$disk" | sed 's/[0-9]\+$//')
      export existing_disks_list=$(echo $existing_disk_no_partition & echo $existing_disks_list)
      unset existing_disk_no_partition
    done

    # Run calculations
    physical_disks_list=$(lsblk --nodeps --bytes --noheadings -io KNAME,FSTYPE | awk 'BEGIN{OFS="\t"} {if (FNR>1 && $2 = "") print "/dev/"$1; else print $0}')
    physical_disks_list_with_megabytes=$(lsblk --nodeps --bytes --noheadings -io KNAME,SIZE | awk 'BEGIN{OFS="\t"} {if (FNR>1) print $1,$2/1024/1024; else print $0}')
    physical_disks_list_with_gigabytes=$(lsblk --nodeps --bytes --noheadings -io KNAME,SIZE | awk 'BEGIN{OFS="\t"} {if (FNR>1) print $1,$2/1024/1024/1024; else print $0}')
    echo "$physical_disks_list_with_gigabytes" > $HOME/physical_disks_list_with_gigabytes.txt


    ####
    # Create LVM Physical Volumes
    #
    # This initialises the whole Disk or a Disk Partition as LVM Physical Volumes for use as part of LVM Logical Volumes
    #
    # First physical extent begins at 1MB which is defined by default_data_alignment in lvm.conf and this can be overriden by --dataalignment.
    # Default 1MB offset from disk start before first LVM PV Physical Extent is used,
    # and an additional offset after can be set using --dataalignmentoffset.
    # 
    # I/O from the LVM Volume Group to the LVM Physical Volume will use the extent size defined
    # by the LVM Volume Group, starting at the point defined by the LVM Physical Volume data alignment offset
    ####

    # Workaround to while running in subshell and inability to re-use variables (the volume group target lists)
    while IFS= read -r line
    do
      disk_id=$(echo $line | awk '{ print $1}')
      disk_capacity_gb=$(echo $line | awk '{ print $2}')
      if [[ $existing_disks_list = *"$disk_id"* ]]
      then
        echo "No action on existing formatted /dev/$disk_id"
      elif [[ $disk_capacity_gb = "$disk_capacity_gb_specified" ]]
      then
        echo "Creating LVM Physical Volume for /dev/$disk_id using data alignment offset $lvm_pv_data_alignment"
        pvcreate "/dev/$disk_id" --dataalignment $lvm_pv_data_alignment
        echo "Adding /dev/$disk_id to a list for the LVM Volume Group for $mount_point"
        lvm_volume_group_target_list=$(echo "/dev/$disk_id" & echo $lvm_volume_group_target_list)
        echo ""
      fi
    done <<< "$(echo -e "$physical_disks_list_with_gigabytes")"

    ####
    # Create LVM Volume Groups and add LVM Physical Volumes
    # Default is 1MiB offset from disk start before first LVM VG Physical Extent is used
    # Default is 4MiB for the physical extent size (aka. block size), once set this is difficult to change
    # 
    # I/O from the LVM Logical Volume to the LVM Volume Group will use the extent size defined
    # by the LVM Volume Group, starting at the point defined by the LVM Volume Group data alignment offset
    #
    # Therefore the LVM Volume Group extent size acts as the block size from LVM virtualization to the physical disks
    ####

    echo "Creating $lvm_volume_group_name volume group with $(echo $lvm_volume_group_target_list | tr -d '\n'), using $lvm_volume_group_data_alignment data alignment and $lvm_volume_group_physical_extent_size extent size (block size)"
    vgcreate --dataalignment $lvm_volume_group_data_alignment --physicalextentsize $lvm_volume_group_physical_extent_size $lvm_volume_group_name $(echo $lvm_volume_group_target_list | tr -d '\n')
    echo ""

    #######
    # Create expandable LVM Logical Volume, using single or multiple physical disk volumes
    # Default is 64K for the stripe size (aka. block size)
    #
    # I/O from the OS/Applications to the LVM Logical Volume will use the stripe size defined
    #
    # Therefore the LVM Logical Volume stripe size acts as the block size from OS to LVM virtualization
    # IMPORTANT: Correct setting of this stripe size has impact on performance of OS and Applications read/write
    #######

    # Count number of LVM Physical Volumes in the LVM Volume Group
    count_physical_volumes=$(echo "$lvm_volume_group_target_list" | wc -w)

    # Create LVM Logical Volume
    # Stripe across all LVM Physical Volumes available in the LVM Volume Group
    echo "Creating $lvm_logical_volume_name logical volume for $lvm_volume_group_name volume group, using $lvm_logical_volume_stripe_size extent size (block size)"
    lvcreate $lvm_volume_group_name --yes --extents "100%FREE" --stripesize $lvm_logical_volume_stripe_size --stripes $count_physical_volumes --name "$lvm_logical_volume_name"
    echo ""


    #######
    # Create File System formatting for the LVM Logical Volume
    # Filesystem is either XFS or EXT4
    #######

    echo "Create File System formatting for the LVM Logical Volume"
    mkfs.$filesystem_format "/dev/$lvm_volume_group_name/$lvm_logical_volume_name"
    echo ""


    #######
    # Permenant mount point
    #######

    # Note: After enabling multipath on the Linux host and rebooting the system, disk paths might appear in “/dev/UUID” form with a unique alphanumeric identifier.
    #       This can be seen by using the “lsblk” command on Linux. The preferred method is to use this disk path as opposed to the “/dev/sdX” path when formatting and mounting file systems.

    # Note: When adding an /etc/fstab entry for iSCSI based disk devices, use the “_netdev” mount option to ensure
    #       that the network link is ready before the operating system attempts to mount the disk.

    echo "Create fstab entries for $lvm_volume_group_name"
    echo "# fstab entries for $lvm_volume_group_name"  >> /etc/fstab
    echo "/dev/$lvm_volume_group_name/$lvm_logical_volume_name    $mount_point    $filesystem_format    defaults,noatime    0    0" >> /etc/fstab
    echo ""

}




#############################################
#	Physical Volume Partition formatting
#############################################

function physical_volume_partition_runner() {

    mount_point="$1"
    disk_capacity_gb_specified="$2"
    physical_partition_filesystem_block_size="$3"
    physical_partition_name="$4"
    filesystem_format="$5"

    # Ensure directory is available
    mkdir --parents $mount_point

    # Clear any previous data entries on previously formatted disks
    unset existing_disks_list
    unset lvm_volume_group_target_list
    unset physical_disks_list_with_gigabytes

    # Find existing disk devices and partitions
    for disk in $(blkid -o device)
    do
      existing_disk_no_partition=$(echo "$disk" | sed 's/[0-9]\+$//')
      export existing_disks_list=$(echo $existing_disk_no_partition & echo $existing_disks_list)
      unset existing_disk_no_partition
    done

    # Run calculations
    physical_disks_list=$(lsblk --nodeps --bytes --noheadings -io KNAME,FSTYPE | awk 'BEGIN{OFS="\t"} {if (FNR>1 && $2 = "") print "/dev/"$1; else print $0}')
    physical_disks_list_with_megabytes=$(lsblk --nodeps --bytes --noheadings -io KNAME,SIZE | awk 'BEGIN{OFS="\t"} {if (FNR>1) print $1,$2/1024/1024; else print $0}')
    physical_disks_list_with_gigabytes=$(lsblk --nodeps --bytes --noheadings -io KNAME,SIZE | awk 'BEGIN{OFS="\t"} {if (FNR>1) print $1,$2/1024/1024/1024; else print $0}')
    echo "$physical_disks_list_with_gigabytes" > $HOME/physical_disks_list_with_gigabytes.txt


    if [[ $filesystem_format == "xfs" ]]
    then
      echo "#### XFS on Linux supports only filesystems with block sizes EQUAL to the system page size. ####"
      echo "#### The disk can be formatted with up to 64 KiB, however it will fail to mount with the following error ####"
      echo "#  mount(2) system call failed: Function not implemented."
      echo ""
      echo "#### The default page size is hardcoded and cannot be changed. ####"
      echo ""
      echo "#### Red Hat KB: What is the maximum supported XFS block size in RHEL? - https://access.redhat.com/solutions/1614393 ####"
      echo "#### Red Hat KB: Is it possible to change Page Size in Red Hat Enterprise Linux? - https://access.redhat.com/solutions/4854441 ####"
      echo ""
      echo "Page Size currently set to:"
      getconf PAGESIZE
      echo ""
    fi

    page_size=$(getconf PAGESIZE)

    if [[ $filesystem_format == "xfs" ]] && [[ $(( page_size/1024 )) != $(echo $physical_partition_filesystem_block_size | sed 's/[^0-9]*//g') ]]
    then
      echo "Requested XFS Block Sizes are not equal to the Page Size, amend to Page Size"
      echo "$mount_point requested as xfs with block size $physical_partition_filesystem_block_size, resetting to $page_size"
      block_size_definition=$page_size
    else
      block_size_definition=$physical_partition_filesystem_block_size
    fi


    # Mount options for filesystem table.
    # With only 4 KiB Page Size, only 2 in-memory log buffers are available so increase to each buffer's size (default 32kc) may increase performance
    mount_options="defaults,noatime"
    #mount_options="defaults,logbsize=256k"

    # Workaround to while running in subshell and inability to re-use variables (the volume group target lists)
    while IFS= read -r line
    do
      disk_id=$(echo $line | awk '{ print $1}')
      disk_capacity_gb=$(echo $line | awk '{ print $2}')
      if [[ $existing_disks_list = *"$disk_id"* ]]
      then
        echo "No action on existing formatted /dev/$disk_id"
      elif [[ $disk_capacity_gb = $disk_capacity_gb_specified ]]
      then
        echo "Creating Whole Disk Physical Volume Partition and File System for /dev/$disk_id at $mount_point with GPT Partition Table, start at 1MiB"
        parted --script /dev/$disk_id \
          mklabel gpt \
          mkpart primary $filesystem_format 1MiB 100% \
          name 1 $physical_partition_name
        echo "Format Disk Partition with File System, with block size $block_size_definition"
        mkfs.$${filesystem_format} -f -b size=$block_size_definition /dev/$disk_id
        echo "Write Mount Points to Linux File System Table"
        PhysicalDiskUUID=$(blkid /dev/$disk_id -sUUID -ovalue)
        echo "UUID=$PhysicalDiskUUID $mount_point $${filesystem_format} $mount_options 0 0"\ >> /etc/fstab
        echo ""
      fi
    done <<< "$(echo -e "$physical_disks_list_with_gigabytes")"

}




#############################################
#	Swap file or partition
#############################################

function create_swap_file() {

  echo "Create swapfile"

  swap_gb="$1"
  swap_bs="128"

  swap_calc_bs=$swap_bs"M"
  swap_calc_count="$((x=$swap_gb*1024,x/$swap_bs))"
  dd if=/dev/zero of=/swapfile bs=$swap_calc_bs count=$swap_calc_count
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
  swapon --show
  free -h

}


function create_swap_partition() {

  find_swap_partition_by_size="$1"

  physical_disks_list_with_gigabytes=$(lsblk --nodeps --bytes --noheadings -io KNAME,SIZE | awk 'BEGIN{OFS="\t"} {if (FNR>1) print $1,$2/1024/1024/1024; else print $0}')

  while IFS= read -r line
  do
    disk_id=$(echo $line | awk '{ print $1}')
    disk_capacity_gb=$(echo $line | awk '{ print $2}')
    if [[ $existing_disks_list = *"$disk_id"* ]]
    then
      echo "No action on existing formatted /dev/$disk_id"
    elif [[ $disk_capacity_gb = $find_swap_partition_by_size ]]
    then
      echo "Create swap partition"
      mkswap /dev/$disk_id
      swapon /dev/$disk_id
      echo "/dev/$disk_id swap swap defaults 0 0" >> /etc/fstab
      swapon --show
      free -h
      echo ""
      break
    fi
  done <<< "$(echo -e "$physical_disks_list_with_gigabytes")"

}




#############################################
# Verify/Debug
#############################################

storage_debug="false"

function storage_debug_run() {

if [ "$storage_debug" == "true" ]
then

  echo "--- Show Mount points ---"
  df -h
  printf "\n----------------\n\n"

  echo "--- Show /etc/fstab file ---"
  cat /etc/fstab
  printf "\n----------------\n\n"

  echo "--- Show Block devices ---"
  blkid
  printf "\n----------------\n\n"

  echo "--- Show Block devices information ---"
  lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINT,PHY-SEC,LOG-SEC
  printf "\n----------------\n\n"

  echo "--- Show Hardware List of Disks and Volumes ---"
  lshw -class disk -class volume
  ###lshw -json -class disk -class volume | jq '[.logicalname, .configuration.sectorsize, .configuration.logicalsectorsize]'
  ###tail -n +1 /sys/block/vd*/queue/*_block_size
  printf "\n----------------\n\n"

  echo "--- Show LVM Physical Volumes ---"
  pvs
  # pvs -v
  printf "\n----------------\n\n"

  echo "--- Show LVM Physical Volumes information ---"
  pvdisplay
  printf "\n----------------\n\n"

  echo "--- Show LVM Volume Groups ---"
  vgs
  # vgs -v
  printf "\n----------------\n\n"

  echo "--- Show LVM Volume Groups information ---"
  vgdisplay
  printf "\n----------------\n\n"

  echo "--- Show LVM Logical Volumes ---"
  lvs
  # lvs -v
  printf "\n----------------\n\n"

  echo "--- Show LVM Logical Volumes information ---"
  lvdisplay
  printf "\n----------------\n\n"

fi

}




#############################################
#	MAIN
#############################################

function main() {

  check_os_distribution

  # Bash Functions use logic of "If injected Terraform value is true (i.e. LVM is used for the mount point) then run Bash Function".
  # Ensure Bash Function is called with quotes surrounding Bash Variable of list, otherwise will expand and override other Bash Function Arguments

  echo 'Install jq'
  if [ ! -f /usr/local/bin/jq ]; then curl -L 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64' -o jq && chmod +x jq && mv jq /usr/local/bin; fi

  #	Create the required directories
  mkdir --parents /hana/{shared,data,log} --mode 755
  mkdir --parents /usr/sap --mode 755
  mkdir --parents /sapmnt --mode 755


  # If any mount point uses LVM. i.e. IF with OR operator
  if [[ "${var.module_var_lvm_enable_hana_data}" == "true" ]] || [[ "${var.module_var_lvm_enable_hana_log}" == "true" ]] || [[ "${var.module_var_lvm_enable_hana_shared}" == "true" ]] || [[ "${var.module_var_lvm_enable_anydb}" == "true" ]]
  then
    lvm_install
  fi


  if [[ ${var.module_var_disk_volume_count_hana_data} -gt 0 ]]
  then
    if [[ "${var.module_var_lvm_enable_hana_data}" == "true" ]]
    then
      lvm_filesystem_runner "/hana/data" "${var.module_var_disk_volume_capacity_hana_data}" "${var.module_var_lvm_pv_data_alignment_hana_data}" "vg_hana_data" "${var.module_var_lvm_vg_data_alignment_hana_data}" "${var.module_var_lvm_vg_physical_extent_size_hana_data}" "${var.module_var_lvm_lv_stripe_size_hana_data}" "${var.module_var_filesystem_hana_data}"
    
    elif [[ "${var.module_var_lvm_enable_hana_data}" == "false" ]]
    then
      physical_volume_partition_runner "/hana/data" "${var.module_var_disk_volume_capacity_hana_data}" "${var.module_var_physical_partition_filesystem_block_size_hana_data}" "hana_data" "${var.module_var_filesystem_hana_data}"
    fi
  fi


  if [[ ${var.module_var_disk_volume_count_hana_log} -gt 0 ]]
  then
    if [[ "${var.module_var_lvm_enable_hana_log}" == "true" ]]
    then
      lvm_filesystem_runner "/hana/log" "${var.module_var_disk_volume_capacity_hana_log}" "${var.module_var_lvm_pv_data_alignment_hana_log}" "vg_hana_log" "${var.module_var_lvm_vg_data_alignment_hana_log}" "${var.module_var_lvm_vg_physical_extent_size_hana_log}" "${var.module_var_lvm_lv_stripe_size_hana_log}" "${var.module_var_filesystem_hana_log}"
    
    elif [[ "${var.module_var_lvm_enable_hana_log}" == "false" ]]
    then
      physical_volume_partition_runner "/hana/log" "${var.module_var_disk_volume_capacity_hana_log}" "${var.module_var_physical_partition_filesystem_block_size_hana_log}" "hana_log" "${var.module_var_filesystem_hana_log}"
    fi
  fi


  if [[ ${var.module_var_disk_volume_count_hana_shared} -gt 0 ]]
  then
    if [[ "${var.module_var_lvm_enable_hana_shared}" == "true" ]]
    then
      lvm_filesystem_runner "/hana/shared" "${var.module_var_disk_volume_capacity_hana_shared}" "${var.module_var_lvm_pv_data_alignment_hana_shared}" "vg_hana_shared" "${var.module_var_lvm_vg_data_alignment_hana_shared}" "${var.module_var_lvm_vg_physical_extent_size_hana_shared}" "${var.module_var_lvm_lv_stripe_size_hana_shared}" "${var.module_var_filesystem_hana_shared}"
    
    elif [[ "${var.module_var_lvm_enable_hana_shared}" == "false" ]]
    then
      physical_volume_partition_runner "/hana/shared" "${var.module_var_disk_volume_capacity_hana_shared}" "${var.module_var_physical_partition_filesystem_block_size_hana_shared}" "hana_shared" "${var.module_var_filesystem_hana_shared}"
    fi
  fi


  if [[ ${var.module_var_disk_volume_count_anydb} -gt 0 ]]
  then
    if [[ "${var.module_var_lvm_enable_anydb}" == "true" ]]
    then
      lvm_filesystem_runner "${var.module_var_filesystem_mount_path_anydb}" "${var.module_var_disk_volume_capacity_anydb}" "${var.module_var_lvm_pv_data_alignment_anydb}" "vg_anydb" "${var.module_var_lvm_vg_data_alignment_anydb}" "${var.module_var_lvm_vg_physical_extent_size_anydb}" "${var.module_var_lvm_lv_stripe_size_anydb}" "${var.module_var_filesystem_anydb}"
    
    elif [[ "${var.module_var_lvm_enable_anydb}" == "false" ]]
    then
      physical_volume_partition_runner "${var.module_var_filesystem_mount_path_anydb}" "${var.module_var_disk_volume_capacity_anydb}" "${var.module_var_physical_partition_filesystem_block_size_anydb}" "anydb" "${var.module_var_filesystem_anydb}"
    fi
  fi


  if [[ ${var.module_var_disk_volume_count_usr_sap} -gt 0 ]]
  then
    physical_volume_partition_runner "/usr/sap" "${var.module_var_disk_volume_capacity_usr_sap}" "4k" "usr_sap" "${var.module_var_filesystem_usr_sap}"
  fi


  if [[ ${var.module_var_nfs_boolean_sapmnt} == "false" ]] && [[ ${var.module_var_disk_volume_count_sapmnt} -gt 0 ]]
  then
    physical_volume_partition_runner "/sapmnt" "${var.module_var_disk_volume_capacity_sapmnt}" "4k" "sapmnt" "${var.module_var_filesystem_sapmnt}"
  elif [[ ${var.module_var_nfs_boolean_sapmnt} == "true" ]]
  then
    # Establish AWS EFS Mount Target DNS Name (the AWS EFS network interface must be added to the correct Security Groups for the hosts)
    aws_efs_mount_fqdn_sapmnt='${var.module_var_nfs_boolean_sapmnt ? var.module_var_nfs_fqdn_sapmnt : "null"}'

    # AWS recommend OS mount of the AWS EFS Mount Target via the DNS FQDN, which resolves to the IP Address of the AWS EFS Mount Target in the same AWS Availability Zone as the AWS EC2 Virtual Server.
    # Usually to increase network latency performance for SAP NetWeaver read/write operations, IP Addresses should be used
    # However, the NFS protocol performs DNS lookup at mount time, and stores into the local host DNS cache - based on the DNS TTL defined by the AWS DNS Name Server
    # As this activity is infrequent, it should not impact performance to set to the FQDN of the AWS EFS Mount Target
    # It is mandatory that the AWS VPC has enabled DNS Support and DNS Hostname Support, otherwise resolution to the Private IP Address will fail

    # Install NFS
    if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install nfs-utils ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm nfs-client ; fi

    # Mount AWS EFS via DNS FQDN
    echo "Mounting NFS for /sapmnt to AWS EFS Mount Target DNS Name: $aws_efs_mount_fqdn_sapmnt"
    #sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $aws_efs_mount_fqdn_sapmnt:/ /sapmnt
    echo "# fstab entries for NFS"  >> /etc/fstab
    echo "$aws_efs_mount_fqdn_sapmnt:/    /sapmnt    nfs4    nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev    0    0" >> /etc/fstab
  fi


  if [[ ${var.module_var_disk_swapfile_size_gb} -gt 0 ]]
  then
    create_swap_file "${var.module_var_disk_swapfile_size_gb}"
  else
    create_swap_partition "${var.module_var_disk_volume_capacity_swap}"
  fi


  physical_volume_partition_runner "${var.module_var_sap_software_download_directory}" "${var.module_var_disk_volume_capacity_software}" "4k" "software" "xfs"


  mount -a

}


# Run script by calling 'main' Bash Function
main


EOF
  }

}
