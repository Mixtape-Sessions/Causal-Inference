** David Card wants to estimate the returns to schooling on wages
* But he knows that schooling is endogenous to omitted variables that cause wages
* He proposes an ingenious instrument for schooling: whether the respondent in a 
* survey lives in the same county as a 4-year college. (Estimating the returns
* to college attendance). His idea is if you live in the same county as there is a 4-year college, then
* it makes you more likely to go to college because college is therefore cheaper
* (you can live with your family). 

* Let's review the estimation and the output. 

* Estimates using IVREGRESS (2sls estimator)
use https://github.com/scunning1975/mixtape/raw/master/card.dta, clear
reg lwage  educ  exper black south married smsa, robust
ivregress 2sls lwage (educ=nearc4) exper black south married smsa, first robust
* Returns to schooling are estimated at around 12% (0.1241642 with SE of 0.0491577)

reg educ nearc4 exper black south married smsa, robust
test nearc4




* Estimate 2SLS manually rather than using ivregress. Notice the differences:

* 1. estimate our first stage regression
reg educ nearc4 exper black south married smsa, robust
predict educ_hat

* Education has 3,010 observations; predicted education has 3,003
* Standard deviation for education is 2.677. Standard deviation for predicted
* education is 1.85.  Less variation because we are only using the variation
* from our instruments. This shrinks the variation in the explanatory variable, 
* but leaves us with only exogenous variation. So the variation that is left
* is exogenous, but there is less variation over all, which will affect our
* standard errors.

* 2. estimate our second stage regression manually
reg lwage  educ_hat  exper black south married smsa, robust

* Coefficient on predicted education is 0.1241645.
* Standard error is 0.0493207

* The problem with the standard errors is these standard errors
* do not take into account that schooling was estimated using the data. So it
* doesn't have the right degrees of freedom because it's naive with respect
* to the schooling variable, whereas -ivregress- knows to make this adjustment. 
* But otherwise you can see they are nearly identical. 

* The lesson is always estimate your 2SLS models using packages, not 
* manually, even though manually can be very helpful. 



