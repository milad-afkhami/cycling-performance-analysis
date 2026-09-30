# Strict Validation Prompt: TU Dortmund Application Report

You are a **strict academic reviewer** for a statistical report submitted as part of an M.Sc. Data Science application at TU Dortmund University. This report is evaluated pass/fail by the Faculty of Statistics. A failure means the applicant cannot be admitted. Your job is to find every error, omission, inconsistency, and weakness before the faculty does.

## Files to Read

1. **PRD (specification):** `/home/milad/Desktop/projects/Uni/tud-application-report/prd.md`
2. **Report source:** `/home/milad/Desktop/projects/Uni/tud-application-report/report.Rmd`
3. **LaTeX header:** `/home/milad/Desktop/projects/Uni/tud-application-report/header.tex`
4. **Bibliography:** `/home/milad/Desktop/projects/Uni/tud-application-report/references.bib`
5. **Dataset:** `/home/milad/Desktop/projects/Uni/tud-application-report/cycling.txt`

Read ALL of these files completely before beginning validation.

## Validation Instructions

Perform each of the following validation passes independently. For each pass, report:
- **PASS** if no issues found
- **WARN** if minor issues found (cosmetic, stylistic, non-blocking)
- **FAIL** if critical issues found (would cause rejection or produce incorrect results)

For every WARN or FAIL, quote the exact problematic text/code and explain the issue.

---

### PASS 1: Mathematical Correctness

For EVERY mathematical formula in the report, verify:

1. **Kruskal-Wallis H statistic formula** — Compare against the original paper (Kruskal & Wallis, 1952). Check that the formula uses ranks (not raw data), the denominator is correct ($N(N+1)$), and the correction term is $3(N+1)$.
2. **Eta-squared formula** — Verify it matches Tomczak & Tomczak (2014): $\eta^2_H = (H - k + 1) / (N - k)$. Check that $k$ is the number of groups and $N$ is total observations.
3. **Bonferroni correction** — Verify $\alpha_{adj} = \alpha / m$ where $m$ is correctly computed. For 4 groups: $m = \binom{4}{2} = 6$. For 3 strata: $m = 3$, so $\alpha_{adj} = 0.0167$.
4. **Standard deviation formula** — Must use $n-1$ (Bessel's correction), not $n$.
5. **Mean, median, IQR definitions** — Check for mathematical accuracy.
6. **All inline formulas** — Check for LaTeX rendering issues (missing dollar signs, malformed expressions, etc.)

**Do NOT trust that the formulas are correct just because they look plausible. Cross-check each one against the cited source.**

---

### PASS 2: Statistical Methodology Audit

Evaluate whether the statistical approach is sound:

1. **Is the Kruskal-Wallis test appropriate here?** Consider: the data has repeated measures (same riders across stages). The KW test assumes independence. Is this violation acknowledged? Is it listed as a limitation?
2. **Is the Bonferroni correction applied correctly in all places?** There should be TWO separate Bonferroni corrections: (a) within Dunn's post-hoc tests (6 comparisons), (b) across the 3 stratified KW tests ($\alpha = 0.05/3$).
3. **Are the assumption checks done BEFORE choosing the test?** The report should check normality (Shapiro-Wilk) and homogeneity of variance (Levene's) and THEN justify using nonparametric methods.
4. **Is the effect size interpretation correct?** Check the eta-squared value against the benchmarks (0.01 = small, 0.06 = medium, 0.14 = large). Is the label (small/medium/large) correctly assigned given the computed value?
5. **Are p-values reported correctly?** Never report exact p-values as "0" or "0.000". Should use "< 0.001" or similar notation.
6. **Does the report conflate statistical significance with practical significance?** Effect sizes should be reported alongside p-values.

---

### PASS 3: R Code Correctness

Execute (mentally or actually) every R code chunk and verify:

1. **Data loading:** `read.table("cycling.txt", header = TRUE, quote = "\"")` — the `quote` parameter is critical because rider names contain quotes. Verify this is present.
2. **Factor level ordering:** Are `rider_class` and `stage_class` factors set with explicit levels? Without this, alphabetical ordering would scramble results.
3. **Shapiro-Wilk test:** R's `shapiro.test()` has a sample size limit (n ≤ 5000). With 3,496 rows total but per-group sizes (323, 874, 684, 2185 for the four classes), verify no group exceeds 5,000. Note: the Unclassed group has n > 2000 which is fine but worth verifying.
4. **Dunn's test:** Verify `dunn.test()` is called with `method = "bonferroni"` and `list = TRUE`. The function prints to console by default — is `results='hide'` set on the chunk?
5. **Inline R expressions:** Check every `` `r ...` `` expression. Do the referenced variables exist at that point in the document? Are they computed before being referenced? (RMarkdown renders top-to-bottom.)
6. **Levene's test:** Verify `car::leveneTest()` is called with the formula interface, not just raw vectors.
7. **Table formatting:** Check that `kable()` calls use `format = "latex"` (not "html"), `booktabs = TRUE`, and appropriate `font_size`.
8. **Figure placement:** Check that `fig.pos = "H"` is set (requires `\usepackage{float}` in header.tex — verify it's there).

---

### PASS 4: Citation and Bibliography Integrity

1. **Bidirectional check:** Every `@citation` in the .Rmd must have a matching entry in `references.bib`, AND every entry in `references.bib` must be cited in the .Rmd. List any orphaned entries or missing citations.
2. **Citation accuracy:** For each BibTeX entry, verify:
   - Author names are correct (check spelling)
   - Year is correct
   - Journal/book title is correct
   - Volume/pages are plausible
   - The entry type (@article, @book, @incollection, etc.) is appropriate
3. **Citation style:** With `apa.csl`, citations should render as "(Author, Year)" in text. Verify that `@` vs `[@]` is used correctly (parenthetical vs. narrative citations).
4. **Software citations:** R itself must be cited. ggplot2 should be cited. Are other key packages (dunn.test, kableExtra, car) cited?
5. **Are there any claims without citations?** Every statistical method introduced should have a citation. Every benchmark (e.g., effect size thresholds) should be cited.

---

### PASS 5: Content Completeness (PRD Compliance)

Compare the report against the PRD requirements point by point:

1. **Structure:** Does it have all 5 sections? (Introduction, Data Description, Statistical Methods, Results, Summary & Discussion)
2. **Introduction requirements:**
   - Real-world cycling motivation (NOT "this is an application report")?
   - Two numbered research questions?
   - Preview of main findings (no suspense)?
   - Structure overview?
3. **Data Description requirements:**
   - Data source stated?
   - Dataset dimensions (3,496 × 5)?
   - Variable table with scale levels?
   - Data quality notes (no NAs, missing stages, unbalanced groups, zero-inflation)?
4. **Methods requirements:**
   - EVERY method has: name + formula + explanation + citation?
   - Methods covered: mean, median, SD, IQR, boxplot, Shapiro-Wilk, Levene's, Kruskal-Wallis, Dunn's, Bonferroni, eta-squared?
   - Stratified analysis strategy explained?
   - Significance level stated?
5. **Results requirements:**
   - Summary statistics table by rider class?
   - Cross-tabulation (rider_class × stage_class)?
   - At least 1 statistical graphic (boxplots)?
   - Figure numbered, captioned, and referenced in text?
   - Assumption check results reported?
   - Overall KW test + effect size?
   - Dunn's post-hoc table (overall)?
   - Stratified KW tests (one per stage class)?
   - Stratified post-hoc results?
   - Neutral tone (numbers only, no interpretation)?
6. **Summary & Discussion requirements:**
   - Both RQs answered explicitly?
   - Real-world interpretation?
   - At least 4 limitations?
   - Future work mentioned?
7. **Forbidden content:**
   - Does the report mention "application report", "admission", "uni-assist", or any meta-references to the application process in the body text? (Title/subtitle are OK, body text is NOT.)
   - Does it use first person ("I analyzed...")?
   - Does it copy-paste task descriptions verbatim from the assignment?

---

### PASS 6: Numerical Verification

**Run the analysis yourself from scratch** using the cycling.txt dataset. Compute independently and compare:

1. Total rows: must be 3,496
2. Missing values: must be 0
3. Unique riders: must be 184
4. Stages present: must be 19 (X5, X13 absent)
5. Zero-inflation percentage: must be ~61.8%
6. Group sizes: All Rounder (n=?), Climber (n=?), Sprinter (n=?), Unclassed (n=?)
7. Mean points per rider class (all 4 values)
8. Cross-tabulation means (all 12 cells: 4 rider classes × 3 stage classes)
9. Kruskal-Wallis H statistic and p-value (overall)
10. Eta-squared value and its classification (small/medium/large)
11. Levene's test F-statistic
12. Shapiro-Wilk W statistics (all 4 groups)
13. Number of significant Dunn's post-hoc comparisons (overall): should be 6/6
14. Stratified KW: H and p-values for flat, hills, mount separately

**If ANY computed value differs from what the report states, flag it as FAIL with both the expected and actual values.**

---

### PASS 7: Layout and Formatting

1. **Page count:** Must be exactly 10 pages. Count: title page + TOC + content + bibliography.
2. **Font size:** YAML says 12pt?
3. **Margins:** YAML says 2.5cm?
4. **Line spacing:** Check `linestretch` value. PRD says 1.5 but any value in ~1.2–1.5 range is acceptable.
5. **Headers/footers:** Does header.tex set up fancyhdr with author name in right header, report title in left header, page number in right footer?
6. **Table of contents:** Present? Appropriate depth?
7. **Section numbering:** Enabled?
8. **LaTeX engine:** Must be xelatex (for Unicode rider names like "Pogačar").
9. **Code visibility:** All code chunks should have `echo = FALSE`. No raw R code should appear in the PDF.
10. **Warning/message suppression:** `warning = FALSE, message = FALSE` in global chunk options?

---

### PASS 8: Writing Quality

1. **Academic register:** Is the prose written in formal academic English? Flag any informal language, contractions, or colloquialisms.
2. **Passive vs. active voice:** Scientific reports typically use passive voice ("was performed") or impersonal constructions ("the analysis reveals"). Flag any first-person usage.
3. **Precision of statistical reporting:** Test results should follow the format "$H(df) = value$, $p < threshold$" — not vague statements like "the test was significant".
4. **Consistency:** Are variable names referred to consistently (e.g., always "rider class" or always "rider_class", not switching)?
5. **Logical flow:** Does each section follow naturally from the previous one? Does the Results section present findings in the same order as the Methods section introduces them?
6. **Redundancy:** Is any information repeated unnecessarily?
7. **Grammar and spelling:** Flag any grammatical errors.

---

## Output Format

Produce a structured report with the following format:

```
## VALIDATION REPORT

### Overall Verdict: [PASS / CONDITIONAL PASS / FAIL]

### Pass 1: Mathematical Correctness — [PASS/WARN/FAIL]
- [Issue 1]
- [Issue 2]
...

### Pass 2: Statistical Methodology — [PASS/WARN/FAIL]
- [Issue 1]
...

[Continue for all 8 passes]

### Critical Issues (Must Fix Before Submission)
1. [Issue]
2. [Issue]

### Warnings (Should Fix If Possible)
1. [Issue]
2. [Issue]

### Minor Suggestions (Optional Improvements)
1. [Suggestion]
2. [Suggestion]
```

## Important Notes

- Be adversarial. Your job is to find problems, not to confirm the report is good.
- Do not assume anything is correct just because it looks reasonable. Verify everything.
- The Faculty of Statistics at TU Dortmund will evaluate this. They know statistics intimately. Any mathematical error, methodological flaw, or sloppy citation will be caught.
- A false PASS from you is worse than a false FAIL. When in doubt, flag it.
- If you find the report is genuinely well-done, say so — but still look for improvements.
