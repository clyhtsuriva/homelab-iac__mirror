resource "proxmox_vm_qemu" "docker_server" {

  lifecycle {
    ignore_changes = [
      bootdisk,
    ]
  }

  name        = "docker-server"
  desc        = "Debian server with docker installed."
  agent       = 1 # Qemu Guest Agent
  target_node = var.proxmox_node
  tags        = "debian;docker"

  clone      = var.debian_server_bookworm_packer_image_name
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

# Run Ansible playbook after VM creation to install Docker
module "ansible_provision_docker_server" {
  source                = "./modules/ansible_provisioner"
  vm_ip                 = proxmox_vm_qemu.docker_server.default_ipv4_address # Pass only the VM's IP
  vm_username           = var.vm_username
  ssh_private_key_path  = var.ssh_private_key_path
  ansible_playbook_path = var.docker_ansible_playbook_path
}
