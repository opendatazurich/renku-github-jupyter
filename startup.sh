#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")

bash "$SCRIPT_DIR"/post-init.sh

exec /cnb/process/jupyterlab
