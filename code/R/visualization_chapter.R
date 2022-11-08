#
# Ch 3 - Visualization
# R for Data Science - http://r4ds.had.co.nz/
#

library(tidyverse)

# if you don't have it installed, use:
# install.packages("tidyverse")
# and retry the library() function.

# 
# Grab a few datasets
#

# MPG Dataset ----
# use ? to get help.  Consider a dataset (e.g., mpg), ?mpg gives
# a help page.  Note that this dataset is part of ggplot2
?mpg

mpg # to show the first 10 rows + information
# What is a tibble?  Type 'tibble' in the console and the look for the context menu
vignette("tibble")
# Also, chapter 10 of the R for Data Science book (a very short chapter)

# View/Edit in grid format and add to the environment (------>)
# Note that you can edit existing values and add new 
# values using this method.
fix(mpg)

# The iris dataset
?iris
# Note that this is part of the built-in R datasets in the datasets library
# Convert the dataset to a tibble
tiris <- as_tibble(iris) 
# Note that since mpg was part of ggplot2, it was already stored as a tibble,
# so no conversion was necessary

# other built-in data sets?
?datasets
library(help = "datasets")

# Some "local data" -- Auburn Real Estate from 2017.  Note that
# we are reading this one directly from a csv file
aure <- read_csv("data\\au_real_estate_2017_anon.csv")

# structure of the data
str(aure)

# Car prices
carprices <- read_csv("data\\CarPricesSet.csv")

#
# Scatter plots -----
#
# First with the MPG dataset
#
# Start with a question: Is there a relationship between engine size and gas mileage?
# Try a basic scatter plot:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# help again - note the question mark in front of the function name
?ggplot()
#
# PPTX Slide with Graphing Template - and description of the Grammar of
# Graphics

# color the dots by class (a new variable from the data).  Note that
# the color parameter is inside the aesthetic function here
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# ggplot2 did the mapping between plot color and vehicle class and
# created a legend.
#
# Does this help the plot?  Hurt the plot?


# What about city mileage?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = cty, color = class))
# Note that in RStudio, you can easily move through the generated
# plots using the forward/backward arrows (no need to regenerate
# as long as you are in the same session)

# use dot size based on vehicle class
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
# Note the warning about using size for a discrete variable.
# Try displacement instead
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = displ))
# Now the size doesn't really give us more information since it's
# already the x variable


# What if we flip the x and size?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = hwy, size = displ))
# Is this a "good" plot?  What does "good" mean in this sense?

# use size and color - note the city mileage variable (cty)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cty, color=class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = hwy, size = cty, color=displ))

# use transparency (alpha)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# All orange dots - note that the color parameter is outside of
# the aesthetic function here.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color="orange")

# Why not blue?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color="blue"))
# color is specified inside the aesthetic, not in the mapping.
# Book describes other common mistakes/problems.

#
# Note that we can also define the mapping with the data rather than
# with the geom.  This will be useful below when we have multiple
# geoms.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
  geom_point()
# We will see how this is helpful soon.

#
# Now with the iris dataset
#
# Is there a relationship between Petal Width and Petal Length? 
ggplot(data = tiris, mapping = aes(x = Petal.Length, y = Petal.Width)) +
  geom_point()

# Does the relationship depend on species?
ggplot(data = tiris, mapping = aes(x = Petal.Length, y = Petal.Width)) +
  geom_point(mapping = aes(color = Species))

# or flipping x and y
ggplot(data = tiris, mapping = aes(x = Petal.Width, y = Petal.Length)) +
  geom_point(mapping = aes(color = Species))

# add size
ggplot(data = tiris, mapping = aes(x = Petal.Length, y = Petal.Width, size=Petal.Width)) +
  geom_point(mapping = aes(color = Species))

# changing variables -- Sepal.Length now
ggplot(data = tiris, mapping = aes(x = Petal.Length, y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species))

# 
# The Auburn real estate dataset
#
# Relationship between house price and square footage
ggplot(data = aure) + 
  geom_point(mapping = aes(x = SqFt, y = Price))

#
# Car prices
# 
# Relationship between mileage and price
ggplot(data = carprices) + 
  geom_point(mapping = aes(x = Mileage, y = Price))
# oops -- what's the issue?
carprices$Mileage[1:5]
class(carprices$Mileage)

# Search for "parse number from string r"
# https://stackoverflow.com/questions/14543627/extracting-numbers-from-vectors-of-strings
#
# Try parse_number from readr
carprices$MileageNumeric <- parse_number(carprices$Mileage)
ggplot(data = carprices) + 
  geom_point(mapping = aes(x = MileageNumeric, y = Price))
# hmmmm - maybe outliers
min(carprices$MileageNumeric); max(carprices$MileageNumeric)
min(carprices$Price); max(carprices$Price)
# Yep (as you already know) the dataset needs some pre-processing ...
# we'll come back to this one with Data Transformation.


# 
# facets - same plot for different subsets of the data
#
# single variable (the "formula" in R-speak)
# start with the original ...
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
# and add facet
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class)

# Iris dataset
ggplot(data = tiris) +
  geom_point(mapping = aes(x = Sepal.Length, y = Petal.Length)) +
  facet_wrap(~ Species)
# add color
ggplot(data = tiris) +
  geom_point(mapping = aes(x = Sepal.Length, y = Petal.Length, color = Sepal.Width)) +
  facet_wrap(~ Species)

# 
# The Auburn real estate dataset
#
ggplot(data = aure) + 
  geom_point(mapping = aes(x = SqFt, y = Price)) +
  facet_wrap(~ Bedrooms)

# facets should be discrete

# two variables (grid rather than wrap)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = aure) + 
  geom_point(mapping = aes(x = SqFt, y = Price)) +
  facet_grid(BathsFull ~ Bedrooms)


#
# Geoms -- Geometric objects beyond "points"
#
# compare the smooth geom with the point geom earlier -- note
# that the aesthetic (aes()) is the same.
# start with the original ...
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
# and change to the new aes
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# So, what is this geom_smooth thing?
?geom_smooth

# Other geoms ...Try ?geom and look at the context menu
# or check the cheatsheet - https://rstudio.com/resources/cheatsheets/

# Add the scatter plot as an overlay
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# note that this is a fundamental ggplot2 concept - define
# the plot first and then sequentially add layers.


# here's where it's convenient to define part
# of the mapping in the initial ggplot function call so
# that you don't have to replicate it with each geom.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth() +
  geom_point(mapping = aes(color = class))


# let's try a generalized linear model (glm)
# Note that the method parameter is outside of the aes -- it's part of
# the geom, not the aesthetic.
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy), method="glm")

# with the scatter overlay
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(method = "glm") +
  geom_point(mapping = aes(color = class))

# the iris dataset divided by species
ggplot(data = tiris, mapping = aes(x = Sepal.Length, y = Petal.Length, color=Species))+
  geom_point() +
  geom_smooth(method=glm)
# note that the color component is in the global data
# definition rather than the point layer - so it applies to both geoms

# If we switch to the point geom, we get a single geom_smooth object with colored points
ggplot(data = tiris, mapping = aes(x = Sepal.Length, y = Petal.Length))+
  geom_point( mapping=aes(color=Species)) +
  geom_smooth(method=glm)

# and if we switch it to the smooth geom, we get non-colored points
ggplot(data = tiris, mapping = aes(x = Sepal.Length, y = Petal.Length))+
  geom_point() +
  geom_smooth(mapping=aes(color=Species), method=glm)

# back to mpg
# divide by drv and use different line types.
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# divide by class and use different line types
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = class))

# What about some filtering -- and turn off the confidence estimates.
# Note that with the filtering, we are treating the tibble just
# like we would a data.frame.
ggplot(data = mpg[mpg$class %in% c('compact', 'subcompact'),]) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = class), se=FALSE)

# back to drv type with colors
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

# now add a dot plot as an overlay
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth() +
  geom_point()

# linear fit by drv, no confidence estimates
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(method="glm", se=FALSE) +
  geom_point()

# Only front-wheel drive
ggplot(data = mpg[mpg$drv == 'f',], 
       mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(method="glm", se=FALSE) +
  geom_point()

# or of your prefer the dplyr approach (which we'll see next week)
ggplot(data = filter(mpg, drv == 'f'), 
       mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(method="glm", se=FALSE) +
  geom_point()


# ---------------------------------
#
# Statistical transformations - for the previous plots, we
# were plotting the data "as is" with different aesthetics.
# Now let's look and some aggregation/transformations.
#
# ---------------------------------

# Count by bedrooms for Auburn 
ggplot(data = aure) + 
  geom_bar(mapping = aes(x = Bedrooms))

# we'll see more of this dataset later

# Next, a new data set ...
diamonds

# if we want to have the dataset in the environment -->
fix(diamonds)

# histogram by diamond cut
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
# Looking in the two datasets, there is no "count" field -- statistical transformation
#
# Check the Powerpoint for the Stats slide.
#

# if you prefer proportions ... DEPRECATED VERSION
#ggplot(data = diamonds) + 
#  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

# if you prefer proportions ...
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

#Help!
?geom_bar

# More details
vignette("ggplot2-specs")


# Add some stats - stat_summary() summarizes the y values
# for each unique x value
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

?stat_summary

# let's add some color
# outline
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

# fill - using the same variable.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# fill on a different variable
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# different layout, same information
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

#
# Histograms -----
#
# House prices in Auburn (from 2017)
ggplot(data = aure) +
  geom_histogram(mapping = aes(x = Price))
# change the binwidth
ggplot(data = aure) +
  geom_histogram(mapping = aes(x = Price), binwidth = 50000)

# Diamond prices
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price))

# Some additional examples in online_shoppers.R


#
# Coordinate Systems
#
# boxplots
# vertical
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = tiris, mapping = aes(x = Species, y = Petal.Length)) + 
  geom_boxplot()
  
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_boxplot()

# horizontal
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

ggplot(data = aure, mapping = aes(y = Price)) + 
  geom_boxplot() +
  coord_flip()


# Colorful boxplot ...
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_boxplot(color="blue", fill="orange") +
  coord_flip()


# Store the plot and apply coord modifications
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


#
# Using latitude and longitude on a map.  You'll need
# the maps package here -- install.packages("maps") if 
# you don't already have it.
# 
usa <- map_data("usa")

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#
# Add something interesting to the map - Schools where 
# I've gone and/or worked.
#
schools <- tibble(
  school   = c( 'Auburn', 'Penn State',    'TAMU',  'GaTech', 'NC State'),
  lat      = c(32.609077,    40.790703, 30.622374,  33.74831, 35.7847),
  long     = c( -85.8173,   -77.858795, -96.32585, -84.39111, -78.6821),
  students = c(    30460,        46810,     72982,     36302, 34015),
  group = 1
  )

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap() +
  geom_point(data = schools, aes(x = long, y = lat, color=school, size = students))

