variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  type = string
}

variable "proxmox_node" {
  description = "Proxmox node to deploy the VM on"
  type        = string
}

variable "debian_server_bookworm_packer_image_id" {
  type = string
}

variable "ubuntu_server_noble_packer_image_id" {
  type = string
}

variable "vm_username" {
  description = "Username for SSH access to the VM"
  type        = string
  default     = "mas"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key for Ansible"
  type        = string
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}
