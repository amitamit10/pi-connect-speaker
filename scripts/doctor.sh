#!/usr/bin/env bash
set -euo pipefail

APP_NAME="pi-connect-speaker"
DOCTOR="/opt/${APP_NAME}/venv/bin/pi-connect-speaker-doctor"

if [[ -x "${DOCTOR}" ]]; then
  exec "${DOCTOR}"
fi

PYTHONPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../src" && pwd)" exec python3 -m pi_connect_speaker.cli doctor
