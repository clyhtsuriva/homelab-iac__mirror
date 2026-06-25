provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = true
}

provider "openstack" {
  # user_name   = var.openstack_user_name
  # tenant_name = var.openstack_project_name
  # password    = var.openstack_password
  # auth_url    = var.openstack_api_url
  # region      = var.openstack_region_name
}
