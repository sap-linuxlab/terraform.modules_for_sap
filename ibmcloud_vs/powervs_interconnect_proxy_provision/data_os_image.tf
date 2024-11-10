# OS Images lookup

data "ibm_is_images" "proxy_os_images_list" {
  status = "available"
}

# Display everything from ibm_is_images.abc.images, which is list of objects with 42 elements, with each element containing 7 attributes which are strings
#output "ibm_is_images_names" {
#  value = join(",\n",
#    sort(
#      [ for key,value in data.ibm_is_images.os_images.images : data.ibm_is_images.os_images.images[key].name ]
#    )
#  )
#}

# Display the OS Image ID for RHEL in a string
# Loop through ibm_is_images.abc.images, which is list of objects with 42 elements, with each element containing 7 attributes which are strings
# Inspired by https://blog.gruntwork.io/terraform-up-running-2nd-edition-early-release-is-now-available-b104fc29783f#da95
#output "ibm_is_images_id_lookup_list" {
#  value = join("",
#    compact([
#      for key,value in
#      data.ibm_is_images.os_images.images :
#      length(regexall(".*redhat.*8.*amd64.*", data.ibm_is_images.os_images.images[key].name)
#      ) > 0 ? data.ibm_is_images.os_images.images[key].id : ""
#    ])
#  )
#}

# Find OS Image ID for RHEL based on the OS Image Name (from the OS Images List data) converted to a string
data "ibm_is_image" "proxy_os_image" {
  name = reverse(
    sort(
      compact(
        [
          for key, value in
          data.ibm_is_images.proxy_os_images_list.images :
          length(
            regexall("${var.module_var_proxy_os_image}", data.ibm_is_images.proxy_os_images_list.images[key].name)
          ) > 0 ?
          data.ibm_is_images.proxy_os_images_list.images[key].name
          : ""
        ]
      )
    )
  )[0]
}
