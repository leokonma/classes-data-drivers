


# 💰 Lesson: Personal Finance Analytics in R

This document explains step by step how the `finance_analysis.R` script works.  
It’s divided into **Data Wrangling**, **Reporting**, and **Visualization**, with improvements suggested at the end.


## Data Wrangling

### Libraries
We use:
- **tidyverse** → for filtering, grouping, summarizing.
- **plotly** → for interactive charts.
- **RColorBrewer** → for color palettes.

```r
install.packages(c("tidyverse", "plotly", "RColorBrewer"))
library(tidyverse)
library(plotly)
library(RColorBrewer)
````

---

###  Loading Data

We read the CSV file and inspect its structure.

```r
df <- read_csv("Personal_Finance_Dataset.csv")
glimpse(df)
```

If there is a date column (`Fecha`), it is converted to a date type:

```r
if ("Fecha" %in% names(df)) {
  df <- df %>% mutate(Fecha = as.Date(Fecha))
}
```

---

###  Separating Expenses and Income

```r
df_gastos <- df %>% filter(Type == "Expense")
df_ingresos <- df %>% filter(Type == "Income")
```

Splits the dataset into two subsets for analysis.

---

###  Summaries

#### Expenses

Groups transactions by description and calculates:

* `Cantidad` → how many times each expense occurred.
* `Total` → total money spent (made negative for clarity).

```r
df_gastos_summary <- df_gastos %>%
  group_by(`Transaction Description`) %>%
  summarise(
    Cantidad = n(),
    Total = sum(Amount, na.rm = TRUE),
    Category = first(Category)
  ) %>%
  ungroup() %>%
  mutate(Total = -Total)
```

#### Income

```r
df_ingresos_summary <- df_ingresos %>%
  group_by(`Transaction Description`, Category) %>%
  summarise(
    Cantidad = n(),
    Total = sum(Amount, na.rm = TRUE)
  ) %>%
  ungroup()
```

---

### Category Analysis

We merge and summarize totals by `Category`.

```r
df_merged <- df_gastos_summary %>%
  left_join(df %>% select(`Transaction Description`, Category), by = "Transaction Description")

df_grouped <- df_merged %>%
  group_by(Category) %>%
  summarise(
    Total = sum(Total, na.rm = TRUE),
    Cantidad = sum(Cantidad, na.rm = TRUE)
  ) %>%
  mutate(Promedio = Total / Cantidad) %>%
  arrange(desc(Total))
```

---

## Reporting

### Total KPIs

```r
cat("\n💸 Total spent:", sum(df_gastos_summary$Total))
cat("\n💵 Total income:", sum(df_ingresos_summary$Total))
cat("\n💰 Net balance:", sum(df_ingresos_summary$Total) + sum(df_gastos_summary$Total))
```

Gives quick insight into your financial standing.

---

## Visualization

### Bar Chart — Total Spent by Category

```r
fig_bar <- plot_ly(
  data = df_grouped,
  x = ~reorder(Category, -Total),
  y = ~Total,
  type = "bar",
  marker = list(color = "steelblue"),
  hoverinfo = "text",
  text = ~paste("Category:", Category, "<br>Total:", round(Total, 2))
) %>%
  layout(
    title = "💳 Total spent by category",
    xaxis = list(title = "Category", tickangle = -45),
    yaxis = list(title = "Total spent ($)")
  )

fig_bar
```
---

## Suggested Improvements

### Data Wrangling

* Use `janitor::clean_names()` for cleaner column names.
* Add `lubridate` to analyze trends by month or week.
* Create an external `categories.csv` file to maintain category definitions.

### Reporting

* Add an automated Excel export:

  ```r
  install.packages("writexl")
  writexl::write_xlsx(list(
    Expenses = df_gastos_summary,
    Income = df_ingresos_summary,
    Categories = df_grouped
  ), "Finance_Report.xlsx")
  ```

### Visualization

* Combine charts in one dashboard:

  ```r
  subplot(fig_bar, fig_donut, nrows = 1, shareY = FALSE)
  ```
* Add a time series of cumulative balance using `plot_ly(type = "scatter", mode = "lines+markers")`.

---

