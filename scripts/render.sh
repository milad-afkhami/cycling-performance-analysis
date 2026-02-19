#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Rendering report.Rmd -> output/report.pdf ..."
Rscript -e 'rmarkdown::render("report.Rmd", output_format = "pdf_document", output_dir = "output", quiet = TRUE)'
echo "Done: output/report.pdf"
