output "vm_ip" {
  description = "IP address of the provisioned VM"
  value       = proxmox_vm_qemu.docker_server.default_ipv4_address
}
