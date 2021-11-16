# 
# Models With R - Example 1
# Jeff Smith with 
#  Much code from http://r4ds.had.co.nz/model-basics.html
#
library("tidyverse")
library("modelr")

# Dataset ------
# Read our simple data set
(df <- read_csv("data\\reg_sample.csv"))
# Not sure what this is, but it looks like it could be a sample
# of price vs. sqft data from one of our real estate datasets. 

# Let's have a look (generally the first step with new data)
ggplot(data=df) +
  geom_point(aes(x=x, y=y),size=3)

# First model ------------------
# Seems like there might be a linear relationship between the 
# x and y variables.
# Define a model family using y = w1 + w2*x (intercept/slope line formula)
# model instance - w1, w2
w1 <- 0
w2 <- 150
ggplot(df, aes(x, y)) + 
  geom_abline(aes(intercept = w1, slope = w2)) +
  geom_point(size=3) 
# Note the slope/intercept form for geom_abline
# So, this model is our "low dimensional summary" of the dataset.

# Random models --------------------
# Generate some random models
num <- 200
models <- tibble(
  w1 = runif(num, -500000, 500000),
  w2 = runif(num, -100, 250)
)
# Check the models in the env ------->

# plot the random models with the data
ggplot(df, aes(x, y)) + 
  geom_abline(aes(intercept = w1, slope = w2), data = models, alpha = 1/4) +
  geom_point(size=3) 
# note that we plotted all 200 models with a single "call" of
# ggplot2.  As virtually all of R, it's vector-aware.


# Some look good others look bad -- how to pick one ... 
# Need a way to evaluate a model's quality ("goodness").

# The model takes an x value and generates a y value.

# Model function --------------------
# Create a model function - takes the model parameters 
# (w1 and w2) and the x values and returns the y values
model1 <- function(w, data) {
  w[1] + data$x * w[2]
}
# Note that there is no need for a "return" statement
# The last expression is returned.  In this case, the
# vector of y values for the given x values.

# sample invocation using the previously
# defined (single values) w1 and w2
model1(c(w1, w2), df)
# Note that this assumes that df has x defined.

# So now we have the y values from the data (df$y)
# and the y values predicted by the model.  For
# a "good" model, the predictions would be "close"
# to the real values.

# Distance metric ------
# Create a distance measure for a model.  Two 
# comment distance metrics -- RMS (root-mean-squared)
# and RSS (residual sum-of-squares) -- comment
# one of the two methods out.
measure_distance <- function(w, data) {
  diff <- data$y - model1(w, data)
  # RMS
  sqrt(mean(diff ^ 2))
  # RSS
#  sum(diff^2)
}

# sample invocation
measure_distance(c(w1, w2), df)
# Want to use measure_distance to measure the distance
# for each of our models (stored in models)

# Purrr -----
# I need a 2-parameter function for purrr -- code
# so that the sample dataset used automatically (note
# that df is not a parameter of this function, but is used internally)
sim1_dist <- function(w1, w2) {
  measure_distance(c(w1, w2), df)
}

# sample invocation - same as the measure_distance above.
sim1_dist(w1, w2)

# Use purrr to run the model function for each model
# and store the distance in the tibble (using mutate)
models <- models %>% 
  mutate(dist = purrr::map2_dbl(w1, w2, sim1_dist))
# See the models tibble -----> a new column.

# Plot the "top 10" best models.  How do we pick the 
# 10 best of our models?
ggplot(df, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = w1, slope = w2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )
# Looks much better.  Remember, all of the models were
# randomly generated.

# Look closer at the 10 best models and try to 
# identify patterns.

# Try looking at the models in model parameter space (w1~w2).
ggplot(models, aes(w1, w2)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
# Looks like the best models are in a relatively small region
# in the parameter space.

# Let's generate some more models are in the "good area" of the parameter 
# space and then evaluate these models using function.  First, let's
# generate a "grid" of possible w1 and w2 vales and evaluate each
# using the distance function.
?expand_grid
grid <- expand.grid(
  w1 = seq(-250000, 140000, length=25),
  w2 = seq(40, 250, length=25)
) %>%
  mutate(dist = purrr::map2_dbl(w1, w2, sim1_dist))
# Check grid out ------> 625 = 25 by 25.


# view the models with the best ones identified in parameter space
grid %>% 
  ggplot(aes(w1, w2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 

# plot the best 10 with the data points
ggplot(df, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = w1, slope = w2, colour = -dist), 
    data = filter(grid, rank(dist) <= 10)
  )

# Let's do one more grid refinement
# Go back and look a the parameter space view
grid <- expand.grid(
  w1 = seq(-100000, 50000, length=25),
  w2 = seq(100, 180, length=25)
) %>%
  mutate(dist = purrr::map2_dbl(w1, w2, sim1_dist))
# Go back and look at these in the parameter space
# and with the top 10 models.

# Could continue this process of systematic refinement
# as long as you want, but let's look at some other options.

# Best Fit Models -----
best <- optim(c(-500000, 0), measure_distance, data = df)
best$par

ggplot(df, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

# Fit the best linear model using lm()
m <- lm( y ~ x, df)
summary(m)
# plot the scatter and regression
ggplot(data=df) +
  geom_point(aes(x=x, y=y)) + 
  geom_abline(slope=coef(m)[2], intercept=coef(m)[1])

# Some model-related functions - Standard R lm object functions
coef(m)
formula(m)

# Predictions ----------------
# Predictions with Modelr
# Create a grid with the independent variables
grid <- df %>%
  data_grid(x)

# add the predictions from model m
grid <- grid %>%
  add_predictions(m)

# plot the points and the line from the predictions
ggplot(df, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

# Residuals with Modelr
df <- df %>%
  add_residuals(m)
# Check the df out ------------->

# frequency of the residuals
ggplot(df, aes(resid)) + 
  geom_freqpoly(binwidth = 50000)

# residuals
ggplot(df, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 

#
# Formulas and Model Families -----
#
# Create a tibble with a response (y) and 2 variables (x1, x2)
# note the 'r' -- tRibble, not tibble
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

model_matrix(df, y ~ x1)

model_matrix(df, y ~ x1 + x2)
