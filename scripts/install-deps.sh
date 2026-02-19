#!/usr/bin/env bash
set -euo pipefail

echo "=== System dependencies ==="

if command -v apt &>/dev/null; then
    echo "Installing system packages via apt..."
    sudo apt update
    sudo apt install -y r-base texlive-xetex texlive-latex-extra texlive-fonts-extra \
        pandoc inotify-tools
elif command -v dnf &>/dev/null; then
    echo "Installing system packages via dnf..."
    sudo dnf install -y R texlive-xetex texlive-latex texlive-collection-fontsextra \
        pandoc inotify-tools
else
    echo "Warning: Could not detect package manager (apt/dnf)."
    echo "Please install manually: R, texlive-xetex, pandoc, inotify-tools"
fi

echo ""
echo "=== R packages ==="

Rscript -e '
pkgs <- c("rmarkdown", "tidyverse", "kableExtra", "car",
          "dunn.test", "effectsize", "ggpubr", "lintr")
missing <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(missing) > 0) {
    cat("Installing:", paste(missing, collapse = ", "), "\n")
    install.packages(missing, repos = "https://cloud.r-project.org")
} else {
    cat("All R packages already installed.\n")
}
'

echo ""
echo "Done."
