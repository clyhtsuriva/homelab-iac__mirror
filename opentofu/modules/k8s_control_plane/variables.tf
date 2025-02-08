variable "name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "desc" {
  type        = string
  description = "A description of the virtual machine."
  default     = ""
}

variable "agent" {
  type        = number
  description = "Whether to enable the QEMU guest agent (0 = disabled, 1 = enabled)."
  default     = 0
}

variable "target_node" {
  type        = string
  description = "The name of the Proxmox node where the VM will be created."
}

variable "tags" {
  type        = string
  description = "Tags to assign to the virtual machine."
  default     = ""
}

variable "clone" {
  type        = string
  description = "The name of the VM template to clone."
}

variable "full_clone" {
  type        = bool
  description = "Whether to create a full clone of the template (true) or a linked clone (false)."
  default     = true
}

variable "qemu_os" {
  type        = string
  description = "The type of OS installed on the VM."
  default     = "l26"  # Default is Linux 2.6/3.x/4.x/5.x kernel
}

variable "cores" {
  type        = number
  description = "The number of CPU cores to allocate to the VM."
  default     = 1
}

variable "sockets" {
  type        = number
  description = "The number of CPU sockets to allocate to the VM."
  default     = 1
}

variable "cpu_type" {
  type        = string
  description = "The type of CPU to emulate (e.g., 'host', 'kvm64')."
  default     = "host"
}

variable "memory" {
  type        = number
  description = "The amount of memory (in MB) to allocate to the VM."
  default     = 1024
}

variable "scsihw" {
  type        = string
  description = "The SCSI controller type (e.g., 'virtio-scsi-pci', 'virtio-scsi-single')."
  default     = "virtio-scsi-pci"
}

variable "bootdisk" {
  type        = string
  description = "The boot disk interface (e.g., 'scsi0', 'virtio0')."
  default     = "virtio0"
}

variable "cloudinit_storage" {
  type        = string
  description = "The storage pool for the cloud-init drive."
}

variable "disk_storage" {
  type        = string
  description = "The storage pool for the primary disk."
}

variable "disk_size" {
  type        = string
  description = "The size of the primary disk (e.g., '20G')."
}

variable "iothread" {
  type        = bool
  description = "Whether to enable IO threading for the disk."
  default     = false
}

variable "replicate" {
  type        = bool
  description = "Whether to replicate the disk to other nodes."
  default     = false
}

variable "network_id" {
  type        = number
  description = "The ID of the network interface."
  default     = 0
}

variable "network_model" {
  type        = string
  description = "The model of the network interface (e.g., 'virtio')."
  default     = "virtio"
}

variable "network_bridge" {
  type        = string
  description = "The bridge to attach the network interface to."
  default     = "vmbr0"
}

variable "ipconfig0" {
  type        = string
  description = "The IP configuration for the VM (e.g., 'ip=dhcp')."
  default     = "ip=dhcp"
}

variable "ciuser" {
  type        = string
  description = "The username for cloud-init."
  default     = ""
}

variable "sshkeys" {
  type        = string
  description = "The SSH public keys to inject into the VM via cloud-init."
  default     = ""
}
