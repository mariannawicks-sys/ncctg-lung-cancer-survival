# 03_cox_regression.R
# Cox Proportional Hazards Regression

library(survival)
library(dplyr)

lung <- read.csv("data/lung_clean.csv")

lung$ecog_group <- ifelse(lung$ecog >= 2, "2-3 (Poor)", 
                          ifelse(lung$ecog == 1, "1 (Moderate)", "0 (Good)"))
lung$ecog_group <- factor(lung$ecog_group, 
                          levels = c("0 (Good)", "1 (Moderate)", "2-3 (Poor)"))
lung$sex_label <- factor(lung$sex_label, levels = c("Male", "Female"))

# --- Univariate Cox models ---
cat("=== Univariate Cox: Sex ===\n")
cox_sex <- coxph(Surv(time, status_event) ~ sex_label, data = lung)
print(summary(cox_sex))

cat("\n=== Univariate Cox: ECOG ===\n")
cox_ecog <- coxph(Surv(time, status_event) ~ ecog_group, data = lung)
print(summary(cox_ecog))

cat("\n=== Univariate Cox: Age ===\n")
cox_age <- coxph(Surv(time, status_event) ~ age, data = lung)
print(summary(cox_age))

# --- Multivariable Cox model ---
cat("\n=== Multivariable Cox Model ===\n")
cox_multi <- coxph(Surv(time, status_event) ~ sex_label + ecog_group + age + wt.loss,
                   data = lung)
print(summary(cox_multi))

# --- Extract results table ---
results <- data.frame(
  Variable = c("Female vs Male", "ECOG 1 vs 0", "ECOG 2-3 vs 0", "Age", "Weight Loss"),
  HR = exp(coef(cox_multi)),
  CI_lower = exp(confint(cox_multi)[,1]),
  CI_upper = exp(confint(cox_multi)[,2]),
  p_value = summary(cox_multi)$coefficients[,5]
)
rownames(results) <- NULL

cat("\n=== Hazard Ratios Summary ===\n")
print(results)

write.csv(results, "results/cox_results.csv", row.names = FALSE)
cat("\nResults saved to results/cox_results.csv\n")
cat("Script 3 complete!\n")
