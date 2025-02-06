resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = <<-EOT
    [kube_control_plane]
    ${module.k8s_control_plane.vm.default_ipv4_address}

    [etcd]
    ${module.k8s_control_plane.vm.default_ipv4_address}

    [kube_node]
    %{for vm in module.k8s_worker.vms}${vm.default_ipv4_address}
    %{endfor}

    [k8s_cluster:children]
    kube_control_plane
    kube_node
  EOT
}
