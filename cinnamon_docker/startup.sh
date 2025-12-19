#!/bin/bash
set -e

echo ">>> Starte Container-Initialisierung..."

# Beispiel: Paketlisten aktualisieren (optional, falls du es nicht im Dockerfile machst)
apt-get update -y || true

# Beispiel: eigenes Setup (Platzhalter für deine Anpassungen)
# z.B. Benutzer anlegen, Dienste starten, Logs vorbereiten
# useradd -m myuser

echo ">>> Container bereit. Starte Bash..."
exec bash