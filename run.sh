#!/usr/bin/env zsh
set -euo pipefail

# Usage:
#   ./run.sh
#   ./run.sh 8011
#
# What this script does:
# 1) Uses port 8001 by default (or a custom port from arg #1)
# 2) Stops any process already listening on that port
# 3) Starts FastAPI with auto-reload
#
# Open after start:
#   http://127.0.0.1:<port>/ui
#   http://127.0.0.1:<port>/recommendation

PORT="${1:-8001}"

if [[ ! -x ".venv/bin/python" ]]; then
  echo "Error: .venv/bin/python not found. Create/activate your virtual environment first."
  exit 1
fi

# Stop any existing process bound to this port to keep startup predictable.
PIDS_RAW=$(lsof -tiTCP:"$PORT" -sTCP:LISTEN || true)
if [[ -n "${PIDS_RAW}" ]]; then
  PIDS=( ${(f)PIDS_RAW} )
  echo "Stopping process on port ${PORT}: ${PIDS[*]}"
  for pid in "${PIDS[@]}"; do
    if [[ "$pid" == <-> ]]; then
      kill "$pid" || true
    fi
  done
  sleep 1
fi

echo "Starting API on http://127.0.0.1:${PORT}"
exec ./.venv/bin/python -m uvicorn api.load_rf_model:app --reload --port "$PORT"
