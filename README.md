<img src="img/banner.png" alt="Mixtape Sessions Banner" width="100%"> 
<br/>

<img src="img/readme_about.png" alt="Mixtape Sessions Banner" width="100%">
<br/>

This workshop will cover foundational elements of modern practices of causal inference such as the potential outcomes model as well as discuss in detail the most common designs: regression discontinuity, instrumental variables, difference in differences, comparative case studies using synthetic control and if time permitting matching. It will be accompanied by efforts to introduce students to basic practices in programming as well as good research practices more generally. 
<br/>

<div align="center">
<a href='https://github.com/Mixtape-Sessions/Causal-Inference/'>
<img src="img/readme_slides.png" alt="Slides" width="20%">
</a>
&nbsp;
<a href='https://github.com/Mixtape-Sessions/Causal-Inference/'>
<img src="img/readme_code.png" alt="Code" width="20%">
</a>
&nbsp;
<a href='https://github.com/Mixtape-Sessions/Causal-Inference/'>
<img src="img/readme_reading.png" alt="Readings" width="20%">
</a>
</div>



<br/><br/>
<img src="img/readme_schedule.png" alt="Mixtape Sessions Banner" width="100%"> 
<br/>

<details><summary><b>Hidden Curriculum</b></summary><br/>

<b>About</b>
           
While causal inference is a design and model based approach to estimating causal effects, it ultimately uses large data sources, computers and programming languages to do that estimation.  Thus while you can teach causal inference as separate from empirical workflow, you shouldn't. Here I discuss my own personal beliefs about empirical workflow, going through such things as missingness in data, hierarchy of directories, version control and more.  We will discuss these things.

<b>Slides</b>
           
<a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Slides/00-Hidden_curriculum.pdf">Hidden curriculum slides</a>


</details><br />



<details><summary><b>Potential Outcomes</b></summary><br/>

<b>About</b>
           
The modern theory of causality is based on a seemingly simple idea called the "counterfactual".  The counterfactual is an unusual features of the arsenal of modern statistics because it is more or less storytelling about alternative worlds that may or may not exist, but could have existed had one single decision gone a different way.  Out of this idea grew what a model, complete with its own language, on top of which the field of causal inference is based, and the purpose of this lecture is to learn that language.  The language is called potential outcomes and it forms the basis for many causal objects we tend to be interested in, such as the average treatment effect. I also cover randomization, selection bias and randomization inference.


<b>Slides</b>
           
<a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Slides/01-Foundations.pdf">Foundations of causality</a>

<b>Code</b>
           
* Stata: <a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Code/ri.do">ri.do</a>, <a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Code/ri.do">tea.do</a>, <a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Code/thornton_ri.do">thornton_ri.do</a>
* R: <a href="https://colab.research.google.com/github/scunning1975/mixtape_learnr/blob/main/R_ipynb/Potential_Outcomes.ipynb">Potential outcomes</a>
* python: <a href="https://colab.research.google.com/github/causalinfpython/mixtape/blob/main/Potential_Outcomes.ipynb">Potential outcomes</a>

<b>Readings</b>

Mixtape chapter 4 <a href="https://mixtape.scunning.com/potential-outcomes.html">Potential Outcomes Causal Model</a>
Software: <a href="http://www.dagitty.net">Daggity</a>

</details><br />

<details><summary><b>Directed Acyclic Graphs</b></summary><br/>

<b>About</b>
           
Model-based approaches to identification can be sometimes better seen using causal graphs called directed acyclic graphs (DAGs).  These modeling approaches are compatible with the design-based approach, but tend to emphasize a priori domain knowledge as opposed to treatment manipulation exclusively.  Here we discuss the backdoor criterion, the frontdoor criterion, and collider bias.

<b>Slides</b>
           
<a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Slides/01-Foundations.pdf">Foundations of causality</a>

<b>Code</b>
           
* Stata: <a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Code/moviestar.do">moviestar.do</a>, <a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Code/collider_discrimination.do">collider_discrimination.do</a>
* R: <a href="https://colab.research.google.com/github/scunning1975/mixtape_learnr/blob/main/R_ipynb/Directed_Acyclical_Graphs.ipynb">DAGs</a>
* python: <a href="https://colab.research.google.com/github/causalinfpython/mixtape/blob/main/Directed%20Acyclic%20Graphs.ipynb">DAGs</a>


<b>Readings</b>
           
Mixtape chapter 3 <a href="https://mixtape.scunning.com/dag.html">Directed Acyclic Graphs</a>


</details><br />

<details><summary><b>Sharp Regression Discontinuity</b></summary><br/>

<b>About</b>
One of the most desired quasi-experimental designs -- desired because it is viewed as highly credible despite being based on observational data -- is the regression discontinuity design.  Here I will discuss the sharp RDD in great detail, going through identification, estimation, specification tests and tips, as well as a replication.



<b>Slides</b>
<a href="https://github.com/Mixtape-Sessions/Causal-Inference/blob/main/Slides/02-RDD.pdf">RDD slides</a>


<b>Code</b>
* Stata: lmb.do files (several numbered), rdd_simulate.do (several numbered)
* R: <a href="https://colab.research.google.com/github/scunning1975/mixtape_learnr/blob/main/R_ipynb/Regression_Discontinuity.ipynb">RDD</a>
* python: <a href="https://colab.research.google.com/github/causalinfpython/mixtape/blob/main/Regression_Discontinuity.ipynb">RDD</a>


<b>Readings</b>
Mixtape chapter 6: <a href="https://mixtape.scunning.com/regression-discontinuity.html">Regression discontinuity</a>


</details><br />

<details><summary><b>Instrumental Variables</b></summary><br/>

<b>About</b>
... 

<b>Slides</b>
...

<b>Code</b>
...

<b>Readings</b>
...



</details><br />

<details><summary><b>Difference-in-Differences</b></summary><br/>

<b>About</b>
... 

<b>Slides</b>
...

<b>Code</b>
...

<b>Readings</b>
...



</details><br />

<details><summary><b>Synthetic Control</b></summary><br/>

<b>About</b>
... 

<b>Slides</b>
...

<b>Code</b>
...

<b>Readings</b>
...



</details><br />

<details><summary><b>Matching</b></summary><br/>

<b>About</b>
... 

<b>Slides</b>
...

<b>Code</b>
...

<b>Readings</b>
...



</details><br />


           

