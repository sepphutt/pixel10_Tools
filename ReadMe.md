# Pixel 10 - Docker Projects & Tools

## Overview
This repository contains Docker projects and tools specifically designed for Pixel 10 development and deployment.

## Prerequisites
- Docker Compose (included with Docker)
- Basic knowledge of containerization

### Project Structure
```
pixel10_Tools/
# Pixel 10 - Docker Projects & Tools
```
This repository contains Docker projects and tools intended for Pixel 10 development and testing. 

## Prerequisites

- Run build-docker.sh with sudo


## Repository structure

```
pixel10_Tools/
├── ReadMe.md                # This file
└── cinnamon_Pixel10/        # Cinnamon desktop container project
	├── Dockerfile
	├── docker-compose.yml
	├── .env
	├── startup.sh
	└── supervisord.conf
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

## Default ports

- 2222 → SSH (container port 22)
- 5901 → VNC
- 6080 → noVNC (web)

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
