module "k8s_control_plane" {
  source = "./modules/k8s_control_plane"

  name              = "k8s-cp-01"
  desc              = "k8s control plane"
  agent             = 1
  target_node       = var.proxmox_node
  tags              = "debian;k8s"
  clone             = var.debian_server_bookworm_packer_image_name
  full_clone        = true
  qemu_os           = "other"
  cores             = 2
  sockets           = 1
  cpu_type          = "host"
  memory            = 6144
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  cloudinit_storage = "local-lvm"
  disk_storage      = "local-lvm"
  disk_size         = "32G"
  iothread          = true
  replicate         = false
  network_id        = 0
  network_model     = "virtio"
  network_bridge    = "vmbr0"
  ipconfig0         = "ip=dhcp"
  ciuser            = "mas"
  sshkeys           = var.ssh_public_key
}

module "k8s_worker" {
  source = "./modules/k8s_worker"

  vm_count          = var.k8s_worker_vm_count
  name_prefix       = var.k8s_worker_vm_name_prefix
  desc              = "k8s worker"
  agent             = 1
  target_node       = var.proxmox_node
  tags              = "debian;k8s"
  clone             = var.debian_server_bookworm_packer_image_name
  full_clone        = true
  qemu_os           = "other"
  cores             = 1
  sockets           = 1
  cpu_type          = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  cloudinit_storage = "local-lvm"
  disk_storage      = "local-lvm"
  disk_size         = "32G"
  iothread          = true
  replicate         = false
  network_id        = 0
  network_model     = "virtio"
  network_bridge    = "vmbr0"
  ipconfig0         = "ip=dhcp"
  ciuser            = "mas"
  sshkeys           = var.ssh_public_key
}

module "ansible_provision_k8s" {
  source                = "./modules/ansible_provisioner"
  inventory_file_path   = local_file.ansible_inventory.filename
  vm_username           = var.vm_username
  ssh_private_key_path  = var.ssh_private_key_path
  ansible_playbook_path = var.k8s_ansible_playbook_path
}
