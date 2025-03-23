# Docker Configurations

This folder contains Docker-related configurations for containerized services.

## Structure
- **compose/**: Docker Compose files for running multi-container services.
  - Each service/app (e.g., Nginx, Grafana) has its own subfolder containing a `compose.yaml` file and any necessary environment files (e.g., `.env`).
- **images/**: Custom Dockerfiles for building custom images.

