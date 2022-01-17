# name: hansen.R
# author: scott cunningham (baylor)
# description: recreates (but doesn't replicate) several tables and figures from Hansen
#              2015 article in the AER on DWI and deterrence using RDD.  
# last updated: january 16, 2022

install.packages("readstata13")

library(tidyverse)
library(haven)
library(estimatr)
library(readstata13)
library(ggplot2)

## Load Hansen's dataset into memory
hansen <- data.frame(read.dta13('https://github.com/scunning1975/mixtape/raw/master/hansen_dwi.dta'))

