library(fixest) # fixest is the go to for estimation in R
library(haven) # Read .dta

df <- read_dta("https://github.com/scunning1975/mixtape/raw/master/card.dta")

(no_cov <- feols(lwage ~ educ, data = df, vcov = "HC1"))
(cov <- feols(lwage ~ educ + exper + black + south + married + smsa, data = df, vcov = "HC1"))


# Regression Table
fixest::etable(no_cov, cov,
			   title = "OLS estimates of effect of college on log wages")

## Latex option
fixest::etable(no_cov, cov,
			   title = "OLS estimates of effect of college on log wages", tex = T)

## File
fixest::etable(no_cov, cov,
			   title = "OLS estimates of effect of college on log wages",
			   tex = T, file = "estout/education.tex"
)
