# Ansible Configurations

This folder contains Ansible playbooks and roles for configuration management.

## Structure
- **roles/**: Reusable Ansible roles (e.g., Docker, Nginx).
- **playbooks/**: Playbooks for orchestrating tasks.

## Known Issue
- `community.proxmox` v1.4.0 shows deprecation warning about `_collections_compat`
- Fix is in PR #242, awaiting release
- Warning will disappear when collection is updated
