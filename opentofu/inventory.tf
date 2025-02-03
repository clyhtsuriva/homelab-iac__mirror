resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = <<-EOT
    [kube_control_plane]
    ${proxmox_vm_qemu.k8s_cp.default_ipv4_address}

    [etcd]
    ${proxmox_vm_qemu.k8s_cp.default_ipv4_address}

    [kube_node]
    %{for vm in proxmox_vm_qemu.k8s_worker[*]}${vm.default_ipv4_address}
    %{endfor}

    [k8s_cluster:children]
    kube_control_plane
    kube_node
  EOT
}
