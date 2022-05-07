********************************************************************************
* name: thornton.do
* author: scott cunningham (baylor) and originally thornton (harvard)
* description: replicating select tables in Thornton (2008)
* last updated: january 5, 2022
********************************************************************************
clear
capture close
use https://github.com/scunning1975/mixtape/raw/master/thornton_hiv.dta, clear

* got -- Got test results
* any -- received any non-zero and positive incentive from the randomized voucher
* age -- Age
* age2 -- Age squared
* rumphi -- Rumphi fixed effect
* balaka -- Balaka fixed effect
* villnum -- Village identifer
* male -- Male dummy
* got_hiv -- got their HIV test results
* tinc -- value of the incentive (discrete)
gen t2 = tinc^2
* t2 -- total value of the incentive to the second power (quadratic specification)
gen dist2 = distvct^2
* distvct -- distance from voluntary counseling center
* dist2 -- distance squared

* ssc install estout, replace

*Footnotes to Table 4:
* Notes: Sample includes individuals who tested for HIV and have demographic data. Columns 1–5 represent OLS coefficients and columns 6–10 represent marginal probit coefficients (dprobit); robust standard errors clustered by village (for 119 villages) with district fixed effects in parentheses. All specifications also include a term for age-squared. "Any incentive'' is an indicator if the respondent received any nonzero monetary incentive. "HIV'' is an indicator of being HIV positive. "Simulated average distance" is an average distance of respondents' households to simulated randomized locations of HIV results centers. Distance is measured as a straight-line spherical distance from a respondent's home to a randomly assigned VCT center from geospatial coordinates and is measured in kilometers.

* Table 4  * Column 1 to 4 only using OLS

				cap n tempvar tempsample
				cap n local specname=`specname'+1

				* Column 1: Few controls
				reg got any got_hiv male age age2 rumphi balaka, cluster(villnum) robust
				cap n estimates store educ1
				cap n estadd ysumm


				* Column 2: Covariates // Unclear which linear control of incentive she used so I used the discrete one
				reg got any got_hiv tinc male age age2 rumphi balaka, cluster(villnum) robust
				cap n estimates store educ2
				cap n estadd ysumm

				
				* Column 3: Covariates // quadratic term differs from her Table 4. 
				reg got any got_hiv tinc t2 male age age2 rumphi balaka, cluster(villnum) robust
				cap n estimates store educ3
				cap n estadd ysumm

				
				* Column 4: Covariates // distance controls
				reg got any got_hiv tinc t2 distvct dist2 male age age2 rumphi balaka, cluster(villnum) robust
				cap n estimates store educ4
				cap n estadd ysumm
				

				
#delimit ;
	cap n estout * using ./thornton_table4.tex,
		style(tex) label notype
		cells((b(star fmt(%9.3f))) (se(fmt(%9.3f)par))) 		
		stats(N ymean,
			labels("N" "Mean of dependent variable")
			fmt(%9.0fc %9.2fc 2))
			keep(any got_hiv tinc t2 distvct dist2 male age age2 rumphi balaka) 
			replace noabbrev starlevels(* 0.10 ** 0.05 *** 0.01) 
			title(Impact of Monetary Incentives and Distance on Learning HIV Test Results)   
			collabels(none) eqlabels(none) mlabels(none) mgroups(none) substitute(_ \_)
			prehead("\begin{table}[htbp]\centering" "\small" "\caption{@title}" "\begin{center}" "\begin{threeparttable}" "\begin{tabular}{l*{@E}{c}}"
	"\toprule"
	"\multicolumn{1}{l}{\textbf{Depvar:  Attendance at HIV results centers}}&"
	"\multicolumn{1}{c}{\textbf{(1)}}&"
	"\multicolumn{1}{c}{\textbf{(2)}}&"
	"\multicolumn{1}{c}{\textbf{(3)}}&"
	"\multicolumn{1}{c}{\textbf{(4)}}\\")
		posthead("\midrule")
		prefoot("\midrule")  
		postfoot("\bottomrule" "\end{tabular}" "\begin{tablenotes}" "\tiny" "\item * Notes: Sample includes individuals who tested for HIV and have demographic data. Columns 1–4 represent OLS coefficients; robust standard errors clustered by village (for 119 villages) with district fixed effects in parentheses. All specifications also include a term for age-squared. `Any incentive' is an indicator if the respondent received any nonzero monetary incentive. `HIV' is an indicator of being HIV positive. Distance is measured as a straight-line spherical distance from a respondent's home to a randomly assigned VCT center from geospatial coordinates and is measured in kilometers.  * p$<$0.10, ** p$<$0.05, *** p$<$0.01" "\end{tablenotes}" "\end{threeparttable}" "\end{center}" "\end{table}");
#delimit cr
	cap n estimates clear




