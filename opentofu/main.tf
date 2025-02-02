resource "proxmox_vm_qemu" "docker_server" {

  name        = "docker-server"
  desc        = "Debian server with docker installed."
  agent       = 1 # Qemu Guest Agent
  target_node = var.proxmox_node
  tags        = "debian,docker"

  clone      = var.packer_image_name
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

# Run Ansible playbook after VM creation
resource "null_resource" "ansible_provisioner" {
  triggers = {
    vm_id = proxmox_vm_qemu.docker_server.id
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=${path.root}/../ansible/ansible.cfg ansible-playbook \
        -i '${proxmox_vm_qemu.docker_server.default_ipv4_address},' \
        -u ${var.vm_username} \
        --private-key ${var.ssh_private_key_path} \
        ${var.ansible_playbook_path}
    EOT
  }

  depends_on = [proxmox_vm_qemu.docker_server]
}
