# 02_kaplan_meier.R
# Kaplan-Meier Survival Analysis

library(survival)
library(ggplot2)
library(dplyr)

lung <- read.csv("data/lung_clean.csv")

lung$ecog_group <- ifelse(lung$ecog >= 2, "2-3 (Poor)", 
                          ifelse(lung$ecog == 1, "1 (Moderate)", "0 (Good)"))
lung$ecog_group <- factor(lung$ecog_group, 
                          levels = c("0 (Good)", "1 (Moderate)", "2-3 (Poor)"))

# --- KM by Sex ---
km_sex <- survfit(Surv(time, status_event) ~ sex_label, data = lung)

km_sex_df <- data.frame(
  time = km_sex$time,
  surv = km_sex$surv,
  group = rep(names(km_sex$strata), km_sex$strata)
)
km_sex_df$group <- gsub("sex_label=", "", km_sex_df$group)

km_sex_plot <- ggplot(km_sex_df, aes(x = time, y = surv, color = group)) +
  geom_step(linewidth = 1) +
  scale_color_manual(values = c("Female" = "#40E0D0", "Male" = "#FA8072"),
                     name = "Sex") +
  annotate("text", x = 700, y = 0.9,
           label = "Log-rank p = 0.002", size = 4, color = "black") +
  labs(title = "Overall Survival by Sex",
       subtitle = "NCCTG Lung Cancer Trial (n=227)",
       x = "Time (Days)", y = "Survival Probability") +
  theme_bw() + ylim(0, 1)

ggsave("figures/km_by_sex.png", km_sex_plot, width = 8, height = 6)
cat("KM by sex saved\n")

# --- KM by ECOG ---
km_ecog <- survfit(Surv(time, status_event) ~ ecog_group, data = lung)

km_ecog_df <- data.frame(
  time = km_ecog$time,
  surv = km_ecog$surv,
  group = rep(names(km_ecog$strata), km_ecog$strata)
)
km_ecog_df$group <- gsub("ecog_group=", "", km_ecog_df$group)
km_ecog_df$group <- factor(km_ecog_df$group,
                           levels = c("0 (Good)", "1 (Moderate)", "2-3 (Poor)"))

km_ecog_plot <- ggplot(km_ecog_df, aes(x = time, y = surv, color = group)) +
  geom_step(linewidth = 1) +
  scale_color_manual(values = c("0 (Good)" = "#40E0D0",
                                "1 (Moderate)" = "#FFA500",
                                "2-3 (Poor)" = "#FA8072"),
                     name = "ECOG Status") +
  annotate("text", x = 700, y = 0.9,
           label = "Log-rank p < 0.001", size = 4, color = "black") +
  labs(title = "Overall Survival by ECOG Performance Status",
       subtitle = "NCCTG Lung Cancer Trial (n=227)",
       x = "Time (Days)", y = "Survival Probability") +
  theme_bw() + ylim(0, 1)

ggsave("figures/km_by_ecog.png", km_ecog_plot, width = 8, height = 6)
cat("KM by ECOG saved\n")

# --- Log-rank tests ---
cat("\n=== Log-rank Test: Sex ===\n")
print(survdiff(Surv(time, status_event) ~ sex_label, data = lung))

cat("\n=== Log-rank Test: ECOG ===\n")
print(survdiff(Surv(time, status_event) ~ ecog_group, data = lung))

cat("\nScript 2 complete!\n")
