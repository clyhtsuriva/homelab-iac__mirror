resource "proxmox_virtual_environment_vm" "docker_server" {
  name        = "docker-server"
  description = "Debian server with docker installed."
  tags        = ["debian", "docker"]
  node_name   = var.proxmox_node

  clone {
    vm_id = var.debian_server_bookworm_packer_image_id # Use the VM ID of the template
    full  = true
  }

  agent {
    enabled = true # Qemu Guest Agent
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    interface    = "virtio0"
    datastore_id = "local-lvm"
    size         = 20
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.150/24"
        gateway = "192.168.1.1"
      }
    }

    user_account {
      username = var.vm_username
      keys     = [var.ssh_public_key]
    }
  }
}


# Master Node (Control Plane)
resource "proxmox_virtual_environment_vm" "k3s_master" {
  count     = 1
  name      = "k3s-master-${count.index}"
  node_name = var.proxmox_node
  tags      = ["ubuntu", "k8s", "k3s_master"]


  clone {
    vm_id = var.ubuntu_server_noble_packer_image_id
    full  = true
  }

  agent {
    enabled = true # Qemu Guest Agent
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    interface    = "virtio0"
    datastore_id = "local-lvm"
    size         = 20
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.14${count.index}/24"
        gateway = "192.168.1.1"
      }
    }

    user_account {
      username = var.vm_username
      keys     = [var.ssh_public_key]
    }
  }
}

# Worker Nodes
resource "proxmox_virtual_environment_vm" "k3s_worker" {
  count     = 2
  name      = "k3s-worker-${count.index}"
  node_name = var.proxmox_node
  tags      = ["debian", "k8s", "k3s_worker"]

  clone {
    vm_id = var.debian_server_bookworm_packer_image_id
    full  = true
  }

  agent {
    enabled = true # Qemu Guest Agent
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    interface    = "virtio0"
    datastore_id = "local-lvm"
    size         = 20
    discard      = "on"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.13${count.index}/24"
        gateway = "192.168.1.1"
      }
    }

    user_account {
      username = var.vm_username
      keys     = [var.ssh_public_key]
    }
  }
}

# OVH Openstack
## Simple Debian Node
#resource "openstack_compute_keypair_v2" "keypair" {
#  name       = "tmv-keypair"
#  public_key = var.ssh_public_key
#}
#
#resource "openstack_compute_instance_v2" "debian13-uefi-test" {
#  name      = "debian13-uefi-test"
#  image_id  = "e9e08190-20ce-49f6-9d72-e76ec22de82e" # Debian 13 UEFI
#  flavor_id = "dc3fe9e7-e374-4ad8-b200-fa3bdf45069f" # d2-2
#  key_pair  = "tmv-keypair"
#
#  security_groups = ["default"]
#
#  metadata = {
#    tags = "debian,vps,docker"
#  }
#
#  network {
#    name = "Ext-Net"
#  }
#}
