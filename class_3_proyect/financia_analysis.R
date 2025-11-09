# ======================================================
# 💰 Personal Finance Analysis in R
# Author: Leonardo Sánchez Castillo
# Description: Analyze and visualize personal finances 
#              (expenses vs income) from CSV data.
# ======================================================

# --- 1️⃣ Libraries -----------------------------------------------------------
install.packages(c("tidyverse", "plotly", "RColorBrewer"))
library(RColorBrewer)
library(tidyverse)
library(plotly)
library(readr)

# --- 2️⃣ Load dataset --------------------------------------------------------
# Replace with your CSV file path if needed
df <- read_csv("C:/Users/leodo/OneDrive/Escritorio/RAG/Rag_My_Version/data/Personal_Finance_Dataset.csv")

# Check structure
glimpse(df)

# Ensure date column is properly formatted (if exists)
if ("Fecha" %in% names(df)) {
  df <- df %>% mutate(Fecha = as.Date(Fecha))
}

# --- 3️⃣ Separate expenses (Expense) and income (Income) --------------------
df_gastos <- df %>% filter(Type == "Expense")
df_ingresos <- df %>% filter(Type == "Income")

# --- 4️⃣ Summaries ----------------------------------------------------------
# 🧾 Expenses summary
df_gastos_summary <- df_gastos %>%
  group_by(`Transaction Description`) %>%
  summarise(
    Cantidad = n(),
    Total = sum(Amount, na.rm = TRUE),
    Category = first(Category)
  ) %>%
  ungroup() %>%
  mutate(Total = -Total) %>%  # make expenses negative
  arrange(desc(Cantidad))

cat("\n💸 Total spent:", sum(df_gastos_summary$Total), "\n")
print(df_gastos_summary)

# 💰 Income summary
df_ingresos_summary <- df_ingresos %>%
  group_by(`Transaction Description`, Category) %>%
  summarise(
    Cantidad = n(),
    Total = sum(Amount, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  arrange(desc(Cantidad))

cat("\n💵 Total income:", sum(df_ingresos_summary$Total, na.rm = TRUE), "\n")
print(df_ingresos_summary)

# --- 5️⃣ Optional cleaning ---------------------------------------------------
df_gastos_limpio <- df_gastos_summary
df_ingresos_limpio <- df_ingresos_summary

# --- 6️⃣ Category analysis ---------------------------------------------------
if ("Category" %in% names(df)) {
  df_categorias <- df %>%
    select(`Transaction Description`, Category) %>%
    distinct()

  df_merged <- df_gastos_summary %>%
    left_join(df_categorias, by = "Transaction Description")

  if ("Category.x" %in% names(df_merged) & "Category.y" %in% names(df_merged)) {
    df_merged <- df_merged %>%
      mutate(Category = coalesce(Category.x, Category.y)) %>%
      select(-Category.x, -Category.y)
  }

  df_grouped <- df_merged %>%
    group_by(Category) %>%
    summarise(
      Total = sum(Total, na.rm = TRUE),
      Cantidad = sum(Cantidad, na.rm = TRUE)
    ) %>%
    mutate(Promedio = Total / Cantidad) %>%
    filter(!str_detect(Category, regex("yappy", ignore_case = TRUE))) %>%
    arrange(desc(Total))

  print(df_grouped)
}

# --- 7️⃣ Plot 1: Bar chart ---------------------------------------------------
df_grouped <- df_grouped %>%
  mutate(
    Category = as.character(Category),
    Total = as.numeric(Total),
    Cantidad = as.numeric(Cantidad),
    Promedio = as.numeric(Promedio)
  )

fig_bar <- plot_ly(
  data = df_grouped,
  x = ~reorder(Category, -Total),
  y = ~Total,
  type = "bar",
  marker = list(color = "steelblue"),
  hoverinfo = "text",
  text = ~paste(
    "Category:", Category,
    "<br>Total:", round(Total, 2),
    "<br>Transactions:", Cantidad,
    "<br>Average:", round(Promedio, 2)
  )
) %>%
  layout(
    title = "💳 Total spent by category",
    xaxis = list(title = "Category", tickangle = -45),
    yaxis = list(title = "Total spent ($)")
  )

fig_bar

