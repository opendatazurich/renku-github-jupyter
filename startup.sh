#!/bin/bash
set -euo pipefail

# Leerer Wert oder Platzhalter NONE -> JupyterLab ohne bestimmtes Notebook starten.
if [ -z "${GITHUB_FILEPATH:-}" ] || [ "${GITHUB_FILEPATH}" = "NONE" ]; then
    echo "GITHUB_FILEPATH nicht gesetzt -> Standard-Start (JupyterLab ohne bestimmtes Notebook)."
    exec /cnb/process/jupyterlab
fi

# /blob/ aus github.com-URLs entfernen -> roher Raw-Pfad.
RAW_PATH="$(printf '%s' "$GITHUB_FILEPATH" | sed -E 's#/blob/#/#g')"
RAW_URL="https://raw.githubusercontent.com/${RAW_PATH}"
TARGET="$(basename "$RAW_URL")"

echo "Lade herunter: $RAW_URL"
if ! curl -fsSL --max-time 60 -o "$TARGET" "$RAW_URL"; then
    echo "Download fehlgeschlagen ($RAW_URL) -> JupyterLab ohne bestimmtes Notebook." >&2
    exec /cnb/process/jupyterlab
fi

# Notebook im aktuellen Arbeitsverzeichnis ablegen und per Positional-Argument öffnen.
NOTEBOOK="$PWD/$TARGET"
echo "Öffnet: $NOTEBOOK"
exec /cnb/process/jupyterlab "$NOTEBOOK"
