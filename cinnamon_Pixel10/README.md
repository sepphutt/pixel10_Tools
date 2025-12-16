# Docker Cinnamon Desktop with SSH and noVNC

This Docker container provides a full Cinnamon desktop environment with SSH and noVNC access.

## Generated files

- `Dockerfile` - Image with Cinnamon, SSH, VNC and noVNC
- `docker-compose.yml` - Orchestration with port mappings (reads sensitive values from `.env`)
- `supervisord.conf` - Process manager for services
- `startup.sh` - Startup script
- `.env` - Environment variables (passwords), do NOT commit to VCS
- `env.txt` - Instructions and example content for `.env`

## Build and start

Before starting, edit `.env` to set secure passwords:

```bash
# Example: edit the file
nano .env

# Build and start the container
docker compose up -d --build
```

## Access

### SSH
```bash
ssh $USER@localhost -p 2222
```
- Username and password are defined in the `.env` file

### noVNC (Web browser)
```
http://localhost:6080
```
- VNC password is defined in the `.env` file

### VNC client
```
localhost:5901
```
- VNC password is defined in the `.env` file

## Example default credentials (initial values)

- Username: `docker`
- Password: `docker`
- Root password: `docker`
- VNC password: `docker`

## Ports


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
