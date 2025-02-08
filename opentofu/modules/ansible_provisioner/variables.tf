variable "vm_ip" {
  type        = string
  default     = null
  description = "The IP address of the VM to provision. Either this or `inventory_file_path` must be provided."
}

variable "inventory_file_path" {
  type        = string
  default     = null
  description = "The path to the Ansible inventory file. Either this or `vm_ip` must be provided."
}

variable "vm_username" {
  type        = string
  description = "The username to use for SSH access to the VM."
}

variable "ssh_private_key_path" {
  type        = string
  description = "The path to the private SSH key for accessing the VM."
}

variable "ansible_playbook_path" {
  type        = string
  description = "The path to the Ansible playbook to execute."
}
