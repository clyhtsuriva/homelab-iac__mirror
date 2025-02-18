locals {
  all_vms = flatten([
    [proxmox_virtual_environment_vm.docker_server],
  ])
}

output "vm_ips" {
  description = "Mapping of VM names to their IP addresses"
  value       = { for vm in local.all_vms : vm.name => vm.ipv4_addresses[1][0] if can(vm.ipv4_addresses[1][0]) }
}
