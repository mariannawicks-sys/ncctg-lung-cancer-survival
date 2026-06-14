# 01_data_exploration.R
# Explore the NCCTG Lung Cancer Dataset

library(survival)
library(dplyr)

lung <- read.csv("data/lung_cancer_data.csv")

cat("=== Dataset Overview ===\n")
cat("Rows:", nrow(lung), "\n")
cat("Columns:", ncol(lung), "\n\n")

cat("=== Missing Values ===\n")
print(colSums(is.na(lung)))

cat("\n=== Survival Status ===\n")
cat("Censored (status=1):", sum(lung$status == 1), "\n")
cat("Dead (status=2):", sum(lung$status == 2), "\n")

cat("\n=== Sex Distribution ===\n")
cat("Male (sex=1):", sum(lung$sex == 1, na.rm = TRUE), "\n")
cat("Female (sex=2):", sum(lung$sex == 2, na.rm = TRUE), "\n")

cat("\n=== ECOG Performance Status ===\n")
print(table(lung$ph.ecog, useNA = "always"))

lung_clean <- lung %>%
  mutate(
    sex_label = ifelse(sex == 1, "Male", "Female"),
    status_event = ifelse(status == 2, 1, 0),
    ecog = ph.ecog
  ) %>%
  filter(!is.na(ph.ecog))

write.csv(lung_clean, "data/lung_clean.csv", row.names = FALSE)
cat("\nClean dataset saved! Rows:", nrow(lung_clean), "\n")
cat("Script 1 complete!\n")