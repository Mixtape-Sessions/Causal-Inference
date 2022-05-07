library(readstata13)
library(ggplot2)
#install.packages("did")
#devtools::install_github("bcallaway11/did")
library(did) # Callaway & Sant'Anna

# First step: load the data in, call it castle.
castle <- data.frame(read.dta13('https://github.com/scunning1975/mixtape/raw/master/castle.dta'))

# Second step. The did package in R requires that the "never treated units" (we have 30)
# be given a zero for their treatment date. In the castle dataset, if you are not treated
# then you do not have a treatment date. Brant's did package REQUIRES never-treated be given a zero
# for their treatment date. effyear is the treatment date variable.
# This is just like in Stata: replace effyear=0 if effyear==.
castle$effyear[is.na(castle$effyear)] <- 0 # untreated units have effective year of 0

# Estimating the effect on log(homicide)
atts <- att_gt(yname = "l_homicide", # LHS variable
               tname = "year", # time variable
               idname = "sid", # id variable
               gname = "effyear", # first treatment period variable
               data = castle, # data
               xformla = NULL, # no covariates
               # xformla = ~ X_Iyear_2010, # with covariates
               est_method = "dr", # "dr" is doubly robust. "ipw" is inverse probability weighting. "reg" is regression
               control_group = "nevertreated", # set the comparison group which is either "nevertreated" or "notyettreated" 
               bstrap = TRUE, # if TRUE compute bootstrapped SE
               biters = 1000, # number of bootstrap iterations
               print_details = FALSE, # if TRUE, print detailed results
               clustervars = "sid", # cluster level
               panel = TRUE) # whether the data is panel or repeated cross-sectional

# Aggregate ATT
agg_effects <- aggte(atts, type = "group")
summary(agg_effects)

# Group-time ATTs
summary(atts)

# Plot group-time ATTs
ggdid(atts)

# Event-study
agg_effects_es <- aggte(atts, type = "dynamic")
summary(agg_effects_es)

# Plot event-study coefficients
ggdid(agg_effects_es)
