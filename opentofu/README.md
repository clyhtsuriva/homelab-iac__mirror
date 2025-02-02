# OpenTofu Infrastructure Provisioning

This repository contains OpenTofu configurations and modules for automating infrastructure provisioning in my homelab environment.

## **Overview**
OpenTofu is used to define, manage, and provision infrastructure as code (IaC). This setup provides a modular approach for creating and managing infrastructure efficiently.

## **Project Structure**
- **`README.md`** – Project overview and documentation.
- **`examples/`** – Sample configurations demonstrating how to use modules in different scenarios.
- **`main.tf`** – Primary OpenTofu configuration file, orchestrating resource provisioning.
- **`modules/`** – Reusable OpenTofu modules for provisioning infrastructure components.
- **`outputs.tf`** – Definitions of outputs to expose key resource attributes.
- **`provider.tf`** – Configuration for OpenTofu providers, such as Proxmox.
- **`terraform.tfvars`** – Variable values for customizing deployments.
- **`variables.tf`** – Definitions of input variables used across the configuration.
- **`versions.tf`** – Specifies required OpenTofu and provider versions to maintain compatibility.

## **Credentials**

There needs to be a file with credentials in them.
With this kind of content :

```tf
proxmox_api_url          = "https://<pve ip/fqdn>:<port>/api2/json"
proxmox_api_token_id     = "<id>"
proxmox_api_token_secret = "<token>"
```

Refer to this :

- https://opentofu.org/docs/language/values/variables/#variable-definition-precedence
- https://registry.terraform.io/providers/Telmate/proxmox/latest/docs

