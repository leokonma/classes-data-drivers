
# ============================================================
# 🗽 NYC Flights — Tidyverse Practice with Solutions
# ============================================================

# === Setup ===
library(tidyverse)
library(nycflights13)

flights <- nycflights13::flights
airlines <- nycflights13::airlines
airports <- nycflights13::airports

# ============================================================
# 🧩 1. DATA WRANGLING
# ============================================================

# Q1.1 — How many flights departed from JFK in January?
jfk_january <- flights %>%
  filter(origin == "JFK", month == 1)
nrow(jfk_january)

# Q1.2 — Flights from LGA, >1000 miles, dep_delay > 60
lga_long_delays <- flights %>%
  filter(origin == "LGA", distance > 1000, dep_delay > 60) %>%
  select(year, month, day, carrier, dest, distance, dep_delay)
head(lga_long_delays)

# Q1.3 — Create speed variable and compute average
flights_speed <- flights %>%
  mutate(speed = distance / (air_time / 60))
mean(flights_speed$speed, na.rm = TRUE)

# Q1.4 — Handle missing values in summaries
flights %>%
  summarize(
    avg_air_time = mean(air_time, na.rm = TRUE),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  )

# ============================================================
# 📊 2. GROUPING AND SUMMARIZING
# ============================================================

# Q2.1 — Airline with highest average arrival delay
carrier_delays <- flights %>%
  group_by(carrier) %>%
  summarize(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_flights = n()
  ) %>%
  arrange(desc(avg_arr_delay))
carrier_delays
carrier_delays %>% slice_max(avg_arr_delay, n = 1)

# Q2.2 — Average departure delay per month (descending)
month_delays <- flights %>%
  group_by(month) %>%
  summarize(avg_dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_dep_delay))
month_delays

# Q2.3 — Destination with the most flights
dest_counts <- flights %>%
  group_by(dest) %>%
  summarize(num_flights = n()) %>%
  arrange(desc(num_flights))
head(dest_counts)

# Q2.4 — Summary by origin airport
origin_summary <- flights %>%
  group_by(origin) %>%
  summarize(
    total_flights = n(),
    avg_distance = mean(distance, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  arrange(avg_arr_delay)
origin_summary

# ============================================================
# 🎨 3. DATA VISUALIZATION
# ============================================================

# Q3.1 — Bar chart: average arrival delay by airline
ggplot(carrier_delays, aes(x = reorder(carrier, avg_arr_delay),
                           y = avg_arr_delay)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Airline",
    x = "Carrier",
    y = "Average Arrival Delay (min)"
  )

# Q3.2 — Line chart: average arrival delay by month
month_delays %>%
  ggplot(aes(x = month, y = avg_dep_delay)) +
  geom_line(color = "tomato", linewidth = 1) +
  geom_point(size = 2) +
  labs(
    title = "Average Departure Delay by Month",
    x = "Month",
    y = "Average Delay (min)"
  )

# Q3.3 — Boxplot: arrival delays per origin
ggplot(flights, aes(x = origin, y = arr_delay, fill = origin)) +
  geom_boxplot(outlier.color = "gray50") +
  labs(
    title = "Arrival Delays by Origin Airport",
    x = "Origin Airport",
    y = "Arrival Delay (min)"
  ) +
  theme_minimal()

# Q3.4 — Faceted plot: origin x carrier
ggplot(flights, aes(x = origin, y = arr_delay, fill = origin)) +
  geom_boxplot() +
  facet_wrap(~ carrier) +
  labs(
    title = "Arrival Delays by Origin and Airline",
    x = "Origin",
    y = "Arrival Delay (min)"
  ) +
  theme_minimal()

# ============================================================
# 🧠 4. MINI CHALLENGES — “TELL A STORY”
# ============================================================

# Example 1 — Most punctual airline
flights %>%
  group_by(carrier) %>%
  summarize(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(avg_arr_delay) %>%
  ggplot(aes(x = reorder(name, avg_arr_delay), y = avg_arr_delay)) +
  geom_col(fill = "seagreen3") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Airline",
    x = "Airline",
    y = "Average Arrival Delay (min)"
  )

# Example 2 — Destination with worst delays
flights %>%
  group_by(dest) %>%
  summarize(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_arr_delay)) %>%
  ggplot(aes(x = reorder(dest, avg_arr_delay), y = avg_arr_delay)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Destination",
    x = "Destination",
    y = "Average Arrival Delay (min)"
  )

# Example 3 — Relationship between distance and delay
flights %>%
  ggplot(aes(x = distance, y = arr_delay)) +
  geom_point(alpha = 0.2, color = "royalblue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Relationship Between Flight Distance and Arrival Delay",
    x = "Distance (miles)",
    y = "Arrival Delay (min)"
  )

# ============================================================
# ✅ End of script
# ============================================================
=======
# ============================================================
# 🗽 NYC Flights — Tidyverse Practice with Solutions
# ============================================================

# === Setup ===
library(tidyverse)
library(nycflights13)

flights <- nycflights13::flights
airlines <- nycflights13::airlines
airports <- nycflights13::airports

# ============================================================
# 🧩 1. DATA WRANGLING
# ============================================================

# Q1.1 — How many flights departed from JFK in January?
jfk_january <- flights %>%
  filter(origin == "JFK", month == 1)
nrow(jfk_january)

# Q1.2 — Flights from LGA, >1000 miles, dep_delay > 60
lga_long_delays <- flights %>%
  filter(origin == "LGA", distance > 1000, dep_delay > 60) %>%
  select(year, month, day, carrier, dest, distance, dep_delay)
head(lga_long_delays)

# Q1.3 — Create speed variable and compute average
flights_speed <- flights %>%
  mutate(speed = distance / (air_time / 60))
mean(flights_speed$speed, na.rm = TRUE)

# Q1.4 — Handle missing values in summaries
flights %>%
  summarize(
    avg_air_time = mean(air_time, na.rm = TRUE),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  )

# ============================================================
# 📊 2. GROUPING AND SUMMARIZING
# ============================================================

# Q2.1 — Airline with highest average arrival delay
carrier_delays <- flights %>%
  group_by(carrier) %>%
  summarize(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_flights = n()
  ) %>%
  arrange(desc(avg_arr_delay))
carrier_delays
carrier_delays %>% slice_max(avg_arr_delay, n = 1)

# Q2.2 — Average departure delay per month (descending)
month_delays <- flights %>%
  group_by(month) %>%
  summarize(avg_dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_dep_delay))
month_delays

# Q2.3 — Destination with the most flights
dest_counts <- flights %>%
  group_by(dest) %>%
  summarize(num_flights = n()) %>%
  arrange(desc(num_flights))
head(dest_counts)

# Q2.4 — Summary by origin airport
origin_summary <- flights %>%
  group_by(origin) %>%
  summarize(
    total_flights = n(),
    avg_distance = mean(distance, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  arrange(avg_arr_delay)
origin_summary

# ============================================================
# 🎨 3. DATA VISUALIZATION
# ============================================================

# Q3.1 — Bar chart: average arrival delay by airline
ggplot(carrier_delays, aes(x = reorder(carrier, avg_arr_delay),
                           y = avg_arr_delay)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Airline",
    x = "Carrier",
    y = "Average Arrival Delay (min)"
  )

# Q3.2 — Line chart: average arrival delay by month
month_delays %>%
  ggplot(aes(x = month, y = avg_dep_delay)) +
  geom_line(color = "tomato", linewidth = 1) +
  geom_point(size = 2) +
  labs(
    title = "Average Departure Delay by Month",
    x = "Month",
    y = "Average Delay (min)"
  )

# Q3.3 — Boxplot: arrival delays per origin
ggplot(flights, aes(x = origin, y = arr_delay, fill = origin)) +
  geom_boxplot(outlier.color = "gray50") +
  labs(
    title = "Arrival Delays by Origin Airport",
    x = "Origin Airport",
    y = "Arrival Delay (min)"
  ) +
  theme_minimal()

# Q3.4 — Faceted plot: origin x carrier
ggplot(flights, aes(x = origin, y = arr_delay, fill = origin)) +
  geom_boxplot() +
  facet_wrap(~ carrier) +
  labs(
    title = "Arrival Delays by Origin and Airline",
    x = "Origin",
    y = "Arrival Delay (min)"
  ) +
  theme_minimal()

# ============================================================
# 🧠 4. MINI CHALLENGES — “TELL A STORY”
# ============================================================

# Example 1 — Most punctual airline
flights %>%
  group_by(carrier) %>%
  summarize(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(avg_arr_delay) %>%
  ggplot(aes(x = reorder(name, avg_arr_delay), y = avg_arr_delay)) +
  geom_col(fill = "seagreen3") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Airline",
    x = "Airline",
    y = "Average Arrival Delay (min)"
  )

# Example 2 — Destination with worst delays
flights %>%
  group_by(dest) %>%
  summarize(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_arr_delay)) %>%
  ggplot(aes(x = reorder(dest, avg_arr_delay), y = avg_arr_delay)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Average Arrival Delay by Destination",
    x = "Destination",
    y = "Average Arrival Delay (min)"
  )

# Example 3 — Relationship between distance and delay
flights %>%
  ggplot(aes(x = distance, y = arr_delay)) +
  geom_point(alpha = 0.2, color = "royalblue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Relationship Between Flight Distance and Arrival Delay",
    x = "Distance (miles)",
    y = "Arrival Delay (min)"
  )

# ============================================================
# ✅ End of script
# ============================================================
