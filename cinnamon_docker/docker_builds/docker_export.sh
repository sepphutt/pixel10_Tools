#!/bin/bash
# Export all running Docker containers as TAR.GZ archives
set -e

EXPORT_DIR="./docker_exports"
mkdir -p "$EXPORT_DIR"

if [ -z "$(docker ps -q)" ]; then
    echo "No running containers found."
    exit 0
fi

for container in $(docker ps -q); do
    name=$(docker inspect --format='{{.Name}}' "$container" | sed 's/^\/\(.*\)/\1/')
    tar_file="$EXPORT_DIR/${name}.tar"
    
    echo "Exporting container: $name"
    docker export "$container" -o "$tar_file"
    
    # Compress to .tar.gz
    gzip -f "$tar_file"
    echo "Saved as: ${tar_file}.gz"
done

echo "All running containers exported to: $EXPORT_DIR"