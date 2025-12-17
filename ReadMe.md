# Pixel 10 - Docker Projects & Tools

This repository contains Docker projects and tools intended for Pixel 10 development and testing. The main subproject provides a Cinnamon desktop container with SSH, VNC and noVNC access.

## Prerequisites

- Docker Desktop (includes Docker Compose)
- Basic knowledge of Docker and Linux
- On Linux hosts, you can use the helper script `cinnamon_Pixel10/docker_install.sh` to install Docker.

## Repository structure

```
pixel10_Tools/
├── ReadMe.md                # This file
└── cinnamon_Pixel10/        # Cinnamon desktop container project
	├── Dockerfile
	├── docker-compose.yml
	├── .env
	├── startup.sh
	├── supervisord.conf
	└── docker_builds/
		├── docker_export.sh
		└── docker_import.sh
```

## Quick start

1. Clone the repository:

```bash
git clone <repository-url>
cd pixel10_Tools
```

2. Change to the Cinnamon project directory:

```bash
cd cinnamon_Pixel10
```

3. Create or edit the `.env` file (required). Example:

```env
USER=docker
PASSWORD=secure_password_here
VNC_PASSWORD=another_secure_pw
```

4. Build and start the container:

```bash
docker compose up -d --build
```

5. Follow logs:

```bash
docker compose logs -f
```

6. Stop and remove containers:

```bash
docker compose down
```

## Ports

- 6080 → noVNC (web)
- 2222 → SSH (container port 22) — commented by default in `docker-compose.yml`
- 5901 → VNC — commented by default in `docker-compose.yml`

Enable SSH and VNC by uncommenting the lines under `services.cinnamon-desktop.ports` in `docker-compose.yml`.

## Export / Import containers (optional)

Use the helper scripts to export running containers and import them later:

Export all running containers as `.tar.gz` into `cinnamon_Pixel10/docker_builds/docker_exports`:

```bash
cd cinnamon_Pixel10/docker_builds
bash docker_export.sh
```

Import all archives from `docker_builds/docker_exports` as images:

```bash
cd cinnamon_Pixel10/docker_builds
bash docker_import.sh
```

Notes:
- The export script only exports currently running containers.
- Archives are created as `<container-name>.tar.gz`.
- After import, images are tagged from the archive filename.

## Security notes

- Do not commit `.env` to version control.
- For production, use SSH key authentication and disable root password login.
- Restrict network access with a firewall and allow only trusted IPs.

## Support and troubleshooting

- If VNC doesn't start, check `/var/log/supervisor/vncserver.log` inside the container.
- If noVNC is unreachable, check the `novnc` process with `supervisorctl status`.
- If Docker Compose commands differ, try `docker-compose` instead of `docker compose` depending on your environment.

## License & contribution

Contributions and improvements are welcome. Please open issues or pull requests on the repository.
