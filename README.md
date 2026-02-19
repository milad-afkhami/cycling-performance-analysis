# Cycling Performance Analysis

Statistical analysis of rider performance across terrain types in a cycling manager game. Written as an [application report for M.Sc. Data Science at TU Dortmund University (Summer Semester 2026)](https://statistik.tu-dortmund.de/storages/statistik/r/Downloads/Studium/Studiengaenge-Infos/Data_Science/Application_Report_Master_Data_Science_Summer_2026.pdf) by [Milad Afkhamipour Sharabyani](https://milad-afkhami.com).

## Research Questions

1. Do rider classes differ significantly in overall performance?
2. Does the performance difference between rider classes depend on stage type (flat, hills, mountain)?

## Dataset

3,496 observations across 184 riders and 19 stages.

Variables:

- Rider name
- Rider class: All Rounder / Climber / Sprinter / Unclassed
- stage identifier
- performance points: 0–304
- terrain type: flat / hills / mount

Provided by the [Faculty of Statistics at TU Dortmund](https://statistik.tu-dortmund.de/storages/statistik/r/Downloads/Studium/Studiengaenge-Infos/Data_Science/cycling.txt) and stored in [cycling.txt](./cycling.txt) file.

## Methods

Nonparametric approach due to violated normality and homoscedasticity assumptions: Kruskal-Wallis rank sum tests, Dunn's post-hoc pairwise comparisons with Bonferroni correction, and stratified analysis by stage class.

## Scripts

- [Install dependencies](./scripts/install-deps.sh)
- [Render report to output/report.pdf](./scripts/render.sh)
- [Auto-render on save](./scripts/watch.sh)
- [Remove generated files](./scripts/clean.sh)
- [Lint R code chunks](./scripts/lint.sh)

## Tools

- R
- R Markdown
- XeLaTeX
- Pandoc
- R packages:
  - tidyverse
  - kableExtra
  - car
  - dunn.test
  - effectsize
  - ggpubr
