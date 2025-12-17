#!/bin/bash
# Import all TAR/TAR.GZ files from ./docker_exports as Docker images
set -e

IMPORT_DIR="./docker_exports"

shopt -s nullglob
files=("$IMPORT_DIR"/*)
if [ ${#files[@]} -eq 0 ]; then
    echo "No files to import in: $IMPORT_DIR"
    exit 0
fi

for file in "${files[@]}"; do
    if [[ $file == *.tar.gz ]]; then
        echo "Importing compressed file: $file"
        gunzip -c "$file" | docker import - "$(basename "$file" .tar.gz)"
    elif [[ $file == *.tar ]]; then
        echo "Importing file: $file"
        docker import "$file" "$(basename "$file" .tar)"
    else
        echo "Skipping unknown format: $file"
    fi
done

echo "All images imported."