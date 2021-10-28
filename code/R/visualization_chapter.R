#
# Ch 3 - Visualization
# R for Data Science - http://r4ds.had.co.nz/
#

library(tidyverse)

# if you don't have it installed, use:
# install.packages("tidyverse")
# and retry the library() function.

# 
# Grab a couple of datasets
#

# MPG Dataset ----
# use ? to get help.  Consider a dataset (e.g., mpg), ?mpg gives
# a help page.  Note that this dataset is part of ggplot2
?mpg

mpg # to show the first 10 rows + information
# What is a tibble?  Type 'tibble' in the consoleand the look for the context menu
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

# What if we flip the x and size?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = hwy, size = displ))
# Is this a "good" plot?  What does "good" mean in this sense?

# use size and color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class, color=class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = hwy, size = displ, color=displ))

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
# Is there a relationship between Petal Width and Petal Length? Does 
# the relationship depend on species?
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
# facets - same plot for different subsets of the data
#
# single variable (the "formula" in R-speak)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class)

ggplot(data = tiris) +
  geom_point(mapping = aes(x = Sepal.Length, y = Petal.Length)) +
  facet_wrap(~ Species)
# facets should be discrete

# two variables (grid rather than wrap)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

#
# Geoms -- Geometric objects
#
# compare the smooth geom with the point geom earlier -- note
# that the aesthetic (aes()) is the same.
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
# note that the color component rather than the point layer.  If we switch
# it, we get a single geom_smooth object
ggplot(data = tiris, mapping = aes(x = Sepal.Length, y = Petal.Length))+
  geom_point( mapping=aes(color=Species)) +
  geom_smooth(method=glm)

# divide by drv and use different line types.
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# divide by class and use different line types
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = class))

# What about some filtering -- and turn off the confidence estimates
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

# or of your prefer the dplyr approach
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

# First, a new data set ...
diamonds

# if we want to have the dataset in the environment -->
fix(diamonds)

# histogram by diamond cut
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
# Looking in the dataset, there is no "count" field -- statistical transformation
# Check the Powerpoint for the Stats slide.


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
# Uinsg latitude and longitude on a map.
# 
usa <- map_data("usa")

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#
# add something interesting to the map
#
schools <- tibble(
  school   = c( 'Auburn', 'Penn State',    'TAMU',  'GaTech'),
  lat      = c(32.609077,    40.790703, 30.622374,  33.74831),
  long     = c( -85.8173,   -77.858795, -96.32585, -84.39111),
  students = c(    30460,        46810,     72982,     36302),
  group = 1
  )

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap() +
  geom_point(data = schools, aes(x = long, y = lat, color=school, size = students))

