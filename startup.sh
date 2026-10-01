#!/bin/bash
set -euo pipefail

# JupyterLab-Konfig: default_url steuert, welches Notebook automatisch geöffnet wird.
# Der Renku-Launcher ignoriert weder die ARGS-Variable noch Positional-Argumente (ersetzt
# damit den Entrypoint -> „Permission denied"), daher wird die Konfig direkt geschrieben.
CONFIG_DIR="${HOME}/.jupyter"
mkdir -p "$CONFIG_DIR"
CONFIG_FILE="$CONFIG_DIR/jupyter_lab_config.py"

reset_to_default() {
    printf 'c.LabApp.default_url = "/lab"\n' > "$CONFIG_FILE"
}

# Leerer Wert oder Platzhalter NONE -> JupyterLab ohne bestimmtes Notebook starten.
if [ -z "${GITHUB_FILEPATH:-}" ] || [ "${GITHUB_FILEPATH}" = "NONE" ]; then
    echo "GITHUB_FILEPATH nicht gesetzt -> Standard-Start (JupyterLab ohne bestimmtes Notebook)."
    reset_to_default
    exec /cnb/process/jupyterlab
fi

# /blob/ aus github.com-URLs entfernen -> roher Raw-Pfad.
RAW_PATH="$(printf '%s' "$GITHUB_FILEPATH" | sed -E 's#/blob/#/#g')"
RAW_URL="https://raw.githubusercontent.com/${RAW_PATH}"
TARGET="$(basename "$RAW_URL")"

echo "Lade herunter: $RAW_URL"
if ! curl -fsSL --max-time 60 -o "$TARGET" "$RAW_URL"; then
    echo "Download fehlgeschlagen ($RAW_URL) -> JupyterLab ohne bestimmtes Notebook." >&2
    reset_to_default
    exec /cnb/process/jupyterlab
fi

# Notebook liegt im Arbeitsverzeichnis (RENKU_WORKING_DIR) und wird per LabApp.default_url
# automatisch geöffnet, wenn die Session-URL aufgerufen wird.
echo "Öffnet: $PWD/$TARGET"
printf 'c.LabApp.default_url = "/lab/tree/%s"\n' "$TARGET" > "$CONFIG_FILE"
exec /cnb/process/jupyterlab
