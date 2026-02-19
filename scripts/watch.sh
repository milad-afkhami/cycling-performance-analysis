#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v inotifywait &>/dev/null; then
    echo "Error: inotifywait not found. Install it with:"
    echo "  sudo apt install inotify-tools"
    exit 1
fi

echo "Watching report.Rmd for changes... (Ctrl+C to stop)"
echo "Initial render:"
bash scripts/render.sh

while inotifywait -q -e modify report.Rmd; do
    echo ""
    echo "Change detected — re-rendering..."
    bash scripts/render.sh || echo "Render failed."
done
