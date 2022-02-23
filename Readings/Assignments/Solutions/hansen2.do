********************************************************************************
* name: hansen2.do
* description: replicating a few figures and tables from Hansen (2015)
* author: scott cunningham (baylor)
* last updated: january 21, 2022
********************************************************************************
clear //deletes anything in memory
capture log, close // if the log is open, I'm closing it.  It's just way to ensure I'm starting over

* Use a prettier presentation style
set scheme cleanplots

use https://github.com/scunning1975/mixtape/raw/master/hansen_dwi.dta, clear

* QUESTION 1: generate some variables and make a figure
count
su bac1

gen 	dwi = 0
replace dwi = 1 if bac1>=0.08  // Stata always treats missing as equal 
sum dwi bac1

* Make Figure 1 which is a histogram
histogram bac1, bin(400) frequency ytitle(Counts) xtitle(Blood alcohol content) xline(0.08) title(Histogram of the distribution of counts by bac1) // we see some non-random heaping at some interval (0.01) but there's a big heap 0.079 (just below the threshold of a DWI).

histogram bac1, bin(450) frequency ytitle(Counts) xtitle(Blood alcohol content) xline(0.08) title(Histogram of the distribution of counts by bac1)

* QUESTION 2: Covariate balance.
* Equation 1: yi = Xi′γ + α1DUIi + α2BACi + α3BACi × DUIi + ui

reg male dwi##c.bac1 if bac1>=0.03 & bac1<=0.13, robust

reg white dwi##c.bac1 if bac1>=0.03 & bac1<=0.13, robust

reg aged dwi##c.bac1 if bac1>=0.03 & bac1<=0.13, robust

reg acc dwi##c.bac1 if bac1>=0.03 & bac1<=0.13, robust

* QUESTION 3: Make the figures
cmogram male bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) 
cmogram male bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) lfit
cmogram male bac1 if bac1>0.03 & bac1<0.13, cut(0.08) scatter line(0.08) qfit


rdrobust aged bac1 if bac2>0.03 & bac1<0.13, c(0.08) kernel(uniform) h(0.05)  
