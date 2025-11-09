
# 🗽 NYC Flights — Function Reference and Explanations

This document explains all the **functions and concepts** used in the `nycflights13` tidyverse practice script.  
It serves as a guide for students who are new to R programming and want to understand *what each function does and why it’s used*.

---

##1. Setup Functions

### `library()`
**Purpose:** Loads an installed R package into your environment.  
**Usage:**  
```r
library(tidyverse)
library(nycflights13)
````

**Arguments:**

* `package`: The name of the package (as text or unquoted).

👉 *Here we load `tidyverse` for data manipulation and plotting, and `nycflights13` for the flight dataset.*

---

### `::` operator

**Purpose:** Accesses an object (dataset or function) directly from a package.
Example:

```r
flights <- nycflights13::flights
```

Retrieves the `flights` data frame stored inside the `nycflights13` package.

---

## 2. Data Wrangling Functions

### `filter()`

**Purpose:** Selects rows that meet certain conditions.
**Usage:**

```r
filter(flights, origin == "JFK", month == 1)
```

**Arguments:**

* Conditions combined with commas (`,` acts like `AND`).
* Uses logical operators (`==`, `>`, `<`, `&`, `|`).

---

### `select()`

**Purpose:** Keeps only specific columns in a data frame.
**Usage:**

```r
select(year, month, day, carrier, dest)
```

**Arguments:**

* A list of column names you want to keep.

---

### `mutate()`

**Purpose:** Creates or modifies variables (adds new columns).
**Usage:**

```r
mutate(speed = distance / (air_time / 60))
```

**Arguments:**

* `new_column = expression` defining how to calculate it.

---

### `summarize()` / `summarise()`

**Purpose:** Computes summary statistics for groups or entire data.
**Usage:**

```r
summarize(avg_air_time = mean(air_time, na.rm = TRUE))
```

**Arguments:**

* Name for each summary (e.g. `avg_air_time`).
* Expression (e.g. `mean()`, `sum()`, `n()`).
* `na.rm = TRUE`: removes missing values before computing.

---

### `group_by()`

**Purpose:** Groups rows based on one or more variables for later summarization.
**Usage:**

```r
group_by(carrier)
```

**Arguments:**

* One or more column names.

👉 *It tells R: “Summarize these values separately for each group.”*

---

### `arrange()`

**Purpose:** Sorts rows in ascending or descending order.
**Usage:**

```r
arrange(desc(avg_arr_delay))
```

**Arguments:**

* Column names to sort by.
* Use `desc()` for descending order.

---

### `n()`

**Purpose:** Counts the number of rows in each group.
**Usage:**

```r
summarize(n_flights = n())
```

**Arguments:** *(none)*

---

### `slice_max()`

**Purpose:** Returns the row(s) with the maximum value of a variable.
**Usage:**

```r
slice_max(avg_arr_delay, n = 1)
```

**Arguments:**

* `order_by`: column to find maximum.
* `n`: number of rows to return.

---

### `mean()`

**Purpose:** Computes the average (arithmetic mean) of a numeric vector.
**Usage:**

```r
mean(x, na.rm = TRUE)
```

**Arguments:**

* `x`: numeric vector.
* `na.rm = TRUE`: ignore missing values.

---

### `nrow()`

**Purpose:** Counts number of rows in a data frame.
**Usage:**

```r
nrow(flights)
```

**Arguments:** *(only one — the data frame)*

---

### `head()`

**Purpose:** Displays the first few rows of a dataset (default = 6).
**Usage:**

```r
head(flights)
```

---

## 📊 3. Data Visualization with ggplot2

All plots use the structure:

```r
ggplot(data, aes(x = ..., y = ...)) +
  geom_*() +
  labs()
```

where each `geom_*()` defines the *type* of plot.

---

### `ggplot()`

**Purpose:** Initializes a plot.
**Usage:**

```r
ggplot(flights, aes(x = origin, y = arr_delay))
```

**Arguments:**

* `data`: the dataset.
* `aes()`: defines aesthetic mappings (x, y, color, fill, etc.).

---

### `aes()`

**Purpose:** Describes *what variables* to visualize.
**Example:**

```r
aes(x = carrier, y = avg_arr_delay)
```

**Common arguments:**

* `x`, `y`: axes.
* `fill`: color fill based on a variable.
* `color`: border color.

---

### `geom_col()`

**Purpose:** Creates a bar chart from summarized data.
**Usage:**

```r
geom_col(fill = "steelblue")
```

**Arguments:**

* `fill`: color of bars.
* `width`: bar width (optional).

---

### `geom_line()` & `geom_point()`

**Purpose:** Line and point charts for trends.
**Usage:**

```r
geom_line(color = "tomato")
geom_point(size = 2)
```

---

### `geom_boxplot()`

**Purpose:** Shows distribution (median, quartiles, outliers).
**Usage:**

```r
geom_boxplot(outlier.color = "gray50")
```

**Arguments:**

* `outlier.color`: color for outliers.
* `fill`: box color (if defined).

---

### `geom_smooth()`

**Purpose:** Adds a trend line or model fit (e.g. linear regression).
**Usage:**

```r
geom_smooth(method = "lm", color = "red")
```

**Arguments:**

* `method`: statistical model (e.g., `"lm"` = linear model).
* `color`: line color.

---

### `coord_flip()`

**Purpose:** Flips axes (makes horizontal bar plots).
**Usage:**

```r
coord_flip()
```

---

### `facet_wrap()`

**Purpose:** Splits data into multiple small plots (“facets”).
**Usage:**

```r
facet_wrap(~ carrier)
```

**Arguments:**

* `~ variable`: variable to facet by.

---

### `labs()`

**Purpose:** Adds titles and axis labels.
**Usage:**

```r
labs(title = "Average Delay by Airline",
     x = "Carrier",
     y = "Delay (min)")
```

---

### `theme_minimal()`

**Purpose:** Applies a clean, simple theme to plots.
**Usage:**

```r
theme_minimal()
```

---

## 🔗 4. Data Joining

### `left_join()`

**Purpose:** Combines two datasets by matching rows on a key column.
**Usage:**

```r
left_join(airlines, by = "carrier")
```

**Arguments:**

* `x`, `y`: data frames to join.
* `by`: name of the common key column.

---

## 🧠 5. Custom Expressions Used

### `reorder()`

**Purpose:** Reorders factor levels based on a numeric variable.
**Usage:**

```r
reorder(carrier, avg_arr_delay)
```

*Used to sort bars in ggplot by average delay.*

---

### `desc()`

**Purpose:** Orders data in descending order.
**Usage:**

```r
arrange(desc(avg_arr_delay))
```

---

### `na.rm = TRUE`

**Purpose:** Removes missing values from calculations like `mean()`.
Without it, R returns `NA` when missing values are present.

---

### In one sentence:

> This script demonstrates the full tidyverse workflow: *import → transform → summarize → visualize → interpret.*

---

```
```
