locals {
  all_vms = flatten([
    [proxmox_vm_qemu.k8s_cp],
    proxmox_vm_qemu.k8s_worker,
    [proxmox_vm_qemu.docker_server],
  ])
}

output "vm_ips" {
  description = "Mapping of VM names to their IP addresses"
  value       = { for vm in local.all_vms : vm.name => vm.default_ipv4_address if can(vm.default_ipv4_address) }
}
