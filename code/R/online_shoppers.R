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

# Records from Operating System 4 (including a subset of columns)
os4 <- data[data$OperatingSystems == 4,c("Index", "BounceRates", "ExitRates","Weekend","Revenue")]

# Use Tidyverse for some visualization
library(tidyverse)

# Let's convert some of the integer columns to factors so that
# we can use them for the aesthetics
data[,'OperatingSystems'] = factor(data[,'OperatingSystems'])
data[,'VisitorType'] = factor(data[,'VisitorType'])
data[,'Browser'] = factor(data[,'Browser'])
data[,'Region'] = factor(data[,'Region'])
# How do we know that these should be factors?

# Create a tibble from the data frame
tdata <- as_tibble(data)

# 
# From the pptx - EDA section
# People from Region 2 have a higher transaction rate than regions 1, 3, and 4?
#
# Create a Boolean from the string value so that we can sum
tdata$RevenueBoolean <- as.logical(tdata$Revenue)
# Summarize
(RevByRegion <- tdata %>%
    group_by(Region) %>%
    summarise (
      count = n(),
      total_rev = sum(RevenueBoolean, na.rm = TRUE)
    ) %>%
    mutate (
      rev_rate = total_rev / count
    ) %>%
    filter(
      Region %in% c(1, 2, 3, 4)
    ) %>%
    arrange(desc(rev_rate)
    )
  )

# Returning visitors generate more revenue than new visitors do
(RevByVType <- tdata %>%
    group_by(VisitorType) %>%
    summarise (
      count = n(),
      total_rev = sum(RevenueBoolean, na.rm = TRUE)
    ) %>%
    mutate (
      rev_rate = total_rev / count
    ) %>%
    arrange(desc(rev_rate)
    )
)

# Revenue is proportional to time spend investigating products 
# Have a look at the duration
unique(data$ProductRelated_Duration)
# Would probably want to cluster these into fewer buckets and then
# aggregate and summarize across the buckets.  Something to think about ...

# 
#
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
  geom_point(mapping = aes(x = Browser, y = ProductRelated_Duration, color=Region))

# Boxplot
ggplot(data = tdata, mapping = aes(x = Browser, y = ProductRelated_Duration)) + 
  geom_boxplot()

# looks like we need to remove the zero values
ggplot(data = filter(tdata,ProductRelated_Duration >0), mapping = aes(x = Browser, y = ProductRelated_Duration)) + 
  geom_boxplot()

# try an upper bound also ... try 20,000; 10,000
ggplot(data = filter(tdata, ProductRelated_Duration > 0 & ProductRelated_Duration < 20000), mapping = aes(x = Browser, y = ProductRelated_Duration)) + 
  geom_boxplot()

ggplot(data = filter(tdata, ProductRelated_Duration > 0 & ProductRelated_Duration < 20000), mapping = aes(x = Browser, y = ProductRelated_Duration)) + 
  geom_boxplot() +
  coord_flip()




