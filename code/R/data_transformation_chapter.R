#
# Ch 5 - Data Transformation
# R for Data Science - http://r4ds.had.co.nz/
#
library(tidyverse)
library(nycflights13)

# NYC Flights Dataset -----
# check out the dataset
?nycflights13::flights
nycflights13::flights
# aliased to flights -- can use either
flights
# variables in the tibble - Look at the help or:
colnames(nycflights13::flights)       # columns names

# Some other data on the dataset
class(nycflights13::flights)          # get class
sapply(nycflights13::flights, class)  # get class of all columns
# What is this sapply function?
?sapply
str(nycflights13::flights)            # structure
summary(nycflights13::flights)        # summary
nrow(nycflights13::flights)           # number of rows
ncol(nycflights13::flights)           # number of columns
# So it's a relatively large data set of real data

#
# Seems out of place -- but important.    
#
# Comparisons -- floating point == can be problematic
sqrt(2)^2 == 2
1/49 * 49 == 1
# use the near() function instead
near(sqrt(2)^2, 2)
near(1/49*49, 1)


#
# Using dplyr
#   filter, arrange, select, mutate/transmutate, summarize, group_by
#
# Filter ----------------------------------------------------------
#
# Filter the January flights - filter with the condition
# that the month variable is 1 (month == 1)
filter(flights, month == 1)
# Note that this creates a new (anonymous) tibble.
# If you want to save it, you need to assign the result
jan <- filter(flights, month == 1)
jan
# Note that if you enclose the statement in (),
# the resulting tibble will be printed after creation (a shortcut)
(jan <- filter(flights, month == 1))

# Create (and show) a new tibble with the January 1 flights
# Two conditions -- month == 1 and day == 1
(jan1 <- filter(flights, month == 1, day == 1))
#
# Note here that if we want help, we need to use the fully
# qualified name since stats::filter also exists
?dplyr::filter
# We can also combine the two conditions into a single
# condition by using a logical operator
(jan1 <- filter(flights, month == 1 & day == 1))

#
# See the pptx slide on Logical Operators (or the book image)
#

# The conditions below are equivalent -- use the format
# that is clearer to you!
(nov_dec <- filter(flights, month == 11 | month == 12))
# don't use "month == 11 | 12" --- why?  Test it out!
# Using the %in% operator
(nov_dec <- filter(flights, month %in% c(11, 12)))
#
# In R, the %in% operator tests whether an element is in a vector or dataframe 
x <- 7
x %in% c(1, 2, 3)
#
# dplyr filter() uses this operator internally to create 
# and apply a mask for the provided tibble
flights$month %in% c(11, 12)
# and count the TRUE values (should be the size of the tibble)
sum(flights$month %in% c(11, 12))

#
# For comparison, suppose you wanted these two filter operations
# with standard data frames instead of tibbles and filter()
# Nov+Dec flights
# Note the trailing comma to filter the rows of a DataFrame...
(tmp = flights[flights$month == 11 | flights$month == 12,])
# Let's see what's going on here:
mask = flights$month == 11 | flights$month == 12
# if you just wanted a count of the flights ...
sum(mask)
# As before, the sum result should be the number of rows in the dataframe.


#
# August late departures
#
# Suppose you want to know how many flights from august
# had departure delays of more that 2 hours
# month == 8 and dep_delay > 120 is the condition
# Option 1:
(aug_baddies <- filter(flights, month == 8 & dep_delay > 120))
# Note the '&' - specifies an and condition.

# Option 2:
# Note the following version uses two conditions rather than
# a single condition involving an 'and' operator.
(aug_baddies1 <- filter(flights, month == 8, dep_delay > 120))
# Here, filter() is handling condition construction.

# Note also that filter() excludes NA values in addition to FALSE
# values.  So there is no need to use omit.na() or similar functions.

# Using standard R rather than dplyr - need to mask the dataframe
# try counting them first
sum(flights$month == 8 & flights$dep_delay > 120)
# oops -- NA values.  Simple masking could include NA values.
# Where are they coming from?
sum(flights$month == 8)
# ok
sum(flights$dep_delay > 120)
# So, the problem is not the combined condition, it's with the missing
# departure delay values
# Use the mask to create the dataframe anyway
aug_baddies2 = flights[flights$month == 8 & flights$dep_delay > 120,]
# Compare aug_baddies and aug_baddies2 in the Environment ---->
# Look in aug_baddies2 and you'll see the NA values.

# first, get rid of the NA values .. don't forget '?complete.cases' for help
tmp = flights[complete.cases(flights$dep_delay),]
aug_baddies2 = tmp[tmp$month == 8 & tmp$dep_delay > 120,]
? complete.cases
# returns a logical vector -- use as a mask
(another_mask <- complete.cases(flights$dep_delay))
# so, the filter() method on tibbles excludes FALSE and NA values (and is a
# bit easier to read.)

#
# To practice (and you should), think of an interesting question  
# and develop the corresponding filter for it ...
#
# 
# Find all of the plane tail numbers
unique(flights$tailnum)

# flights by tail number N5CLAA
(n5claa <- filter(flights, tailnum =="N5CLAA"))
# February flights by tail number N5CLAA
filter(n5claa, month==2)
# or
filter(flights, tailnum == "N5CLAA", month == 2)
# or
filter(flights, tailnum == "N5CLAA" & month == 2)

# flights headed for Miami during November, December, January, February
# Condition: destination is Miami and month is 1, 2, 11, or 12
(beach <- filter(flights, dest == 'MIA' & (month %in% c(1, 2, 11, 12))))
# or using multiple conditions rather than the & (and)
beach1 <- filter(flights, dest == 'MIA',(month %in% c(1, 2, 11, 12)))

#
# beach flights that were delayed on arrival for more than 45 minutes
late_beach <- filter(beach, arr_delay > 45)
# or
late_beach <- filter(flights, dest == 'MIA' & (month %in% c(1, 2, 11, 12)) & arr_delay > 45)
# or
late_beach <- filter(flights, dest == 'MIA', (month %in% c(1, 2, 11, 12)), arr_delay > 45)

# What about Jacksonville (JAX)?  It's a beach location also.
filter(flights, dest == 'JAX', (month %in% c(1, 2, 11, 12)), arr_delay > 45)
# combining JAX and MIA
late_beach1 <- filter(flights, (dest == 'JAX' | dest == 'MIA'), (month %in% c(1, 2, 11, 12)), arr_delay > 45)
# Note the parens on the dest conditions.

#
# Arrange ----------------------------------------------------------
#
# Sort the data -- note that a new tibble is returned, the original is left unchanged
# (standard behavior for dyplr)
arrange(flights, year, month, day)
arrange(flights, desc(day), month)

# if you want to save the sorted values, assign
(bad_flights <- arrange(flights, desc(dep_delay)))

# details -- note the concept of 'locales' 
?arrange

#
# Select ----------------------------------------------------------
#
# Select specific columns. Note that a new tibble is returned
#
select(flights, year, month, day, dep_time)
# combining functions
select(arrange(flights, desc(day)), day, month, dep_time)
# slightly more efficient ...
arrange(select(flights, day, month, dep_time), desc(day))

# helper functions for selecting columns
select(flights, starts_with("arr"))
select(flights, ends_with("time"))
select(flights, contains("dep"))
# details
?select

#
# Mutate ----------------------------------------------------------
# Adding new columns
# Create a new tibble with selected columns.  Note the 
# use of spacing/newlines to improve readability
(flights_sml <- select(flights, 
  year:day, 
  ends_with("delay"), 
  distance, 
  air_time
))
# Note the 'year:day' - all columns between the two
#
# Add some new computed columns
mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)
# Check the environment ----> We mutate doesn't change
# the data frame -- it returns the mutated data frame.
# Standard behavior for dplyr

# Or, all at once
mutate(
  select(flights, 
    year:day, 
    ends_with("delay"), 
    distance, 
    air_time),
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# Use transmute if you only want the new columns
transmute(flights,
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)


#
# Summarise and Group By ----------------------------------------------------------
#
# First, summarize over the entire dataset
summarise(flights, delay=mean(dep_delay, na.rm = TRUE))

summarise(flights, 
          delay=mean(dep_delay, na.rm = TRUE), 
          distance=mean(distance, na.rm = TRUE)
          )

# Group the flights by day
by_day <- group_by(flights, year, month, day)
# summarize the group
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
# So, what is the by_day object -- In the environment, it looks just like bad_flights
class(by_day)
class(flights)
#
?group_by # Ah, creates a "grouped tibble"

# to save the daily summaries from above:
(daily_summaries <- summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)))
# sort by badness 
arrange(daily_summaries, desc(delay))

# Group by destination, count the number, sort in descending order
by_dest <- group_by(flights, dest)
s <- summarize(by_dest, 
  num = n(),
  dist = mean(distance, na.rm=TRUE) 
)
(s1 <- arrange(s, desc(num)))

#
# piping - See pptx slide -------------------------
#
# consider this sample analysis
# Group by destination
by_dest <- group_by(flights, dest)
# Sumarize the number of flights, mean distance, and mean delay
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
# filter to destinations with more that 20 flights and 
# exclude Honolulu
(delay1 <- filter(delay, count > 20, dest != "HNL"))

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay1, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'

#
# The 'pipe' allows you to do this type of multi-step process
# without storing the intermediate results;
#
(delay2 <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL"))
# %>% ==> "then"
# See the pptx slide

# what if we include Honolulu -- and do everything at once:
# combined 
ggplot(flights %>% 
         group_by(dest) %>% 
         summarise(
           count = n(),
           dist = mean(distance, na.rm = TRUE),
           delay = mean(arr_delay, na.rm = TRUE)
         ) %>% 
         filter(count > 20)
  , mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

#
# Suppose that you want to know the popular destinations and their distances
#
(popular_dests <- flights %>%
  group_by(dest) %>%
  summarize(
    num = n(),
    dist = mean(distance, na.rm=TRUE)
  ) %>%
  filter(num > 5000) %>%
  mutate(tot = num * dist) %>%
  arrange(desc(num)))
# flights then group_by then summarize then filter then mutate then arrange
#

# Practice, practice, practice.  Ask a question, then formulate
# the dyplyr statement to generate "the answer"
#

#
# Meal example from the Python section of the class ---------------------
#
# pptx slide ->
# 
# Compare to the Python versions in the Jupyter notebook:
#    "Meals - Aggregation and Grouping Example.ipynb"
#
# Get the current working directory
print(getwd())
# Read the meals data and create a tibble
data <- read.csv("data\\12_meals.csv", stringsAsFactors=FALSE)
meals <- as_tibble(data)
# or reading them as a tibble directly
meals <- read_csv("data\\12_meals.csv")


# Compute the tip percentage
(meals <- meals %>%
  mutate(tip_percentage = tip / cost))
# Note that the mutate operation did not update 
# the meals tibble, but the assignment overwrote the
# the previous version, so the net effect was updating
# the tibble.

# summarize the whole dataset.
summarize(meals, count=n(), 
         avg_tip=mean(tip, na.rm=TRUE),
         avg_cost=mean(cost, na.rm = TRUE),
         med_tp = median(tip_percentage, na.rm = TRUE),
         total_people = sum(party_size, na.rm = TRUE)
         )

# what days?
unique(meals$day)
# By day: we could filter
meals %>%
  filter(day == "Mon") %>%
  summarize(count=n(), 
            avg_tip=mean(tip, na.rm=TRUE),
            avg_cost=mean(cost, na.rm = TRUE),
            med_tp = median(tip_percentage, na.rm = TRUE),
            total_people = sum(party_size, na.rm = TRUE)
  )
# for each day

# Or group and do it in one shot.
(meals_by_day <- meals %>%
  group_by(day) %>%
  summarise (
    count = n(),
    avg_tip = mean(tip, na.rm = TRUE),
    avg_cost = mean(cost, na.rm = TRUE),
    med_tp = median(tip_percentage, na.rm = TRUE),
    total_people = sum(party_size, na.rm = TRUE)
  ))

# Try by meal ...
(meals_by_meal <- meals %>%
  group_by(meal) %>%
  summarise (
    count = n(),
    avg_tip = mean(tip, na.rm = TRUE),
    avg_cost = mean(cost, na.rm = TRUE),
    med_tp = median(tip_percentage, na.rm = TRUE),
    total_people = sum(party_size, na.rm = TRUE)
  ))

# Who pays ...
(meals_by_payer <- meals %>%
  group_by(payer) %>%
  summarise (
    count = n(),
    avg_tip = mean(tip, na.rm = TRUE),
    avg_cost = mean(cost, na.rm = TRUE),
    med_tp = median(tip_percentage, na.rm = TRUE),
    total_people = sum(party_size, na.rm = TRUE)
  ))

#
# Diamond data set -------------------------------
#
diamonds

# by cut
(by_cut <- diamonds %>%
    group_by(cut) %>%
    summarise(
      count = n(),
      avg_price = mean(price, na.rm=TRUE)
      ) %>%
    arrange(desc(avg_price)))

# by clarity
(by_clarity <- diamonds %>%
    group_by(clarity) %>%
    summarise(
      count = n(),
      avg_price = mean(price, na.rm=TRUE)
    ) %>%
    arrange(desc(avg_price)))

# Accessing build-in datasets -------
library(datasets)

# if you want to see the details
library(help='datasets')
# also at https://www.rdocumentation.org/packages/datasets/versions/3.6.2

# How about some European stock prices?
(eustock <- as_tibble(datasets::EuStockMarkets))

select(eustock, DAX, FTSE)

filter(select(eustock, DAX, FTSE), DAX > 1650)

str(eustock)
summary(eustock)

# Practice, practice, practice.


