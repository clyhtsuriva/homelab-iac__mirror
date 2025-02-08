resource "null_resource" "ansible_provisioner" {
  triggers = {
    ip_or_inventory = coalesce(var.vm_ip, var.inventory_file_path)  # Choose based on what is provided
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=${path.root}/../ansible/ansible.cfg ansible-playbook -b -v \
        -i ${var.inventory_file_path != null ? var.inventory_file_path : "${var.vm_ip},"} \
        -u ${var.vm_username} \
        --private-key ${var.ssh_private_key_path} \
        ${var.ansible_playbook_path}
    EOT
  }
}
