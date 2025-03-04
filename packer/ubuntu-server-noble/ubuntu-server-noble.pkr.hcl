# Ubuntu Server Noble (24.04.1)
# ---
# Packer Template to create an Ubuntu Server (Noble 24.04.1) on Proxmox

# Variable Definitions
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}


# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-noble-24-04-1-amd64" {

  # Proxmox Connection Settings
  proxmox_url              = "${var.proxmox_api_url}"
  username                 = "${var.proxmox_api_token_id}"
  token                    = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "pve"
  vm_id                = "998"
  vm_name              = "ubuntu-server-noble-24-04-1-amd64"
  template_description = "Ubuntu Server Noble 24.04.1 amd64"

  boot_iso {
    type         = "scsi"
    iso_file     = "local:iso/ubuntu-24.04.1-live-server-amd64.iso"
    unmount      = true
    iso_checksum = "sha512:3d518612aabbdb77fd6b49cb55b824fed11e40540e4af52f5f26174257715c93740f83079ea618b4d933081f0b1bc69d32b7885b7c75bc90da5ad3fe1814cfd4"
  }


  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-single"

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = "local-lvm"
    type         = "virtio"
    io_thread    = true
  }

  # VM CPU Settings
  cores = "1"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  # PACKER Boot Commands
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]

  boot         = "c"
  boot_wait    = "10s"
  communicator = "ssh"

  # PACKER Autoinstall Settings
  http_directory = "http"

  ssh_username         = "mas"
  ssh_private_key_file = "~/.ssh/id_ecdsa"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
  ssh_pty     = true
}

# Build Definition to create the VM Template
build {

  name    = "ubuntu-server-noble-24-04-1-amd64"
  sources = ["source.proxmox-iso.ubuntu-server-noble-24-04-1-amd64"]

  # Using ansible playbooks to configure common base
  provisioner "ansible" {
    playbook_file = "../../ansible/playbooks/common.yml"
    use_proxy     = false
    user          = "mas"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_CONFIG=${path.root}/../../ansible/ansible.cfg",
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

  # Random personal test, ID #4
  provisioner "shell" {
    inline = ["id"]
  }
}
