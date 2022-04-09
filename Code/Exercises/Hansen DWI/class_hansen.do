******************************************************************************************
* name: hansen.do
* author: scott cunningham (baylor)
* description: replicate figures and tables in Hansen 2015 AER
* last updated: april 4, 2022
******************************************************************************************

capture log close
clear
cd "/Users/scott_cunningham/Dropbox/CI Workshop/Assignments/Hansen"
capture log using ./hansen.log, replace

* ssc install gtools
* net install binscatter2, from("https://raw.githubusercontent.com/mdroste/stata-binscatter2/master/")
* ssc install cmogram
* lpdensity, from(https://raw.githubusercontent.com/nppackages/lpdensity/master/stata) replace
* Load the raw data into memory
* net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
* ssc install rdrobust, replace
* net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
* net install lpdensity, from(https://sites.google.com/site/nppackages/lpdensity/stata) replace

* load the data from github
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear

/* 1.	We will only focus on the 0.08 BAC cutoff; not the 0.15 cutoff.  Take the following steps.
a.	Create a treatment variable (dui) equaling 1 if bac1>= 0.08 and 0 otherwise in your do file or R file.  
b.	Replicate Hansen's figure 1 examining whether there is any evidence for manipulation on the running variable. Produce a raw histogram using bac1, then use the density test in Cattaneo, Titunik and Farrell's rddensity package. Can you find any evidence for manipulation?  What about heaping?

*/

* Q1a: create our treatment variable (if you have bac>=0.08, you are arrested and charged with a dui)
gen 	dui = 0
replace dui = 1 if bac1 >=0.08 & bac1~=. // you always have to in stata say "& bac1~=." because stata thinks any missing value is greater than some value (>=0.08). It's because in the architecture of Stata, missing values for some reason has a value of positive infinity.

* Q1b: historgram, rddensity. What is this "manipulation" business?
histogram bac1, discrete width(0.001) frequency ytitle(Frequency) xtitle(Blood Alcohol Content) xline(0.08, lwidth(medium) lpattern(solid) lcolor(red) extend) title(BAC histogram) // bandwidth of 0.001 just like Hansen, but no justification for that width.

* rddensity is a package in both R and Stata (not python yet) that estimates "optimal bandwidths" which are the width of each bin.  Within each bin is thousands of observations. So rather than use an arbitrary bandwidth of 0.001, rddensity will choose "optimal" data-driven bandwidths to do this illustration. What is optimal? That's coming. Hint: optimal is the solution to a constrained optimization problem that depends on the size of your sample. 

* First recenter our data by subtracting 0.08 from our running variable ("reentering the running variable")
gen bac1_c = bac1-0.08

rddensity bac1_c, c(0.0) plot  // "optimal" bandwidths based on some constrained optimization that we haven't learned yet, and it ended up being 0.023 (much larger than Hansen's).  When we look at the optimal bandwidths, there is signs of "heaping" -- large masses of people with certain regularly spaced scores. Probably, that isn't a naturally occuring thing. 

/* 2.	Recreate Table 2 Panel A but only white, male, age and accident (acc) as dependent variables.  Use your equation 1) for this. Are the covariates balanced at the cutoff? Use two separate bandwidths (0.03 to 0.13; 0.055 to 0.105) for estimation.

(1) yi = Xi′γ + α1DUIi + α2BACi + α3BACi × DUIi + ui

*/

* Table 2: balance on predetermined covariates (Elle)
reg male dui##c.bac1_c, robust
reg white dui##c.bac1_c, robust
reg aged dui##c.bac1_c, robust
reg acc dui##c.bac1_c, robust

/* 3.	Recreate Figure 2 panel A-D. Fit a picture using linear and separately quadratic with confidence intervals. I'm going to use cmogram
*/

cmogram white bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) lfitci // plot binned means of white drivers across the blood alcohol content score they blew drawing p=1 polynomial regression lines to the left which are different from the right, using the cutoff of bac 0.08 and a vertical line. 


cmogram male bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) lfitci // plot binned means of white drivers across the blood alcohol content score they blew drawing p=1 polynomial regression lines to the left which are different from the right, using the cutoff of bac 0.08 and a vertical line. 


cmogram aged bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) lfitci // plot binned means of white drivers across the blood alcohol content score they blew drawing p=1 polynomial regression lines to the left which are different from the right, using the cutoff of bac 0.08 and a vertical line. 


cmogram acc bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) lfitci // plot binned means of white drivers across the blood alcohol content score they blew drawing p=1 polynomial regression lines to the left which are different from the right, using the cutoff of bac 0.08 and a vertical line. 

gen bac1_sq = bac1^2
gen bac1_c_sq = bac1_c^2

cmogram aged bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) qfitci // plot binned means of white drivers across the blood alcohol content score they blew drawing p=1 polynomial regression lines to the left which are different from the right, using the cutoff of bac 0.08 and a vertical line. 

* Rerun the tables with quadratics for aged to doublecheck
reg aged dui##c.(bac1_c bac1_c_sq), robust

* Use binscatter to construct those same figures (Figure 2) but with "optimal bandwidths
binscatter aged bac1_c if bac1_c>=-0.05 & bac1_c<=0.05, by(dui) line(qfit)

* Use rdplot to construct those same figures (Figure 2) but with "optimal bandwidths
rdplot aged bac1_c if bac1_c>=-0.05 & bac1_c<=0.05, p(2) masspoints(off) c(0.0)

* Recidivism as linear and quadratic
cmogram recidivism bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) lfitci 
cmogram recidivism bac1 if bac1<=0.2, cut(0.08) scatter line(0.08) qfitci 

* Use binscatter to construct those same figures (Figure 2) but with "optimal bandwidths
binscatter recidivism bac1_c if bac1_c>=-0.05 & bac1_c<=0.05, by(dui) line(qfit)

* Local polynomial kernel estimation with optimal bandwidths.
rdrobust recidivism bac1_c, kernel(triangular) p(1) bwselect(mserd) scaleregul(0)
rdrobust recidivism bac1_c, kernel(triangular) p(1) bwselect(msetwo) scaleregul(0)
rdrobust recidivism bac1_c, kernel(triangular) p(1) bwselect(msetwo) scaleregul(0) all
