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

variable "debian_server_bookworm_packer_image_name" {
  description = "Name of the Packer image to clone"
  type        = string
}

variable "ubuntu_server_noble_packer_image_name" {
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


variable "k8s_worker_vm_name_prefix" {
  description = "VM name prefix"
  default     = "k8s-worker"
  type        = string
}

variable "k8s_worker_vm_count" {
  description = "Number of servers"
  default     = 2
  type        = string
}

