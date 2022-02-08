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
#if (!requireNamespace("remotes")) {
#  install.packages("remotes")
#}
#remotes::install_github("kolesarm/RDHonest", force=TRUE)
#install.packages("rdrobust")

library(readstata13)
library(tidyverse)
library(haven)
library(fixest) # fixest is the go to for estimation in R
library(RDHonest)
library(ggplot2)
library(rdrobust)

## Load Hansen's dataset into memory
hansen <- read_dta("https://github.com/scunning1975/mixtape/raw/master/hansen_dwi.dta")
setwd('/users/scott_cunningham/Documents/Causal-Inference/Automation')
getwd()

#create dummy
df<-
  df %>% 
  mutate(dui = if_else(bac1>=.08, 1, 0))

#make variables into grouped means
df<-
  df %>% 
  filter(bac1>=.03 & bac1<=.13) %>% 
  select(bac1, acc, male, aged, white, dui, recidivism) %>% 
  mutate(bac_bin = cut(bac1, breaks = seq(.03,.13, by=.001))) %>% 
  group_by(bac_bin) %>% 
  mutate(acc = mean(acc),
         male = mean(male),
         age = mean(aged),
         white = mean(white),
         recidivism = mean(recidivism))

#look at bac by recidivism
df %>% 
  ggplot(aes(x=bac_bin, y=recidivism)) +
  geom_point()