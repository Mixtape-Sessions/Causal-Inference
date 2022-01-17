#######################################################################################
# name: hansen.R
# author: scott cunningham (baylor)
# description: recreates (but doesn't replicate) several tables and figures from Hansen
#              2015 article in the AER on DWI and deterrence using RDD.  
# last updated: january 16, 2022
#######################################################################################

#install.packages("readstata13")
#install.packages("httpgd") 
#install.packages("languageserver")
#install.packages("fixest")

library(tidyverse)
library(haven)
library(estimatr)
library(ggplot2)
library(fixest) # fixest is the go to for estimation in R

## Load Hansen's dataset into memory
hansen <- read_dta("https://github.com/scunning1975/mixtape/raw/master/hansen_dwi.dta")
setwd('/users/scott_cunningham/Documents/Causal-Inference/Automation')
getwd()

# List the variables
str(hansen)

## Question 1
# 1a. Generate a dummy variable.  bac1>=0.08
hansen$dwi <- hansen$bac1>=0.08
hansen$dwi[is.na(hansen$dwi)] <- 0

# 1b first stab. Histogram of bac1 with bins of 100 -- looks good
hist(hansen$bac1, col='skyblue3', breaks=100)
abline(col= "red", v=0.08)

# 1b second stab. Histogram of bac1 with bins of 150 -- still looks good
hist(hansen$bac1, col='skyblue3', breaks=150)
abline(col= "black", v=0.08)

# 1c second stab. Histogram of bac1 with bins of 200 -- shows the weird heaping patterns
hist(hansen$bac1, col='skyblue3', breaks=200)
abline(col= "orange", v=0.08)

## Question 2.  Recreate Table 2 Panel A for white, male, aged and acc
# Equation (1): yi = Xi′γ + α1DUIi + α2BACi + α3BACi × DUIi + ui

hansen_subset <- hansen %>% 
  filter(bac1>0.03 & bac1<0.13)

(white <- feols(white ~ bac1*dwi, data=hansen_subset, vcov="HC1"))

(male <- feols(male ~ bac1*dwi, data=hansen_subset, vcov="HC1"))

(aged <- feols(aged ~ bac1*dwi, data=hansen_subset, vcov="HC1"))

(acc <- feols(acc ~ bac1*dwi, data=hansen_subset, vcov="HC1"))

# Regression Table (LaTeX File)

fixest::etable(white, male, aged, acc,
			   title = "Regression Discontinuity Estimates for the Effect of Exceeding BAC Thresholds on Predetermined Characteristics", 
			   tex = T, 
			   file = "hansen_predetermined_covariates.tex")


