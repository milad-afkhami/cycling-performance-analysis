# PRD: Application Report — M.Sc. Data Science, TU Dortmund (Summer 2026)

---

## 0. Context for AI Assistant

**This is a standalone document.** You (Claude Code or any AI assistant) have NO prior context about this project. Everything you need is in this PRD. Do not ask the user for additional context — it is all here.

**What this project is:** The user is applying to a Master's program in Data Science at TU Dortmund University (Germany). As part of the application, they must write a 10-page statistical report analyzing a provided dataset. The report is evaluated pass/fail by the Faculty of Statistics. It must demonstrate the ability to perform and present a data analysis task using proper statistical methodology.

**User profile:**

- Name: Milad Afkhamipour Sharabyani
- OS: Ubuntu 24.04
- R experience: None — this is their first time using R. Provide complete, ready-to-run code.
- Writing experience: No prior formal statistical reports. Provide text scaffolding and templates.
- Timeline: < 5 days. Be efficient. Don't over-engineer.
- Tool: RMarkdown (.Rmd) → PDF via LaTeX (tinytex)

**Your first task before writing any report content:** Create the project folder and all supporting files. Execute these steps in order:

```bash
# Step 1: Create project directory
mkdir -p ~/tu-dortmund-report
cd ~/tu-dortmund-report

# Step 2: Download the dataset
wget -O cycling.txt "https://statistik.tu-dortmund.de/storages/statistik/r/Downloads/Studium/Studiengaenge-Infos/Data_Science/cycling.txt"

# Step 3: Download citation style file
wget -O apa.csl "https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl"
```

Then create these files from the contents provided in Sections 4.2, 4.3, and 4.4 of this PRD:

- `header.tex` — LaTeX header (Section 4.2)
- `references.bib` — Bibliography (Section 4.3)

Then create `report.Rmd` following the specifications in Section 4 onward.

**R package installation (run once before rendering):**

```r
install.packages("tinytex")
tinytex::install_tinytex()
install.packages(c("rmarkdown", "knitr", "tidyverse", "kableExtra", "car", "dunn.test", "effectsize", "ggpubr"))
```

**System dependencies (Ubuntu 24.04):**

```bash
sudo apt update
sudo apt install -y r-base r-base-dev libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
```

---

## 0.1 Dataset Summary (Pre-Computed Reference)

The dataset `cycling.txt` is space-separated with quoted strings. Use `read.table("cycling.txt", header = TRUE, quote = "\"")` to load it. Below is a complete summary so you do not need to re-derive these values. Use them to verify your code outputs match.

**Structure:**

- 3,496 rows, 5 columns
- No missing values (NA)
- 184 unique riders, 19 unique stages (X1–X21; X5 and X13 absent)
- 61.8% of all point values are zero (2,161 out of 3,496)

**Variables:**

| Column        | Type               | Levels / Range                                                                                                                      |
| ------------- | ------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `all_riders`  | Character          | 184 unique rider names (e.g., "Tadej Pogačar", "Jonas Vingegaard")                                                                  |
| `rider_class` | Factor (4 levels)  | All Rounder (17 riders, 323 rows), Climber (23 riders, 437 rows), Sprinter (29 riders, 551 rows), Unclassed (115 riders, 2185 rows) |
| `stage`       | Factor (19 levels) | X1, X2, X3, X4, X6, X7, X8, X9, X10, X11, X12, X14, X15, X16, X17, X18, X19, X20, X21                                               |
| `points`      | Integer            | Min: 0, Max: 304                                                                                                                    |
| `stage_class` | Factor (3 levels)  | flat (6 stages, 1104 rows), hills (8 stages, 1472 rows), mount (5 stages, 920 rows)                                                 |

**Summary statistics by rider class:**

| Rider Class | n (rows) | # Riders | Mean  | Median | SD    | Min | Max |
| ----------- | -------- | -------- | ----- | ------ | ----- | --- | --- |
| All Rounder | 323      | 17       | 37.69 | 12.0   | 63.96 | 0   | 304 |
| Climber     | 437      | 23       | 20.17 | 6.0    | 43.45 | 0   | 269 |
| Sprinter    | 551      | 29       | 15.04 | 0.0    | 41.83 | 0   | 272 |
| Unclassed   | 2185     | 115      | 6.42  | 0.0    | 23.28 | 0   | 260 |

**Mean points by rider class × stage class (the key interaction table):**

| Rider Class | flat  | hills | mount |
| ----------- | ----- | ----- | ----- |
| All Rounder | 15.44 | 35.79 | 67.42 |
| Climber     | 5.09  | 21.67 | 35.86 |
| Sprinter    | 38.98 | 5.20  | 2.04  |
| Unclassed   | 5.74  | 9.10  | 2.95  |

**Key patterns to confirm in your analysis:**

- All Rounders score highest overall; Unclassed lowest
- Sprinters dominate flat stages (38.98) but near-zero on mountains (2.04)
- All Rounders peak on mountain stages (67.42)
- Climbers follow a similar but weaker mountain pattern to All Rounders
- Unclassed riders are consistently low across all terrain types
- Heavy right skew in all groups (mean >> median)
- Kruskal-Wallis test will be highly significant (p ≈ 0) for all comparisons
- All pairwise Dunn's tests will likely be significant after Bonferroni correction

**Expected statistical test results (approximate):**

- Overall Kruskal-Wallis: H(3) will be very large (>100), p < 2.2e-16
- All three stratified Kruskal-Wallis tests (flat, hills, mount) will be significant at α/3 = 0.0167
- Shapiro-Wilk: p < 0.001 for all groups (normality rejected)
- Levene's test: p < 0.001 (equal variance rejected)

---

## Document Metadata

| Field        | Value                                                       |
| ------------ | ----------------------------------------------------------- |
| Author       | Milad Afkhamipour Sharabyani                                |
| Target       | TU Dortmund, Faculty of Statistics, Prof. Dr. Andreas Groll |
| Deliverable  | 10-page PDF statistical report                              |
| Tool         | RMarkdown (.Rmd) → PDF via LaTeX (tinytex)                  |
| OS           | Ubuntu 24.04                                                |
| R Experience | None (Claude Code assisted)                                 |
| Timeline     | < 5 days                                                    |
| Language     | English                                                     |

---

## 1. Project Summary

Write a 10-page statistical report analyzing a cycling manager game dataset (`cycling.txt`). The report must demonstrate the ability to understand, solve, and present a data analysis task. It is evaluated as pass/fail ("at least sufficient") and is mandatory for admission.

**Research Questions:**

1. Is there a difference in performance between rider classes?
2. How do rider classes compare across different stage classes?

**Dataset:** 3,496 rows × 5 columns. 184 riders across 19 stages. Variables: `all_riders` (rider name), `rider_class` (All Rounder / Climber / Sprinter / Unclassed), `stage` (X1–X21, missing X5 & X13), `points` (0–304), `stage_class` (flat / hills / mount).

---

## 2. Environment Setup

All setup instructions are in **Section 0** above. Follow those steps first. To verify the setup works, create a test file `test.Rmd`:

````markdown
---
title: "Test"
output: pdf_document
---

```{r}
library(tidyverse)
cycling <- read.table("cycling.txt", header = TRUE, quote = "\"")
str(cycling)
```
````

Render it:

```r
rmarkdown::render("test.Rmd")
```

If `test.pdf` is generated with the data structure output → setup is complete. Proceed to Section 3.

---

## 3. Report Structure — Exactly 10 Pages

| Page(s) | Section                 | Content                                                               |
| ------- | ----------------------- | --------------------------------------------------------------------- |
| 1       | Title Page              | Name, title, date, university                                         |
| 2       | Table of Contents       | Auto-generated via `\tableofcontents`                                 |
| 3       | 1. Introduction         | Real-world motivation, RQs, main findings preview, structure overview |
| 3–4     | 2. Data Description     | Variables, scale levels, data quality, group sizes                    |
| 4–6     | 3. Statistical Methods  | Mathematical definitions of every method used                         |
| 6–8     | 4. Results              | 4.1 Descriptive Analysis, 4.2 Inferential Analysis                    |
| 9       | 5. Summary & Discussion | Answers to RQs, interpretation, limitations, future work              |
| 10      | Bibliography            | All cited references                                                  |

**Appendix** (optional, beyond the 10 pages): max 3 additional pages for supplementary tables/figures.

---

## 4. RMarkdown File Specification

### 4.1 YAML Header

```yaml
---
title: "Application Report: Analysis of Rider Performance in a Cycling Manager Game"
subtitle: "Application for M.Sc. Data Science — Summer Semester 2026"
author: "Milad Afkhamipour Sharabyani"
date: "`r format(Sys.Date(), '%B %d, %Y')`"
output:
  pdf_document:
    toc: true
    toc_depth: 3
    number_sections: true
    fig_caption: true
    latex_engine: xelatex
    keep_tex: false
    includes:
      in_header: header.tex
fontsize: 12pt
geometry: margin=2.5cm
linestretch: 1.5
bibliography: references.bib
csl: apa.csl
link-citations: true
---
```

### 4.2 LaTeX Header File (`header.tex`)

Create a file called `header.tex` in the same directory:

```latex
\usepackage{float}
\usepackage{booktabs}
\usepackage{caption}
\captionsetup[figure]{font=small, labelfont=bf}
\captionsetup[table]{font=small, labelfont=bf}
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\rhead{M. Afkhamipour Sharabyani}
\lhead{Application Report — M.Sc. Data Science}
\rfoot{Page \thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

% Title page formatting
\usepackage{titling}
\pretitle{\begin{center}\LARGE\bfseries}
\posttitle{\end{center}\vspace{0.5em}}
\preauthor{\begin{center}\large}
\postauthor{\end{center}}
\predate{\begin{center}\large}
\postdate{\end{center}}
```

### 4.3 Bibliography File (`references.bib`)

Create `references.bib`:

```bibtex
@article{kruskal1952,
  author  = {Kruskal, William H. and Wallis, W. Allen},
  title   = {Use of Ranks in One-Criterion Variance Analysis},
  journal = {Journal of the American Statistical Association},
  volume  = {47},
  number  = {260},
  pages   = {583--621},
  year    = {1952}
}

@article{dunn1964,
  author  = {Dunn, Olive Jean},
  title   = {Multiple Comparisons Using Rank Sums},
  journal = {Technometrics},
  volume  = {6},
  number  = {3},
  pages   = {241--252},
  year    = {1964}
}

@book{tukey1977,
  author    = {Tukey, John W.},
  title     = {Exploratory Data Analysis},
  publisher = {Addison-Wesley},
  year      = {1977}
}

@book{fahrmeir2016,
  author    = {Fahrmeir, Ludwig and Heumann, Christian and K{\"u}nstler, Rita and Pigeot, Iris and Tutz, Gerhard},
  title     = {Statistik: Der Weg zur Datenanalyse},
  edition   = {8},
  publisher = {Springer},
  year      = {2016}
}

@article{tomczak2014,
  author  = {Tomczak, Maciej and Tomczak, Ewa},
  title   = {The Need to Report Effect Size Estimates Revisited},
  journal = {Trends in Sport Sciences},
  volume  = {21},
  number  = {1},
  pages   = {19--25},
  year    = {2014}
}

@article{shapiro1965,
  author  = {Shapiro, S. S. and Wilk, M. B.},
  title   = {An Analysis of Variance Test for Normality (Complete Samples)},
  journal = {Biometrika},
  volume  = {52},
  number  = {3-4},
  pages   = {591--611},
  year    = {1965}
}

@incollection{levene1960,
  author    = {Levene, Howard},
  title     = {Robust Tests for Equality of Variances},
  booktitle = {Contributions to Probability and Statistics},
  pages     = {278--292},
  publisher = {Stanford University Press},
  year      = {1960}
}

@article{bonferroni1936,
  author  = {Bonferroni, Carlo},
  title   = {Teoria statistica delle classi e calcolo delle probabilit{\`a}},
  journal = {Pubblicazioni del R Istituto Superiore di Scienze Economiche e Commerciali di Firenze},
  volume  = {8},
  pages   = {3--62},
  year    = {1936}
}

@manual{rcore2024,
  title        = {R: A Language and Environment for Statistical Computing},
  author       = {{R Core Team}},
  organization = {R Foundation for Statistical Computing},
  address      = {Vienna, Austria},
  year         = {2024},
  url          = {https://www.R-project.org/}
}

@book{wickham2016,
  author    = {Wickham, Hadley},
  title     = {ggplot2: Elegant Graphics for Data Analysis},
  publisher = {Springer-Verlag New York},
  year      = {2016},
  url       = {https://ggplot2.tidyverse.org}
}

@book{hollander2013,
  author    = {Hollander, Myles and Wolfe, Douglas A. and Chicken, Eric},
  title     = {Nonparametric Statistical Methods},
  edition   = {3},
  publisher = {John Wiley \& Sons},
  year      = {2013}
}
```

### 4.4 Citation Style File

Download the APA CSL file:

```bash
wget -O apa.csl https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl
```

---

## 5. Section-by-Section Content Specification

### 5.1 Title Page (Page 1)

The title page is auto-generated from the YAML header. After the YAML block, add:

```markdown
\newpage
```

This forces the Table of Contents to start on a new page.

**Requirements met:**

- ✅ Your name
- ✅ Project name
- ✅ Current date
- ✅ Clean layout

### 5.2 Table of Contents (Page 2)

Auto-generated by `toc: true` in the YAML. Add after the title page:

```markdown
\newpage
```

### 5.3 Section 1: Introduction (~1 page)

**Content to include (in this order):**

1. **Real-world motivation (2–3 sentences):** Cycling is one of the most data-intensive sports. Teams rely on performance analytics to optimize rider selection and race strategy. Understanding how rider specializations interact with terrain is fundamental to competitive cycling analysis.

2. **Research questions (clearly numbered):**
   - RQ1: Do rider classes differ significantly in overall performance?
   - RQ2: Does the performance difference between rider classes depend on stage type?

3. **Main findings preview (2–3 sentences):** State that significant differences were found between all rider classes. State that the pattern is terrain-dependent: Sprinters dominate flat stages, All Rounders and Climbers excel on mountains, and Unclassed riders perform consistently low.

4. **Structure overview (1 sentence per section):** "Section 2 describes the dataset. Section 3 introduces the statistical methods. Section 4 presents the results. Section 5 summarizes and discusses findings."

**Do NOT write:**

- "I am writing this report because it is required for admission"
- Any reference to the application process

### 5.4 Section 2: Data Description (~0.5–1 page)

**Content to include:**

1. **Source:** "The dataset was provided by the Faculty of Statistics at TU Dortmund University."

2. **Structure:** 3,496 observations, 5 variables, each row = one rider's performance on one stage.

3. **Variable table:**

| Variable      | Description       | Scale Level | Values                                    |
| ------------- | ----------------- | ----------- | ----------------------------------------- |
| `all_riders`  | Rider name        | Nominal     | 184 unique                                |
| `rider_class` | Rider category    | Nominal     | All Rounder, Climber, Sprinter, Unclassed |
| `stage`       | Stage identifier  | Ordinal     | X1–X21 (X5, X13 absent)                   |
| `points`      | Performance score | Ratio       | 0–304, integer                            |
| `stage_class` | Terrain type      | Nominal     | flat, hills, mount                        |

4. **Data quality notes:**
   - No missing values (NA)
   - 19 of 21 stages present (X5 and X13 absent — likely rest days)
   - Unbalanced groups: Unclassed = 115 riders, All Rounder = 17
   - 61.8% of observations are zero points — strong right skew, zero-inflation
   - Points bounded at 0 (no negative values)

**R code chunk for this section:**

```r
cycling <- read.table("cycling.txt", header = TRUE, quote = "\"")
cycling$rider_class <- factor(cycling$rider_class,
  levels = c("All Rounder", "Climber", "Sprinter", "Unclassed"))
cycling$stage_class <- factor(cycling$stage_class,
  levels = c("flat", "hills", "mount"))

# Basic structure verification
cat("Rows:", nrow(cycling), "\n")
cat("Columns:", ncol(cycling), "\n")
cat("Missing values:", sum(is.na(cycling)), "\n")
cat("Unique riders:", length(unique(cycling$all_riders)), "\n")
cat("Unique stages:", length(unique(cycling$stage)), "\n")
cat("Zero-point entries:", sum(cycling$points == 0),
    sprintf("(%.1f%%)", 100 * sum(cycling$points == 0) / nrow(cycling)), "\n")

# Riders per class
table(cycling$rider_class) / length(unique(cycling$stage))
```

### 5.5 Section 3: Statistical Methods (~3–4 pages)

This is the most critical section for a statistics department. Every method must be:

1. Named
2. Mathematically defined (formulas)
3. Explained in plain language
4. Cited with a reference

**Subsection 3.1: Descriptive Statistics**

Define and cite:

- **Arithmetic mean:** $\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i$ (Fahrmeir et al., 2016)
- **Median:** the value $\tilde{x}$ where at least 50% of observations fall on each side (Fahrmeir et al., 2016)
- **Standard deviation:** $s = \sqrt{\frac{1}{n-1} \sum_{i=1}^{n} (x_i - \bar{x})^2}$ (Fahrmeir et al., 2016)
- **Interquartile range:** $\text{IQR} = Q_3 - Q_1$ (Fahrmeir et al., 2016)

Note that given the heavy right skew and zero-inflation, median and IQR are more robust than mean and SD.

**Subsection 3.2: Graphical Methods**

Define:

- **Boxplot:** Box spans Q1 to Q3 (IQR), line at median, whiskers extend to most extreme point within 1.5×IQR of box, points beyond are outliers. Cite (Tukey, 1977).
- Explain why grouped boxplots faceted by stage_class are appropriate for this task.

**Subsection 3.3: Assumption Checking**

Define:

- **Shapiro-Wilk test** for normality (Shapiro & Wilk, 1965): Tests $H_0$: data are normally distributed. Report W statistic and p-value.
- **Levene's test** for homogeneity of variance (Levene, 1960): Tests $H_0$: population variances are equal across groups.

Explain: Both will be violated, justifying non-parametric methods.

**Subsection 3.4: Kruskal-Wallis Test**

Full mathematical definition:

$$H = \frac{12}{N(N+1)} \sum_{j=1}^{k} \frac{R_j^2}{n_j} - 3(N+1)$$

where $N$ = total observations, $k$ = number of groups, $R_j$ = rank sum for group $j$, $n_j$ = group $j$ size. Under $H_0$, $H \sim \chi^2(k-1)$ approximately.

- $H_0$: All group distributions are identical
- $H_1$: At least two groups differ

Cite (Kruskal & Wallis, 1952).

**Subsection 3.5: Dunn's Post-Hoc Test**

- Pairwise rank-sum comparisons after significant Kruskal-Wallis
- p-value adjustment via Bonferroni correction: $\alpha_{adj} = \alpha / m$ where $m = \binom{k}{2}$ comparisons
- Cite (Dunn, 1964) and (Bonferroni, 1936)

**Subsection 3.6: Effect Size**

Eta-squared based on H:

$$\eta^2_H = \frac{H - k + 1}{N - k}$$

Interpretation: small (≈0.01), medium (≈0.06), large (≈0.14). Cite (Tomczak & Tomczak, 2014).

**Subsection 3.7: Strategy for RQ2**

- Stratified analysis: separate Kruskal-Wallis tests within each stage class
- Bonferroni correction across 3 tests: $\alpha_{adj} = 0.05/3 = 0.0167$
- Followed by Dunn's post-hoc within each significant stratum

**Subsection 3.8: Significance Level**

State: $\alpha = 0.05$ throughout, with Bonferroni corrections where multiple tests are performed.

### 5.6 Section 4: Results (~4–5 pages)

**Subsection 4.1: Descriptive Analysis**

**4.1.1 Summary statistics table:**

```r
summary_table <- cycling %>%
  group_by(rider_class) %>%
  summarise(
    n = n(),
    Riders = n_distinct(all_riders),
    Mean = round(mean(points), 2),
    Median = median(points),
    SD = round(sd(points), 2),
    IQR = IQR(points),
    Min = min(points),
    Max = max(points),
    .groups = "drop"
  )

kable(summary_table,
      caption = "Summary statistics of performance points by rider class.",
      booktabs = TRUE, format = "latex") %>%
  kable_styling(latex_options = c("hold_position", "striped"))
```

**Expected output:**

| Rider Class | n    | Riders | Mean  | Median | SD    | IQR | Min | Max |
| ----------- | ---- | ------ | ----- | ------ | ----- | --- | --- | --- |
| All Rounder | 323  | 17     | 37.69 | 12     | 63.96 | 34  | 0   | 304 |
| Climber     | 437  | 23     | 20.17 | 6      | 43.45 | 18  | 0   | 269 |
| Sprinter    | 551  | 29     | 15.04 | 0      | 41.83 | 8   | 0   | 272 |
| Unclassed   | 2185 | 115    | 6.42  | 0      | 23.28 | 2   | 0   | 260 |

**Text to write around this table:** Describe the ordering (All Rounder > Climber > Sprinter > Unclassed by mean). Note the large gap between mean and median in every group, confirming heavy right skew. Note the zero medians for Sprinter and Unclassed.

**4.1.2 Cross-tabulation table (rider_class × stage_class):**

```r
cross_table <- cycling %>%
  group_by(rider_class, stage_class) %>%
  summarise(
    n = n(),
    Mean = round(mean(points), 2),
    Median = median(points),
    .groups = "drop"
  ) %>%
  pivot_wider(
    names_from = stage_class,
    values_from = c(n, Mean, Median),
    names_glue = "{stage_class}_{.value}"
  )

# Simpler version for the report:
cross_means <- cycling %>%
  group_by(rider_class, stage_class) %>%
  summarise(Mean = round(mean(points), 2), .groups = "drop") %>%
  pivot_wider(names_from = stage_class, values_from = Mean)

kable(cross_means,
      caption = "Mean performance points by rider class and stage class.",
      booktabs = TRUE, format = "latex") %>%
  kable_styling(latex_options = c("hold_position"))
```

**Expected output:**

| Rider Class | flat  | hills | mount |
| ----------- | ----- | ----- | ----- |
| All Rounder | 15.44 | 35.79 | 67.42 |
| Climber     | 5.09  | 21.67 | 35.86 |
| Sprinter    | 38.98 | 5.20  | 2.04  |
| Unclassed   | 5.74  | 9.10  | 2.95  |

**Text:** Highlight the interaction pattern. Sprinters peak on flat stages (38.98) but near-zero on mountains (2.04). All Rounders peak on mountains (67.42). Climbers follow a similar but weaker mountain pattern. Unclassed are consistently low.

**4.1.3 MANDATORY Statistical Graphic — Grouped Boxplots:**

```r
ggplot(cycling, aes(x = rider_class, y = points, fill = rider_class)) +
  geom_boxplot(outlier.size = 0.6, outlier.alpha = 0.4) +
  facet_wrap(~stage_class, scales = "free_y",
             labeller = labeller(stage_class = c(
               "flat" = "Flat Stages",
               "hills" = "Hill Stages",
               "mount" = "Mountain Stages"))) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    x = "Rider Class",
    y = "Points",
    fill = "Rider Class"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 11),
    panel.grid.minor = element_blank()
  )
```

**Figure caption:** "Figure 1: Distribution of performance points by rider class, stratified by stage class. Boxes span the interquartile range (Q1–Q3); horizontal lines indicate the median; whiskers extend to 1.5×IQR; points beyond are outliers."

**Requirements for this graphic:**

- ✅ All axes labeled
- ✅ Self-explanatory with caption
- ✅ Referenced in text ("As shown in Figure 1, ...")
- ✅ Numbered consecutively
- ✅ No unnecessary information
- ✅ Clean and professional

**4.1.4 Optional second graphic — Heatmap:**

```r
heatmap_data <- cycling %>%
  group_by(rider_class, stage_class) %>%
  summarise(Mean = mean(points), .groups = "drop")

ggplot(heatmap_data, aes(x = stage_class, y = rider_class, fill = Mean)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = round(Mean, 1)), color = "black", size = 4) +
  scale_fill_gradient(low = "#f7fbff", high = "#08519c") +
  labs(
    x = "Stage Class",
    y = "Rider Class",
    fill = "Mean Points"
  ) +
  theme_minimal(base_size = 11) +
  theme(panel.grid = element_blank())
```

**Figure caption:** "Figure 2: Mean performance points by rider class and stage class. Darker shading indicates higher average scores."

**Subsection 4.2: Inferential Analysis**

**4.2.1 Assumption checks:**

```r
# Normality — Shapiro-Wilk per group (use sample if n > 5000)
cycling %>%
  group_by(rider_class) %>%
  summarise(
    W = shapiro.test(points)$statistic,
    p_value = shapiro.test(points)$p.value,
    .groups = "drop"
  )

# Homogeneity of variance — Levene's test
car::leveneTest(points ~ rider_class, data = cycling)
```

**Text:** "The Shapiro-Wilk test rejected normality for all four rider classes (p < 0.001 in each case; Shapiro & Wilk, 1965). Levene's test also rejected homogeneity of variance (p < 0.001; Levene, 1960). Given these violations, non-parametric methods are warranted."

**4.2.2 RQ1 — Kruskal-Wallis test (overall):**

```r
kw_overall <- kruskal.test(points ~ rider_class, data = cycling)
print(kw_overall)

# Effect size
H <- kw_overall$statistic
k <- 4
N <- nrow(cycling)
eta_sq <- (H - k + 1) / (N - k)
cat("Eta-squared:", round(eta_sq, 4), "\n")
```

**Text template:** "A Kruskal-Wallis rank sum test revealed a statistically significant difference in performance points across rider classes (H(3) = [value], p < 0.001; Kruskal & Wallis, 1952). The effect size was η² = [value], indicating a [small/medium/large] effect (Tomczak & Tomczak, 2014)."

**4.2.3 Dunn's post-hoc test (overall):**

```r
dunn_overall <- dunn.test::dunn.test(
  cycling$points,
  cycling$rider_class,
  method = "bonferroni",
  table = FALSE,
  list = TRUE
)

# Create results table
dunn_df <- data.frame(
  Comparison = dunn_overall$comparisons,
  Z = round(dunn_overall$Z, 3),
  P_adjusted = format.pval(dunn_overall$P.adjusted, digits = 3)
)

kable(dunn_df,
      caption = "Dunn's post-hoc pairwise comparisons with Bonferroni correction.",
      booktabs = TRUE, format = "latex",
      col.names = c("Comparison", "Z", "Adjusted p-value")) %>%
  kable_styling(latex_options = c("hold_position"))
```

**Text:** Report which pairs differ significantly (likely all pairs will be significant given the data patterns).

**4.2.4 RQ2 — Stratified Kruskal-Wallis tests:**

```r
strat_results <- cycling %>%
  group_by(stage_class) %>%
  summarise(
    H = kruskal.test(points ~ rider_class)$statistic,
    df = kruskal.test(points ~ rider_class)$parameter,
    p_value = kruskal.test(points ~ rider_class)$p.value,
    .groups = "drop"
  ) %>%
  mutate(
    Significant = ifelse(p_value < 0.05/3, "Yes", "No"),
    eta_sq = round((H - 4 + 1) / (n() - 4), 4)  # Recalculate properly per stratum
  )

kable(strat_results,
      caption = "Kruskal-Wallis tests within each stage class (Bonferroni-corrected α = 0.0167).",
      booktabs = TRUE, format = "latex") %>%
  kable_styling(latex_options = c("hold_position"))
```

**Note:** Recalculate eta-squared properly for each stratum using the stratum's N and k.

```r
# Proper per-stratum calculation:
for (sc in c("flat", "hills", "mount")) {
  sub <- cycling[cycling$stage_class == sc, ]
  kw <- kruskal.test(points ~ rider_class, data = sub)
  eta <- (kw$statistic - 4 + 1) / (nrow(sub) - 4)
  cat(sc, ": H =", round(kw$statistic, 2),
      ", p =", format.pval(kw$p.value, digits = 3),
      ", eta² =", round(eta, 4), "\n")
}
```

**4.2.5 Dunn's post-hoc within each stage class:**

```r
for (sc in c("flat", "hills", "mount")) {
  cat("\n--- Stage class:", sc, "---\n")
  sub <- cycling[cycling$stage_class == sc, ]
  dunn.test::dunn.test(sub$points, sub$rider_class, method = "bonferroni")
}
```

Present the most important pairwise results in text or a compact table. Focus on the contrasts that answer RQ2 (e.g., Sprinter vs. All Rounder on flat stages, Climber vs. Sprinter on mountain stages).

**Critical reminders for Section 4:**

- Be neutral. Present numbers. No interpretation yet.
- "The test yielded H(3) = X, p < 0.001" is correct.
- "This proves All Rounders are better" is NOT appropriate here.
- All figures and tables must be numbered and referenced in text.

### 5.7 Section 5: Summary & Discussion (~1 page)

**5.7.1 Recapitulation of findings (must be readable standalone):**

- RQ1: Yes, significant differences exist (Kruskal-Wallis, p < 0.001). All Rounders score highest overall, followed by Climbers, Sprinters, Unclassed. All pairwise comparisons are significant (Dunn's test).

- RQ2: The pattern is terrain-dependent. Sprinters dominate flat stages (mean 38.98) but score near-zero on mountains (mean 2.04). All Rounders and Climbers excel on hilly and mountainous terrain. All three stratified tests are significant. The interaction between rider class and stage class is the most notable finding.

**5.7.2 Real-world interpretation:**

- Rider classifications genuinely reflect performance specializations
- Team managers should optimize rider selection based on expected terrain profiles
- All Rounders earn their name — competitive across all terrains with peak mountain performance
- The "Unclassed" designation corresponds to domestiques / support riders whose role is not individual scoring

**5.7.3 Limitations (mandatory):**

1. Data from a manager game, not real-world race results — scoring rules may introduce artifacts
2. Non-parametric tests compare distributions, not just means — significant results may reflect shape/spread differences
3. Highly unbalanced groups (17 vs. 115 riders) may affect statistical power
4. Missing stages X5 and X13 unexplained — potential selection bias
5. Zero-inflation (61.8%) — a zero-inflated model might be more appropriate
6. Repeated-measures structure (same rider across stages) not accounted for by Kruskal-Wallis

**5.7.4 Future work:**

- Aligned Rank Transform (ART) for formal nonparametric interaction testing
- Mixed-effects models to account for rider-level repeated measures
- Rider-level aggregation (mean points per rider) as alternative analysis unit
- Zero-inflated regression models

### 5.8 Bibliography (Page 10)

Auto-generated from `references.bib` by RMarkdown. Add at the end of the `.Rmd` file:

```markdown
# References
```

RMarkdown will automatically render the bibliography below this heading.

**Software citations to add in the text (not just bibliography):**

Include in the Methods or Data Description section:

- "All analyses were performed using R version [X.X.X] (R Core Team, 2024) with the packages ggplot2 (Wickham, 2016), dunn.test, kableExtra, and car."

---

## 6. Quality Checklist

### Layout

- [ ] Line spacing: 1.5 (set in YAML: `linestretch: 1.5`)
- [ ] Font size: 12pt (set in YAML: `fontsize: 12pt`)
- [ ] Uniform font throughout (handled by LaTeX)
- [ ] Sufficient margins (set in YAML: `geometry: margin=2.5cm`)
- [ ] **Exactly 10 pages** — adjust text length to hit this. Use `\newpage` if needed.
- [ ] PDF format output

### Content

- [ ] Title page with name, project title, date
- [ ] Table of contents with page numbers
- [ ] Introduction with real-world motivation (NOT "this is the application report")
- [ ] Main results stated in the introduction
- [ ] Data description with variable types and scale levels
- [ ] All methods mathematically defined before use
- [ ] Every method cited with literature reference
- [ ] At least one statistical graphic (boxplots)
- [ ] All figures/tables numbered consecutively
- [ ] All figures/tables referenced in text
- [ ] All figures/tables have captions
- [ ] All axes labeled on graphics
- [ ] Descriptive and inferential analyses as separate subsections
- [ ] Choice of tests justified (assumptions violated → non-parametric)
- [ ] Summary readable without reading the rest
- [ ] Summary answers both research questions explicitly
- [ ] Discussion with real-world context
- [ ] Limitations mentioned
- [ ] Bibliography with all cited works
- [ ] All bibliography entries cited in text and vice versa
- [ ] Software and packages cited
- [ ] No copy-pasted text from the task definition
- [ ] No plagiarism
- [ ] Consistent terminology (pick "dataset" or "data set" — use one throughout)
- [ ] Grammar and spelling error-free
- [ ] Scientific and precise language
- [ ] No passive voice where avoidable
- [ ] No filler words or colloquial language

### Formatting Rules from the Task

- [ ] Figures/tables have sub-heading OR heading (be consistent — pick one)
- [ ] Figures/tables appear on the same page or next page after first reference (use `fig.pos = "H"` in R chunks)
- [ ] Mathematical formulas set off from body text (use LaTeX `$$...$$`)
- [ ] Consistent variable naming throughout
- [ ] Citations in author-year format: (Kruskal & Wallis, 1952)
- [ ] All literature in bibliography cited in text and vice versa

---

## 7. File Structure

```
project/
├── report.Rmd          # Main report file
├── header.tex          # LaTeX header configuration
├── references.bib      # Bibliography
├── apa.csl             # Citation style
├── cycling.txt         # Dataset
└── report.pdf          # Final output (rendered)
```

---

## 8. Rendering Command

```r
# From R console:
rmarkdown::render("report.Rmd")

# Or from terminal:
Rscript -e 'rmarkdown::render("report.Rmd")'
```

**Troubleshooting common render failures:**

| Error                                          | Fix                                                                            |
| ---------------------------------------------- | ------------------------------------------------------------------------------ |
| `! LaTeX Error: File 'booktabs.sty' not found` | Run: `tinytex::tlmgr_install("booktabs")` — repeat for any missing `.sty` file |
| `Error in library(tidyverse)`                  | Run: `install.packages("tidyverse")`                                           |
| `pandoc version 1.12.3 or higher is required`  | Run: `sudo apt install pandoc`                                                 |
| PDF is blank or garbled                        | Check that `cycling.txt` is in the same directory as `report.Rmd`              |
| `! Package inputenc Error: Unicode character`  | Make sure YAML has `latex_engine: xelatex`                                     |
| Tables overflow page width                     | Add `scale_down` to `kable_styling()` options                                  |

**Final output:** The rendered `report.pdf` in the project directory is the file to upload to uni-assist.

---

## 9. Page Budget Management

This is critical — you must hit exactly 10 pages. Here's how to manage it:

| Section          | Target Length  | If too long                           | If too short                            |
| ---------------- | -------------- | ------------------------------------- | --------------------------------------- |
| Title page       | 1 page exactly | Remove subtitle                       | Add university logo or subtitle         |
| TOC              | 1 page exactly | Reduce `toc_depth` to 2               | Add `toc_depth: 3`                      |
| Introduction     | ~0.8–1 page    | Cut motivation to 2 sentences         | Expand structure overview               |
| Data Description | ~0.7–1 page    | Move variable table to appendix       | Add sample data preview                 |
| Methods          | ~3–4 pages     | Cut explanations, keep formulas       | Add advantages/disadvantages of methods |
| Results          | ~3–4 pages     | Move some post-hoc tables to appendix | Add second graphic (heatmap)            |
| Summary          | ~1 page        | Cut future work                       | Expand limitations discussion           |
| Bibliography     | ~0.5–1 page    | Use smaller font for bibliography     | It is what it is                        |

**Tips:**

- Methods + Results together should fill ~7 pages (pages 4–10 minus summary and bibliography)
- If running long: reduce figure size with `fig.width` and `fig.height` in chunk options
- If running short: add the optional heatmap (Figure 2), expand method explanations
- Use `\newpage` strategically to control page breaks
- Global chunk option for figure placement: `knitr::opts_chunk$set(fig.pos = "H")`

---

## 10. Timeline (< 5 days)

| Day       | Tasks                                                                                                                                                                                                                                                                     | Hours | Deliverable                                        |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | -------------------------------------------------- |
| **Day 1** | Environment setup (R, RStudio, packages, tinytex). Create project folder with all files (header.tex, references.bib, apa.csl). Download dataset. Verify setup compiles a test PDF. Start writing YAML header and Section 1 (Introduction) + Section 2 (Data Description). | 3–4h  | Working .Rmd that compiles, Sections 1–2 drafted   |
| **Day 2** | Write Section 3 (Methods) — all mathematical definitions, formulas in LaTeX, citations. This is the longest writing section.                                                                                                                                              | 3–4h  | Section 3 complete with all formulas and citations |
| **Day 3** | Write Section 4 (Results) — run all R code, generate tables and figures, write neutral commentary around each result.                                                                                                                                                     | 3–4h  | Section 4 complete with all figures/tables         |
| **Day 4** | Write Section 5 (Summary & Discussion). Final compilation. Page count check — adjust content to hit exactly 10 pages. Proofread for grammar, consistency, formatting.                                                                                                     | 3h    | Full 10-page draft                                 |
| **Day 5** | Final proofread. Check all citations match bibliography. Verify all figures/tables referenced. Spell check. Export final PDF. Submit.                                                                                                                                     | 2h    | **Final report.pdf ready for uni-assist upload**   |

**Critical path:** Days 2 and 3 are the heaviest. Don't skip the math in Section 3 — the faculty will weigh it heavily.

---

## 11. Common Pitfalls to Avoid

1. **Using ANOVA without checking assumptions.** The data violates normality and homoscedasticity. Parametric tests without justification will fail you.

2. **Reporting only p-values.** Always report: test name, statistic, df, p-value, AND effect size.

3. **Forgetting to cite methods.** Every test needs a reference. You didn't invent the boxplot.

4. **Copy-pasting the task description.** Explicitly forbidden. Rephrase everything.

5. **Writing "I am doing this because it is the application report."** Give real-world cycling motivation.

6. **Making it suspenseful.** State the main result in the introduction. This is science, not a thriller.

7. **Using an irrelevant graphic.** A histogram of all pooled points doesn't answer the research questions. Grouped boxplots by rider_class × stage_class do.

8. **Ignoring zero-inflation.** 61.8% zeros is the defining characteristic. Acknowledge it.

9. **Not discussing limitations.** Especially the repeated-measures structure.

10. **Going over or under 10 pages.** "Exactly 10 pages" — take this literally.

11. **Inconsistent formatting.** Pick "data set" or "dataset" — one throughout. Pick caption style (above or below) — one throughout.

12. **Forgetting to cite R and packages.** Required by the task instructions.
