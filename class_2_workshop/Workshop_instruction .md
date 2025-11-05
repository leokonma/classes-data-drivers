# 🗽 NYC Flights — Tidyverse Practice Questions


## 1. Data Wrangling

### Q1.1  
How many flights departed from **JFK airport** in **January**?

### Q1.2  
Create a subset of flights that:
- Departed from **LGA**
- Flew more than **1,000 miles**
- Had a **departure delay greater than 60 minutes**

Only keep the columns `year`, `month`, `day`, `carrier`, `dest`, `distance`, and `dep_delay`.

### Q1.3  
Create a new column called `speed` (in miles per hour) calculated as:

\[
speed = \frac{distance}{(air\_time / 60)}
\]

Then compute the **average speed** of all flights.

### Q1.4  
Some flights have missing values in `air_time` or `dep_delay`.  
How can you modify your code to **ignore NAs** in calculations?

---

##  2. Grouping and Summarizing

### Q2.1  
Which **airline (carrier)** had the **highest average arrival delay** in 2013?

### Q2.2  
Compute the **average departure delay per month** and arrange the results in **descending order**.

### Q2.3  
Which **destination airport** had the **most flights**?

### Q2.4  
For each **origin airport** (`JFK`, `LGA`, `EWR`), calculate:
- The number of flights  
- The average distance  
- The average arrival delay  

Then arrange them from best (lowest avg delay) to worst.

---

##  3. Data Visualization

### Q3.1  
Make a **bar chart** showing the **average arrival delay by airline**, sorted from worst to best average delay.

### Q3.2  
Plot the **average arrival delay by month** as a **line chart**, with proper labels and title.

### Q3.3  
Make a **boxplot** showing the **distribution of arrival delays per origin airport** (`JFK`, `LGA`, `EWR`).

### Q3.4  
Create a plot colored by **origin airport** and **faceted by carrier**.  
Which airlines have the greatest variation in delays?

