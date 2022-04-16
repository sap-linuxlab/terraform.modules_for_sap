
# Define host security group rules
resource "aws_security_group" "vpc_sg" {
  name        = "${var.module_var_resource_prefix}-vpc-sg"
  vpc_id      = local.target_vpc_id
  description = "Open Ports for hosts in VPC"


  # Allow Outbound HTTP Port 80 connection to any (e.g. via NAT Gateway)
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Outbound HTTPS Port 443 connection to any (e.g. via NAT Gateway)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ping inbound from other hosts within the same Subnet
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ping outbound from hosts to any network, only for Subnet containing hosts (i.e. not for Bastion Subnet)
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  egress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH Inbound/Outbound from hosts within private VPC Subnet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.target_subnet_ip_range}"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.target_subnet_ip_range}"]
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-vpc-sg"
  }

}
