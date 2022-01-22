import pandas as pd
import statsmodels.api as sm
from stargazer.stargazer import Stargazer
​
# Load data
card = pd.read_stata('https://raw.github.com/scunning1975/mixtape/master/card.dta')
​
# Models
no_cov = sm.OLS.from_formula('lwage ~ + educ', data = card).fit(cov_type = "HC3")
cov = sm.OLS.from_formula('lwage ~ educ + exper + black + south + married + smsa', data = card).fit(cov_type = "HC3")
​
# Create LaTeX table
stargazer = Stargazer([no_cov, cov])  
stargazer.title('OLS estimates of effect of college on log wages')
stargazer.custom_columns(['No covariates', 'Covariates'], [1, 1])
stargazer.add_custom_notes(["Data is from NLS.  Heteroskedastic standard errors shown in parenthesis."])
stargazer.dependent_variable_name('Dependent variable: log(wage)')
# Export table as .tex file
with open('estout/education.tex', 'w') as f:
    f.write(stargazer.render_latex())
