# Pixel 10 - Docker Projects & Tools

## Overview
This repository contains Docker projects and tools specifically designed for Pixel 10 development and deployment.

## Prerequisites
- Docker Compose (included with Docker)
- Basic knowledge of containerization

### Project Structure
```
pixel10_Tools/
├── cinnamon_Pixel10
```

## Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd pixel10_Tools
```

### 2. Build Docker Images
```bash
docker-compose build
```

### 3. Start Services
```bash
docker-compose up -d
```

### 4. Stop Services
```bash
````markdown
# Pixel 10 - Docker Projekte & Tools

## Übersicht
Dieses Repository enthält Docker-Projekte und Hilfsdateien für die Pixel 10 Umgebung. Das wichtigste Projekt ist ein Cinnamon-Desktop-Container mit SSH-, VNC- und noVNC-Zugriff.

## Voraussetzungen
- Docker (inkl. Docker Compose)
- Grundkenntnisse in Docker und Linux

## Projektstruktur
```
pixel10_Tools/
├── cinnamon_Pixel10/
	├── Dockerfile
	├── docker-compose.yml
	├── .env
	├── startup.sh
	└── supervisord.conf
```

## Schnellstart

1. Repository klonen

```bash
git clone <repository-url>
cd pixel10_Tools
```

2. In das Projektverzeichnis des Cinnamon-Containers wechseln

```bash
cd cinnamon_Pixel10
```

3. `.env` anpassen (Pflicht — Passwörter setzen)

```bash
# Beispiel: .env bearbeiten
nano .env
```

4. Image bauen und Container starten

```bash
docker compose up -d --build
```

5. Container stoppen

```bash
docker compose down
```

## Hinweise
- Achte darauf, die Datei `.env` nicht in öffentliche Repositories zu pushen (in `.gitignore` eingetragen).
- Standardports: SSH 2222, VNC 5901, noVNC 6080 (kann in `docker-compose.yml` geändert werden).

````
