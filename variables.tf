# variables.tf
variable "tenancy_ocid" {
  description = "OCID of your tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the user"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "us-phoenix-1"
}

variable "ssh_public_key_path" {
  description = "Path to public SSH key"
  type        = string
}

variable "ubuntu_image_id" {
  description = "OCID of Ubuntu 22.04 ARM image"
  type        = string
  # You'll need to get this from your region
}