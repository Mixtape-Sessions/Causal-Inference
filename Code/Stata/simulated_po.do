
clear
capture log close
set seed 20200403

* 100,000 observations (each row is a person)
set obs 100000000
gen person=_n

gen y0 = rnormal()
gen y1 = 5 + rnormal()
gen te = y1 - y0

summarize


* Illustrate that E[Y1|D=1] = E[Y1|D=0] if randomized treatment

* First generate a random variable which is independent assignment to treatment
gen random = rnormal()

* Then assign people into the treatment based on that variable
gsort -random
gen 	treat=0
replace treat=1 if _n>1000000

* Now let's compare the Y0 values for the treated and the control

bysort treat: su y0 y1


