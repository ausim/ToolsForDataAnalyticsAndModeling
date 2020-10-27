#
# Online Shoppers Dataset
#

# Get the current working directory
print(getwd())

# Read the econcomic data
data <- read.csv("data\\16_online_shoppers_purchasing_intention.csv", stringsAsFactors=FALSE)
head(data,10)
# structure of the data
str(data)
summary(data)
