# Cinnamon Desktop Container (Pixel 10)

This folder contains a Docker project that provides a Cinnamon desktop environment with SSH, VNC and noVNC access. Sensitive values (username, passwords) are read from the `.env` file.

## Included files

- `Dockerfile` – Builds the image with Cinnamon, SSH, VNC and noVNC
- `docker-compose.yml` – Orchestration and port mapping
- `supervisord.conf` – Supervisor configuration for SSH, VNC, noVNC and optional VS Code
- `startup.sh` – Startup script that sets passwords and starts Supervisor
- `.env` – Environment variables (do not commit to VCS)
- `env.txt` – Explanation and example content for `.env`

## Quick start

1. Change to the project directory:

```bash
cd cinnamon_Pixel10
```

2. Create or edit `.env` (required). Example:

```env
USER=docker
PASSWORD=secure_password_here
VNC_PASSWORD=another_secure_pw
```

3. Build the image and start the container:

```bash
docker compose up -d --build
```

4. View logs:

```bash
docker compose logs -f
```

5. Stop the container:

```bash
docker compose down
```

## Access

- SSH: `ssh USER@localhost -p 2222` (username and password from `.env`)
- VNC (client): `localhost:5901`
- noVNC (browser): `http://localhost:6080`

## Default credentials

The example configuration uses `docker`/`docker` by default. Change these values in `.env`!

## Ports

- 2222 → SSH (container port 22)
- 5901 → VNC
- 6080 → noVNC (web)

## Security recommendations

- Never commit `.env` to a public repository.
- For production use SSH key authentication and disable root password login.
- Restrict access using a firewall (allow only trusted IPs).

## Troubleshooting

- If VNC does not start, check `/var/log/supervisor/vncserver.log` inside the container.
- If noVNC is unreachable, check the `novnc` supervisor process (`supervisorctl status`).

## Notes

- `docker compose` (v2) is used in the instructions. On some systems the command is `docker-compose`.
- The container uses `shm_size` configured in `docker-compose.yml` for better GUI performance.

## Export / Import (optional)

You can export running containers to archives and import them later.

Export all running containers as `.tar.gz` into `docker_builds/docker_exports`:

```bash
cd docker_builds
bash docker_export.sh
```

Import all archives from `docker_builds/docker_exports` as images:

```bash
cd docker_builds
bash docker_import.sh
```

Notes:
- The export script only exports currently running containers.
- Archives are created as `<container-name>.tar.gz` under `docker_builds/docker_exports`.
- After import, images are tagged from the archive filename.
