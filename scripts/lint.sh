#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! Rscript -e 'if (!requireNamespace("lintr", quietly = TRUE)) quit(status = 1)' 2>/dev/null; then
    echo "Error: lintr package not installed. Run:"
    echo "  Rscript -e 'install.packages(\"lintr\")'"
    exit 1
fi

echo "Extracting and linting R code from report.Rmd..."

Rscript -e '
library(lintr)
results <- lint("report.Rmd")
if (length(results) > 0) {
    print(results)
    cat("\n", length(results), "issue(s) found.\n")
    quit(status = 1)
} else {
    cat("No issues found.\n")
}
'
