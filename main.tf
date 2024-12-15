# main.tf
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_identity_compartment" "aws_learning" {
  name          = "aws-learning"
  description   = "AWS Development Environment"
  enable_delete = true
}

resource "oci_core_vcn" "dev_vcn" {
  compartment_id = oci_identity_compartment.aws_learning.id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "aws-dev-vcn"
  dns_label      = "awsdevvcn"
}

resource "oci_core_subnet" "dev_subnet" {
  compartment_id = oci_identity_compartment.aws_learning.id
  vcn_id         = oci_core_vcn.dev_vcn.id
  cidr_block     = "10.0.1.0/24"
  display_name   = "dev-subnet"
  route_table_id = oci_core_route_table.dev_rt.id
  security_list_ids = [
    oci_core_security_list.dev_sl.id
  ]
}

resource "oci_core_internet_gateway" "dev_ig" {
  compartment_id = oci_identity_compartment.aws_learning.id
  vcn_id         = oci_core_vcn.dev_vcn.id
  display_name   = "dev-internet-gateway"
}

resource "oci_core_route_table" "dev_rt" {
  compartment_id = oci_identity_compartment.aws_learning.id
  vcn_id         = oci_core_vcn.dev_vcn.id
  display_name   = "dev-route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.dev_ig.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "dev_sl" {
  compartment_id = oci_identity_compartment.aws_learning.id
  vcn_id         = oci_core_vcn.dev_vcn.id
  display_name   = "dev-security-list"

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8080
      max = 8080
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_instance" "dev_instance" {
  compartment_id      = oci_identity_compartment.aws_learning.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "aws-dev-instance"
  shape              = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  source_details {
    source_type = "image"
    source_id   = var.ubuntu_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.dev_subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(templatefile("${path.module}/setup.sh", {}))
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

output "instance_public_ip" {
  value = oci_core_instance.dev_instance.public_ip
}