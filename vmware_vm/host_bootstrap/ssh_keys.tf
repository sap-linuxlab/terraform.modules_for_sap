
# Create private SSH key for ssh connection
resource "tls_private_key" "host_ssh" {
  algorithm = "RSA"
}
