# don't worry about this. Just importing the data and doing some formatting
source('https://raw.githubusercontent.com/Neilblund/GVPT-201-Site/refs/heads/main/R%20code/gsheet_import.R')

responses<-readRDS("responses.rds") # reading in a saved copy of the results

# Stuff below here is more relevant -----
library(RCPA3) # importing the workbook R package

## View() ----
# View data using the View() function, or just click the data set in 
# the environment window
View(responses) # Will bring up the data viewer. 


## Accessing columns ----
# Use the $ notation to access a specific column from a data set. For instance,
# I could access the "age" column from the "responses" data set by running:
responses$age



## mean() ----
mean(responses$age) # This will calculate the average of a specific column


## help()----
# the help(x) will bring up the documentation for a function. Here's how I would
# bring up the help file for the mean function.
help(mean)


## mean() with optional arguments ----
# According to the documentation, mean() has an optional argument that I can use
# to ignore NA values when calculating the mean. The syntax is: mean(x, na.rm=TRUE)

mean(responses$age, na.rm=T)

## hist() and histC() ----
## These functions will generate histograms. hist() is the basic function:
hist(responses$age)

## histC() will also include a frequency table and some nicer formatting
histC(responses$age)


## table() ----
# table is a simple command for getting the frequencies of a categorical variable

table(responses$body_odor)

## freqC() ----
# This is a function from the RCPA3 package that generates descriptive stats for
# a categorical variable.
freqC(responses$body_odor)

# Unlike some other functions, this one takes an optional "data" argument, so you 
# can get the same results like this:
freqC(x=body_odor, data=responses)





