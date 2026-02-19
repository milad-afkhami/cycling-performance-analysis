#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Cleaning generated files..."

rm -f output/report.pdf output/report.tex output/report.docx output/report.log
rm -rf report_files/
rm -rf report_cache/

echo "Done."
