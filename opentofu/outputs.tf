# Define all VMs
locals {
  all_vms = flatten([
    [proxmox_virtual_environment_vm.docker_server],
    [for vm in proxmox_virtual_environment_vm.k3s_master : vm],
    [for vm in proxmox_virtual_environment_vm.k3s_worker : vm]
  ])
}

output "vm_ips" {
  description = "Mapping of VM names to their IP addresses"
  value       = { for vm in local.all_vms : vm.name => vm.ipv4_addresses[1][0] if can(vm.ipv4_addresses[1][0]) }
}
