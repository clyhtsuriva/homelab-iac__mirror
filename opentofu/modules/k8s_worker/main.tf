resource "proxmox_vm_qemu" "k8s_worker" {
  lifecycle {
    ignore_changes = [
      bootdisk,
    ]
  }

  count       = var.vm_count
  name        = "${var.name_prefix}-${count.index}"
  desc        = var.desc
  agent       = var.agent
  target_node = var.target_node
  tags        = var.tags

  clone      = var.clone
  full_clone = var.full_clone

  qemu_os  = var.qemu_os
  cores    = var.cores
  sockets  = var.sockets
  cpu_type = var.cpu_type
  memory   = var.memory

  scsihw   = var.scsihw
  bootdisk = var.bootdisk

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.cloudinit_storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage   = var.disk_storage
          size      = var.disk_size
          iothread  = var.iothread
          replicate = var.replicate
        }
      }
    }
  }

  network {
    id     = var.network_id
    model  = var.network_model
    bridge = var.network_bridge
  }

  ipconfig0 = var.ipconfig0
  ciuser    = var.ciuser
  sshkeys   = var.sshkeys
}
