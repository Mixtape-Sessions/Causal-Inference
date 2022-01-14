******************************************************************************************
* name: hansen.do
* author: scott cunningham (baylor)
* description: replicate figures and tables in Hansen 2015 AER
* last updated: december 5, 2021
******************************************************************************************

capture log close
clear
cd "/Users/scott_cunningham/Dropbox/CI Workshop/Assignments/Hansen"
capture log using ./hansen.log, replace

* load the data from github
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear

* Q1: create some variables
gen 	dui = 0
replace dui = 1 if bac1>=0.08 & bac1~=. // you got to put the ampersand bac1 not missing because
* Stata thinks that if a missing value (.) exists for a variable (bac1) that it actually is LARGER
* than whatever threshold you specified (0.08). 

* Quadratic bac1
gen bac1_sq = bac1^2

* Find evidence for manipulation or HEAPING

* Once, make it as a discrete variable (bac1), once as continuous (bac1).
histogram bac1, discrete width(0.001) ytitle(Frequency) xtitle(Blood Alcohol Content) xline(0.08) title(Replicating Figure 1 of Hansen AER 2015) subtitle(Density of stops for DUI across BAC) note(Discrete histogram)

* Second, make it as a continuous variable -- looks like there is heaping that is visible
histogram bac1, width(0.001) ytitle(Frequency) xtitle(Blood Alcohol Content) xline(0.08) title(Replicating Figure 1 of Hansen AER 2015) subtitle(Density of stops for DUI across BAC) note(Continuous histogram)

* Third, use rddensity from Cattnaeo, Titunik and Farrell papers
* Syntax: rddensity running_variable, c(cutoff) plot
rddensity bac1, c(0.08) plot

* Q2: Running regressions on covariates (white, male, age and accident) to see if there is a 
* jump in average values for each of these  at the cutoff.

* yi = Xi′γ + α1DUIi + α2BACi + α3BACi × DUIi + ui


reg white dui##c.bac1 if bac1>=0.03 & bac1<=0.13, robust //not going to cluster on the running
* variable because of Kolesar and Rothe (2018) AER that says clustering on the running variable
* has an extremely over-rejection problem. Technically they recommend honest confidence intervals
* but that's in R and I'm not going to do it.
reg male dui##c.bac1 if bac1>=0.03 & bac1<=0.13, robust //not going to cluster on the running
reg acc dui##c.bac1 if bac1>=0.03 & bac1<=0.13, robust //not going to cluster on the running
reg aged dui##c.(bac1 bac if bac1>=0.03 & bac1<=0.13, robust //not going to cluster on the running


* Q4: Our main results. regression of recidivism onto the equation (1) model. 
reg recidivism white male aged acc dui##c.bac1 if bac1>=0.03 & bac1<=0.13, robust
reg recidivism white male aged acc dui##c.(bac1 bac1_sq) if bac1>=0.03 & bac1<=0.13, robust

* Slightly smaller bandwidth of 0.055 to 0.105
reg recidivism white male aged acc dui##c.bac1 if bac1>=0.055 & bac1<=0.105, robust
reg recidivism white male aged acc dui##c.(bac1 bac1_sq) if bac1>=0.055 & bac1<=0.105, robust



cmogram recidivism bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) 
cmogram recidivism bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) lfitci
cmogram recidivism bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) qfitci
cmogram recidivism bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) lowess

* REMEMBER THOUGH: HEAPING. Replicate Q4 myself by running "donut hole regressions". How do I run a
* donut hole regression? I simply drop the units at the cutoff. 

gen 	donut = 0
replace donut = 1 if bac1>=0.079 & bac1<=0.081

reg recidivism white male aged acc dui##c.bac1 if bac1>=0.03 & bac1<=0.13 & donut==0, robust


* Local polynomial regressions with triangular kernel and bias correction
rdrobust recidivism bac1, kernel(epanechnikov) masspoints(off) p(2) c(0.08)
rdrobust recidivism bac1 if donut==0, kernel(uniform) masspoints(off) p(2) c(0.08)

* Donut nonparameteric presentation
cmogram recidivism bac1 if bac1>0.055 & bac1<0.105 & donut==0, cut(0.08) scatter line(0.08) lfitci

* rdplot
rdplot recidivism bac1 if bac1>=0.03 & bac1<=0.13, p(4) masspoints(off) c(0.08) graph_options(title(RD Plot Recidivism and BAC))



