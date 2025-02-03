resource "proxmox_vm_qemu" "ubuntu_server_noble" {

  lifecycle {
    ignore_changes = [
      bootdisk,
    ]
  }

  name        = "ubuntu-server-noble"
  desc        = "Plain ubuntu server noble"
  agent       = 1 # Qemu Guest Agent
  target_node = var.proxmox_node
  tags        = "ubuntu"

  clone      = var.ubuntu_server_noble_packer_image_name
  full_clone = true

  qemu_os  = "other"
  cores    = 2
  sockets  = 1
  cpu_type = "host"
  memory   = 4096

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
          size      = "20G"
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
