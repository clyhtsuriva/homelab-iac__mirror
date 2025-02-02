variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}


variable "proxmox_node" {
  description = "Proxmox node to deploy the VM on"
  type        = string
}

variable "packer_image_name" {
  description = "Name of the Packer image to clone"
  type        = string
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

variable "ansible_playbook_path" {
  description = "Path to the Ansible playbook for Docker installation"
  type        = string
}


