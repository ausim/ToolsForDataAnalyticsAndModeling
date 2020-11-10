#
# Online Shoppers Data set
#

# Get the current working directory
print(getwd())


# Read the online shoppers data
data <- read.csv("data\\16_online_shoppers_purchasing_intention.csv", stringsAsFactors=FALSE)
head(data,10)
# structure of the data
str(data)
summary(data)


# Records from Operating System 4
os4 <- data[data$OperatingSystems == 4,c("Index", "BounceRates", "ExitRates","Weekend","Revenue")]


# Use Tidyverse for some visualization
library(tidyverse)

# Let's convert some of the integer columns to factors
data[,'OperatingSystems'] = factor(data[,'OperatingSystems'])
data[,'VisitorType'] = factor(data[,'VisitorType'])
data[,'Browser'] = factor(data[,'Browser'])
data[,'Region'] = factor(data[,'Region'])


# Create a tibble from the data frame
tdata <- as_tibble(data)

# Operating Systems?
ggplot(data = tdata) + 
  geom_bar(mapping = aes(x = OperatingSystems, fill = OperatingSystems))

# Browser?
ggplot(data = tdata) + 
  geom_bar(mapping = aes(x = Browser, fill = Browser))

# Region?
ggplot(data = tdata) + 
  geom_bar(mapping = aes(x = Region, fill = Region))


# Visitor Type
ggplot(data = tdata) + 
  geom_bar(mapping = aes(x = VisitorType, fill=VisitorType))

# Time vs OS?
ggplot(data = tdata) + 
  geom_point(mapping = aes(x = OperatingSystems, y = ProductRelated_Duration, color=OperatingSystems))

# Time vs Browser?
ggplot(data = tdata) + 
  geom_point(mapping = aes(x = Browser, y = ProductRelated_Duration, color=Browser))

