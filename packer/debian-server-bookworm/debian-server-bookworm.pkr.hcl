# Debian Server Bookworm (12.9.0)
# ---
# Packer Template to create a Debian Server (Bookworm 12.9.0) on Proxmox

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

variable "vm_hostname" {
  type    = string
  default = "debian-server-bookworm-12-9-0-amd64"
}

variable "ssh_private_key_file" {
  type    = string
  default = "~/.ssh/id_ecdsa"
}

# Resource Definition for the VM Template
source "proxmox-iso" "debian-server-bookworm-12-9-0-amd64" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "pve"
  vm_id                = "100"
  vm_name              = "${var.vm_hostname}"
  template_description = "Debian Server Bookworm Image Test 1"

  # VM OS Settings
  boot_iso {
    type         = "scsi"
    iso_file     = "local:iso/debian-12.9.0-amd64-netinst.iso"
    unmount      = true
    iso_checksum = "sha512:9ebe405c3404a005ce926e483bc6c6841b405c4d85e0c8a7b1707a7fe4957c617ae44bd807a57ec3e5c2d3e99f2101dfb26ef36b3720896906bdc3aaeec4cd80"
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
    "<wait><esc><wait>",
    "auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=${var.vm_hostname}<enter>"
  ]

  boot         = "c"
  boot_wait    = "20s"
  communicator = "ssh"

  # PACKER Autoinstall Settings
  http_directory = "http"
  # (Optional) Bind IP Address and Port
  # http_bind_address = "0.0.0.0"
  # http_port_min     = 8802
  # http_port_max     = 8802

  ssh_username = "mas"
  ssh_private_key_file = "${var.ssh_private_key_file}"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
  ssh_pty     = true
}

# Build Definition to create the VM Template
build {
  name    = "debian-server-bookworm-12-9-0-amd64"
  sources = ["source.proxmox-iso.debian-server-bookworm-12-9-0-amd64"]

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

  # Copy default cloud-init config
  provisioner "file" {
    source      = "files/cloud.cfg"
    destination = "/tmp/cloud.cfg"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/cloud.cfg /etc/cloud/cloud.cfg"]
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

}
