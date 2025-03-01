#Setup ----
rm(list=ls())
library(RCPA3)
# this string is just a link to a web page that holds the data: 
loc <- url('https://github.com/Neilblund/GVPT-201-Site/raw/refs/heads/main/Rdata/pilot_fmted.rds')

# read RDS reads the data from the URL into R:
pilot<-readRDS(loc)


# TikTok ban -----
# how many respondents said they supported the effort to ban or force the sale of
# TikTok?
# To answer this, we can just use a basic frequency table:
freqC(Q8, data=pilot)
## Making an ordered factor----
# Q8 is already arranged from Strongly Opposed to Strongly Support, but its currently
# not being treated as an ordinal variable, which will mean functions like freqC
# will give us slighlty less informative output. 
# to fix this, we can use the ordered(x) function to create a new ordered version
# of this variable:

pilot$tiktok_ordered <- ordered(pilot$Q8)

freqC(tiktok_ordered, data=pilot)

# now describeC provides the median and modal value as well: 
describeC(tiktok_ordered, data=pilot)

## Adding a variable label ----
# We can assign a new label to this variable with Hmisc::label(x)
# print the current label: 
Hmisc::label(pilot$tiktok_ordered) 


# Assign a new label: 
Hmisc::label(pilot$tiktok_ordered)  <- "Support/Oppose banning or forcing the sale of TikTok"

# the main advantage is that it the label is automatically printed when we make
# tables like this:
freqC(tiktok_ordered, data=pilot)



# Social Media views ----
# How many people view social media use as having a negative effect on politics? 
# We'll also recode this to an  ordered factor
pilot$sm_views <- ordered(pilot$Q52)
Hmisc::label(pilot$sm_views) <-" View on social media's impact on American politics"


freqC(sm_views, data=pilot)



# TikTok ban and social media views ----
# Do people support the TikTok ban because of concerns about social media's
# impact on society? We'll make both variables dichotomous to simplify our
# analysis and avoid the problem of small frequencies:


## Recoding the variables as dichotomous ----
pilot$sm_negative <- factor(pilot$Q52, 
                            ordered =TRUE,
                            labels = c("Negative", "Negative", "Not negative","Not negative", "Not negative"))

pilot$tiktok_ban <- factor(pilot$Q8, 
                           ordered = TRUE,
                           labels = c("Opposed","Opposed", "Opposed","Not opposed", "Not opposed", "Not opposed", "Not opposed")
)

## After recoding, we can check our results to make sure everything lines up:
table(pilot$tiktok_ban)
table(pilot$Q8)

# OR try unique(dataframe[,c("oldvar", "newvar")]):
unique(pilot[,c("tiktok_ban", "Q8")])

## getting a crosstab ---
# Is there a relationship here? 
crosstabC(dv = tiktok_ban,   
          iv = sm_negative, 
          data=pilot, 
          compact =TRUE  # turns off printing the frequencies 
          
          )

# (remember to read across the values of the IV to calculate an effect)

## Adding a control ----
# Is there a relationship here? perhaps the reason for the observed relationship
# Maybe people who don't use social media are both more likely to think it is
# harmful and more likely to support banning it?

# We can use answer to Q50 to explore this. We'll collapse this to dichotomous
# as well:

pilot$daily_sm <- factor(pilot$Q50 == "Daily", 
                         ordered =TRUE,
                         labels = c("Less than every day", "Every day")
)


# 

crosstabC(dv = tiktok_ban, 
          iv = sm_negative, 
          z  = daily_sm,
          data=pilot,
          plot = FALSE,
          compact =TRUE
          
)



# Cutting a variable ----
# We can use transformC to cut a numeric variable into a smaller number of responses
# For instance, here's how we would change the 0-100 feeling thermometer score for 
# supporting expanding the Supreme Court and make it into a ordinal measure:

pilot$expand_scotus<-transformC(type='cut',               # use this option to cut a number into groups
                                data=pilot,             # the data set 
                                x=Q34_5,                # the variable we're cutting
                                cut = c(20,40,60,80),   # the cutoff points
                                confirm=F)              # this turns off a prompt that asks us to confirm before executing the command

# then we can add descriptive labels to each level of this new ordered variable:
levels(pilot$expand_scotus) <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")

# get the frequency distribution
freqC(pilot$expand_scotus)


# Making a dummy based on multiple responses ----
# what if I wanted to create a dummy to represent respondents who
# voted in 2024 and intended to vote in 2028? 

# I can use a set of logical statements separated by an ampersand:
# The code below returns TRUE if and only if Q14 AND Q18 both have values of "Yes":
pilot$vote24_28_dummy <- as.numeric(pilot$Q14 == "Yes" & pilot$Q18 == "Yes")

freqC(pilot$vote24_28_dummy)

# Another example: what if I wanted to get all of the respondents who were not
# white OR hispanic. I could use the logical | operator here, which means
# "return TRUE if either of these logical statements are true."

pilot$non_white_or_hispanic <- as.numeric(pilot$Q2 != "White or Caucasian" | pilot$Q3 =="Yes")

freqC(pilot$non_white_or_hispanic)



#Extra Code####################################################################
# You don't need this for this assignment! But it might be handy later on.
## Using a regular expression----
# What if I want to create a dummy variable that includes anyone who listed "Asian" 
# as their race/ethnic identity, including people who identify as multiracial? 
# One quick and easy way to do this grepl. grepl will search for a string of text
# and return TRUE for all values that match that string.

# So this command will return TRUE for any responses that include the text "Asian", including
# respondents who picked Asian and some other race: 
pilot$asian_dummy <- grepl("Asian", pilot$Q2)

# Take a look at the results and compare to the original responses on Q2:

table(pilot$Q2, pilot$asian_dummy)


