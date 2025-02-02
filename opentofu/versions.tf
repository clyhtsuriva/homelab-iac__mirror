terraform {
  required_version = ">= 1.8.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 0.0.0"
    }
  }
}
