# OS Images lookup

data "ibm_is_images" "bastion_os_image_list" {
  status = "available"
}

# Loop through and display everything from images, which is list of objects with 40+ elements, with each element containing 7 attributes which are strings
#output "ibm_is_images_names" {
#  value = join(",\n",
#    sort(
#      [ for key,value in data.ibm_is_images.os_images.images : data.ibm_is_images.os_images.images[key].name ]
#    )
#  )
#}

# Find OS Image based on the OS Image Name (from the OS Images List data) converted to a string
data "ibm_is_image" "bastion_os_image" {
  name = reverse(
    sort(
      compact(
        [
          for key, value in
          data.ibm_is_images.bastion_os_image_list.images :
          length(
            regexall("${var.module_var_bastion_os_image}", data.ibm_is_images.bastion_os_image_list.images[key].name)
          ) > 0 ?
          data.ibm_is_images.bastion_os_image_list.images[key].name
          : ""
        ]
      )
    )
  )[0]
}
