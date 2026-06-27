provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = true
}

provider "openstack" {
  cloud = var.openstack_cloud_name
}
