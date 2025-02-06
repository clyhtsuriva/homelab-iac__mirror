locals {
  all_vms = flatten([
    [module.k8s_control_plane.vm],
    module.k8s_worker.vms,
    [proxmox_vm_qemu.docker_server],
  ])
}

output "vm_ips" {
  description = "Mapping of VM names to their IP addresses"
  value       = { for vm in local.all_vms : vm.name => vm.default_ipv4_address if can(vm.default_ipv4_address) }
}
