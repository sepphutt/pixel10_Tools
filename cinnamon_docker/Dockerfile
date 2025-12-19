# Basis-Image: offizielles Debian
FROM debian:latest

# Standard: keine zusätzlichen Pakete, nur System aktualisieren
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Standard-Arbeitsverzeichnis
WORKDIR /root

# Default Kommando (kann überschrieben werden)
CMD ["bash"]