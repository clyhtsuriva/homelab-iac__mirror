terraform {
  required_version = ">= 1.8.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}
