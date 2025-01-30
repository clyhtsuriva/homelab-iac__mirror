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
    type = string
    sensitive = true
}


# Resource Definiation for the VM Template
source "proxmox-iso" "debian-server-bookworm-test-1" {

    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true

    # VM General Settings
    node = "pve"
    vm_id = "101"
    vm_name = "debian-server-bookworm-test-1"
    template_description = "Debian Server Bookworm Image Test 1"

    # VM OS Settings
    # (Option 1) Local ISO File
    # iso_file = "local:iso/ubuntu-24.04.1-live-server-amd64.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
    # iso_checksum = "8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
    # iso_storage_pool = "local"
    # unmount_iso = true
   boot_iso {
      type = "scsi"
      iso_file = "local:iso/debian-12.9.0-amd64-netinst.iso"
      unmount = true
      iso_checksum = "sha512:9ebe405c3404a005ce926e483bc6c6841b405c4d85e0c8a7b1707a7fe4957c617ae44bd807a57ec3e5c2d3e99f2101dfb26ef36b3720896906bdc3aaeec4cd80"
    }


    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "1"

    # VM Memory Settings
    memory = "2048"

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    }

    # VM Cloud-Init Settings
    cloud_init = true
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

    boot                    = "c"
    boot_wait               = "10s"
    communicator            = "ssh"

    # PACKER Autoinstall Settings
    http_directory          = "http"
    # (Optional) Bind IP Address and Port
    # http_bind_address       = "0.0.0.0"
    # http_port_min           = 8802
    # http_port_max           = 8802

    ssh_username            = "mas"

    # (Option 1) Add your Password here
    # ssh_password        = "your-password"
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    ssh_private_key_file    = "~/.ssh/id_ecdsa"

    # Raise the timeout, when installation takes longer
    ssh_timeout             = "30m"
    ssh_pty                 = true
}

# Build Definition to create the VM Template
build {

    name = "debian-server-bookworm-test-1"
    sources = ["source.proxmox-iso.debian-server-bookworm-test-1"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
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

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    # Random personal test, ID #4
        provisioner "shell" {
    	inline = [ "id" ]
    }
}
