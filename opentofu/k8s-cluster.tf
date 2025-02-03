resource "proxmox_vm_qemu" "k8s_cp" {

  lifecycle {
    ignore_changes = [
      bootdisk,
    ]
  }

  name        = "k8s-cp-01"
  desc        = "k8s control plane"
  agent       = 1 # Qemu Guest Agent
  target_node = var.proxmox_node
  tags        = "debian;k8s"

  clone      = var.debian_server_bookworm_packer_image_name
  full_clone = true

  qemu_os  = "other"
  cores    = 2
  sockets  = 1
  cpu_type = "host"
  memory   = 6144

  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage   = "local-lvm"
          size      = "32G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init settings
  ipconfig0 = "ip=dhcp"
  ciuser    = "mas"
  sshkeys   = var.ssh_public_key
}

resource "proxmox_vm_qemu" "k8s_worker" {

  lifecycle {
    ignore_changes = [
      bootdisk,
    ]
  }

  count       = var.k8s_worker_vm_count
  name        = "${var.k8s_worker_vm_name_prefix}-${count.index}"
  desc        = "k8s worker"
  agent       = 1 # Qemu Guest Agent
  target_node = var.proxmox_node
  tags        = "debian;k8s"

  clone      = var.debian_server_bookworm_packer_image_name
  full_clone = true

  qemu_os  = "other"
  cores    = 1
  sockets  = 1
  cpu_type = "host"
  memory   = 2048

  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage   = "local-lvm"
          size      = "32G"
          iothread  = true
          replicate = false
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init settings
  ipconfig0 = "ip=dhcp"
  ciuser    = "mas"
  sshkeys   = var.ssh_public_key
}

# Provision the control plane node and the workers
module "ansible_provision_k8s" {
  source                = "./modules/ansible_provisioner"
  inventory_file_path   = local_file.ansible_inventory.filename # Pass inventory path here
  vm_username           = var.vm_username
  ssh_private_key_path  = var.ssh_private_key_path
  ansible_playbook_path = var.k8s_ansible_playbook_path
}
