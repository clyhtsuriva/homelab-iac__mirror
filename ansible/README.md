# Ansible Configurations

This folder contains Ansible playbooks and roles for configuration management.

## Structure
- **roles/**: Reusable Ansible roles (e.g., Docker, Nginx).
- **playbooks/**: Playbooks for orchestrating tasks.

## Install requirements

```sh
ansible-galaxy collection install -r requirements.yml --upgrade
```
