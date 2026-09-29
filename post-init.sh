#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")

echo "=== Diagnose ==="
echo "GITHUB_FILEPATH=${GITHUB_FILEPATH:-<nicht gesetzt>}"
echo "RENKU_BASE_URL_PATH=${RENKU_BASE_URL_PATH:-<nicht gesetzt>}"
echo "Arbeitsverzeichnis: $(pwd)"
echo "Inhalt:"
ls -la
echo "=== Ende Diagnose ==="

# Download des Notebooks aus Github
RAW_URL="https://raw.githubusercontent.com/${GITHUB_FILEPATH}"
TARGET="$(basename "${RAW_URL}")"
# curl -L -o "$TARGET" "$RAW_URL"
