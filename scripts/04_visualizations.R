# 04_visualizations.R
# Final Visualizations - Forest Plot

library(ggplot2)
library(survival)
library(dplyr)

# --- Load data ---
lung <- read.csv("data/lung_clean.csv")
results <- read.csv("results/cox_results.csv")

lung$ecog_group <- ifelse(lung$ecog >= 2, "2-3 (Poor)", 
                          ifelse(lung$ecog == 1, "1 (Moderate)", "0 (Good)"))
lung$ecog_group <- factor(lung$ecog_group, 
                          levels = c("0 (Good)", "1 (Moderate)", "2-3 (Poor)"))
lung$sex_label <- factor(lung$sex_label, levels = c("Male", "Female"))

# --- Forest Plot ---
results$Variable <- factor(results$Variable, levels = rev(results$Variable))
results$significant <- ifelse(results$p_value < 0.05, "Significant", "Not Significant")

forest_plot <- ggplot(results, aes(x = HR, y = Variable, color = significant)) +
  geom_point(size = 4) +
  geom_errorbar(aes(xmin = CI_lower, xmax = CI_upper),
                width = 0.2, orientation = "y") +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red") +
  scale_color_manual(values = c("Significant" = "#40E0D0",
                                "Not Significant" = "#FA8072"),
                     name = "") +
  labs(title = "Multivariable Cox Regression",
       subtitle = "Hazard Ratios with 95% Confidence Intervals",
       x = "Hazard Ratio (95% CI)",
       y = "") +
  theme_bw() +
  theme(legend.position = "bottom")

ggsave("figures/forest_plot.png", forest_plot, width = 8, height = 5)
cat("Forest plot saved!\n")
cat("Script 4 complete!\n")
