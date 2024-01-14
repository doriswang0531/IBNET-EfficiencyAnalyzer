
************************************************************************ Regression *****************************************************************
use "wdidataset.dta",clear
ren countryname Country
replace Country="Federated States Of Micronesia"	if Country=="Micronesia, Fed. Sts."
replace Country ="Cape Verde" if Country=="Cabo Verde"
replace Country ="Egypt" if Country=="Egypt, Arab Rep."
replace Country ="Republic Of Kiribati" if Country=="Kiribati"
replace Country="Russia" if Country=="Russian Federation"
replace Country="Slovakia" if Country=="Slovak Republic"

ren countrycode CountryCode 
ren year Year
sort Country Year
save "wdi.dta",replace


use "monetary_equiv_loss-k.dta",clear
drop if Country=="Belarus"
dummies Country
dummies Year

sort Country Year

merge m:1 Country Year using "wdi.dta"
tab _merge
keep if _merge==3
drop _merge


** Filling some gaps in WDI data
tsset Ucode Year
gen int negyear = -Year
local i=1
 while `i' <=4 {
   
foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324  mf_s3 mf_s8 s1y vae pve gee rqe rle cce{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0

 bysort Ucode (negyear): carryforward `x' if `x'==., replace
bysort Ucode (Year): carryforward `x' if `x'==., replace

}
drop l1* l2* l3* ma3*
     local i = `i' + 1
 }
     
drop if mf_cf==.  //This will drop 578 observations 34 utilities
su mf_cf prov_type size s86 rqe rle item305 item309 item316 item317 item318 item319

sort Country Ucode Year
order Country1-Country69 Year1-Year14

save "IBNET_data4_lasso-k.dta",replace

** Data for world map in python. Use file number of 'utilities by country.jnpy' last updated on 19th Sept2022
use "IBNET_data4_lasso-k.dta",clear
keep Country Ucode Year mf_cf mf_pf1
gen nutilities=1
collapse (mean)mf_cf mf_pf1 nutilities, by(Country Ucode)
collapse (mean)mf_cf mf_pf1 (sum)nutilities, by(Country)
ren Country country

recode nutilities (1/5=1 "1: <5")(6/25=2 "2: 6-25")(26/50=3 "3: 26-50")(51/75=4 "4: 51-75")(76/100=5 "5: 76-100")(100/1000=6 "6: >100"), gen(Gr_utility)
sort Gr_utility
save "data4pythonmap.dta",replace
export delimited using "/Users/basabdasgupta/Documents/IBNET Complete Data/Data and Dofiles/data4pythonmap.csv", replace

***************************************************************** LASSO*****************************************************************************

 /*

The following steps are widely used to find the best predictor.

1. Divide the sample into training and validation subsamples.
2. Use the training data to estimate the model parameters of each of the competing estimators.
3. Use the validation data to estimate the out-of-sample mean squared error (MSE) of the predictions produced by each competing estimator.
4. The best predictor is the estimator that produces the smallest out-of-sample MSE.

The ordinary least-squares (OLS) estimator is frequently included as a benchmark estimator when it is feasible. We begin the process with splitting the sample and computing the OLS estimates.

In the output below, we read the data into memory and use splitsample with the option split(.75 .25) to generate the variable sample, which is 1 for a 75% of the sample and 2 for the remaining 25% of the sample. The assignment of each observation in sample to 1 or 2 is random, but the rseed option makes the random assignment reproducible.
*/
use "IBNET_data4_lasso-k.dta", clear
dummies region

 xtset Ucode Year
 
splitsample , generate(sample) split(.75 .25) cluster(Country) rseed(12345)

label define slabel 1 "Training" 2 "Validation"

label values sample slabel

tabulate sample

tabulate region if sample==1


 /*
The one-way tabulation of sample produced by tabulate verifies that sample contains the requested 75%–25% division.Next, we compute the OLS estimates using the data in the training sample. We did the OLS model because When 𝜆=0, the linear lasso reduces to the OLS estimator.
*/
* xtset Ucode Year
 
quietly reg mf_pf1 i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk if sample==1   //instead of Country we can use regions or incomegroup.

estimates store ols
lassogof ols, over(sample)

/*Result from the above code. We use lassogof with option over(70-30 split sample) to compute the in-sample (Training) and out-of-sample (Validation) estimates of the MSE. As we find, 
the estimated MSE is similar in the validation and training sample but Rsquare is higher in validation sample. So, it can be said that the training model is not overfit. Also, the out-of-sample estimate of the MSE is not less reliable estimator for the prediction error; see, for example, chapters 1, 2, and 3 in Hastie, Tibshirani, and Friedman (2009).

*/

/*
Selecting the lasso tuning parameters

The tuning parameters must be selected before using the lasso for prediction or model selection. The most frequent methods used to select the tuning parameters are cross-validation (CV), the adaptive lasso, and plug-in methods. In addition, 𝜆 is sometimes set by hand in a sensitivity analysis.

CV finds the 𝜆 that minimizes the out-of-sample MSE of the predictions. The mechanics of CV mimic the process using split samples to find the best out-of-sample predictor. The details are presented in an appendix.

CV is the default method of selecting the tuning parameters in the lasso command. In the output below, we use lasso to estimate the coefficients in the model for score, using the training sample. We specified the option rseed() to make our CV results reproducible.
*/



xtset Ucode Year
foreach x in cv adapt bic plugin{
lasso linear  mf_pf1 i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk if sample==1, nolog rseed(12345) selection(`x')
	estimate store `x'
}
/*
foreach x in cv adapt bic plugin{
lasso2  mf_pf1 i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk  if sample==1
	estimate store `x'
}
*/
lassogof cv adapt bic plugin if sample==2

lassogof  cv adapt bic plugin if sample==2, postselection

*



estimate restore cv
cvplot,minmax graphregion(fcolor(white)) plotregion(fcolor(white)) 
graph save "Graph" "cvplot_lasso24Aug22.gph", replace




/*Sensitivity analysis

Sensitivity analysis is sometimes performed to see if a small change in the tuning parameters leads to a large change in the prediction performance. When looking at the output of lassoknots produced by the CV-based lasso, we noted that for a small increase in the CV function produced by the penalized estimates, there could be a significant reduction in the number of selected covariates. 
*/
estimates restore cv
 lassoknots

estimates restore cv
lassoselect id =10

 estimates store cv1

lassogof cv cv1 adapt bic plugin if sample==2, postselection


xtset Ucode Year
rlasso  mf_pf1 i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk if sample==1,  lambda0(.0108377) prestd   robust maxpsiiter(1000)  supscore  nocons    //based on the lambda value from plugin

 estimate store lasso_cftrain
 estimate restore lasso_cftrain
lassogof cv bic  adapt plugin if sample==2, postselection

 /* 
  lasso linear  mf_pf1 i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk if sample==1, nolog rseed(12345) selection(cv) prestd
	estimate store cv
  estimate restore cv
lassogof cv bic  adapt plugin if sample==2
*/








 ************************************************* Analysis of production efficiency ends here and for monetary equivalence starts here*******************************************
 
 use "IBNET_data4_lasso-k.dta", clear
dummies region
encode ing,gen(inc_gr)
lab var inc_gr "Income group of countries"

 xtset Ucode Year
 
splitsample , generate(sample) split(.75 .25) rseed(12345)

label define slabel 1 "Training" 2 "Validation"

label values sample slabel

tabulate sample

tabulate region if sample==1

*tercile of fixed capital
xtile ter_fixedk= s1y,nq(3)
label define alabel 1 "Low" 2 "Moderate" 3 "High"

label values ter_fixedk alabel

tabulate ter_fixedk
lab var ter_fixedk "Terciles of fixed capital use per unit of output"

 /*
The one-way tabulation of sample produced by tabulate verifies that sample contains the requested 75%–25% division.Next, we compute the OLS estimates using the data in the training sample. We did the OLS model because When 𝜆=0, the linear lasso reduces to the OLS estimator.
*/
 xtset Ucode Year
quietly reg mel_prodineff i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk if sample==1 //instead of Country we can use regions or incomegroup.

estimates store ols


lassogof ols, over(sample)

/*Result from the above code. 
We use lassogof with option over(75-25 split sample) to compute the in-sample (Training) and out-of-sample (Validation) estimates of the MSE. As we find, 
the estimated MSE is much higher in the validation  sample. Rsquare is also much lower in validation sample. So, it can be said that the training model is overfit. Therefore, the out-of-sample estimate of the MSE is not reliable estimator for the prediction error; see, for example, chapters 1, 2, and 3 in Hastie, Tibshirani, and Friedman (2009).
We therefore need ot select important features and exclude the ones that are not important. LASSO is better fit to do that. 

Penalized coefficients 
*/

/*
Selecting the lasso tuning parameters

The tuning parameters must be selected before using the lasso for prediction or model selection. The most frequent methods used to select the tuning parameters are cross-validation (CV), the adaptive lasso, and plug-in methods. In addition, 𝜆 is sometimes set by hand in a sensitivity analysis. We calculate and compare all to find the best method to identify the optimal tuning parameter.

CV finds the 𝜆 that minimizes the out-of-sample MSE of the predictions. The mechanics of CV mimic the process using split samples to find the best out-of-sample predictor. The details are presented in an appendix.

CV is the default method of selecting the tuning parameters in the lasso command. In the output below, we use lasso to estimate the coefficients in the model for score, using the training sample. We specified the option rseed() to make our CV results reproducible.
*/



xtset Ucode Year
foreach x in cv adapt plugin bic{
lasso linear  mel_prodineff i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk  if sample==1, nolog rseed(12345) selection(`x')
	estimate store `x'
}

lassogof cv adapt plugin bic if sample==2

/*
Penalized coefficients
*/
lassogof  cv adapt plugin bic if sample==2, postselection //CV and bic's performance are similar

estimate restore cv

xtset Ucode Year
cvplot,minmax graphregion(fcolor(white)) plotregion(fcolor(white)) roll
graph save "Graph" "cvplot_mel24Aug22.gph", replace



/*Sensitivity analysis

Sensitivity analysis is sometimes performed to see if a small change in the tuning parameters leads to a large change in the prediction performance. When looking at the output of lassoknots produced by the CV-based lasso, we noted that for a small increase in the CV function produced by the penalized estimates, there could be a significant reduction in the number of selected covariates. 
*/
estimates restore cv
 lassoknots

estimates restore cv
lassoselect id = 66

 estimates store hand

lassogof cv adapt plugin bic if sample==2, postselection


xtset Ucode Year
rlasso  mel_prodineff i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk  if sample==1, gamma(.0001917) c(.0001917) prestd   robust maxpsiiter(10000) cluster(Cntry) supscore  nocons      



--

lasso linear  mel_prodineff i.prov_type##i.size i.ter_fixedk##i.size i.ter_fixedk##i.prov_type s86 item305 item309 item316 item317 item318 item319 item320  vae pve  rqe rle cce i.region##i.prov_type i.region##i.size i.region##i.ter_fixedk  i.inc_gr##i.prov_type i.inc_gr##i.size inc_gr##ter_fixedk  if sample==1, nolog rseed(12345) selection(cv) lambda0(/*.0332909.0005856*/ .0017882)
	
 estimate store lasso_meltrain
 
 lassocoef, display(coef, postselection)
 lassocoef, display(coef, standardized) sort(coef, standardized)
 
lassogof cv adapt  plugin bic if sample==2


/********************************************************** Tobit model *********************************************************************************************
** Cost efficiency

xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 if sample==1, re ll(0) ul(1)  sformat(%09.3f) lrmodel

estimates store tobitcf_train


xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 if sample==2, re ll(0) ul(1)   sformat(%09.3f) lrmodel

estimates store tobitcf_test


xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 , re ll(0) ul(1)  sformat(%09.3f) lrmodel

estimates store tobitcf_full


estimates table tobit_train tobit_test tobit_full, star stats(N p ll ll_0 chi2) sformat(%09.3f)

** Technical eficiency
xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 if sample==1, re ll(0) ul(1)  sformat(%09.3f) lrmodel

estimates store tobitcf_train


xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 if sample==2, re ll(0) ul(1)   sformat(%09.3f) lrmodel

estimates store tobitcf_test


xttobit mf_cf i.prov_type##i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	   Country1-Country9 Country11-Country69 , re ll(0) ul(1)  sformat(%09.3f) lrmodel

estimates store tobitcf_full



estimates table tobit_train tobit_test tobit_full, star stats(N p ll ll_0 chi2) sformat(%09.3f)




/ 
 
 
 
 
 
 
	  
xttobit mf_cf i.prov_type i.size s86 rqe rle item305 item309 item316 item317 item318 item319 ///
	  Year2-Year17 Country1-Country9 Country11-Country69, re ll(0) ul(1)
	outreg2 using "tobit_eff.xls", sideway noparen dec(3) replace label	  
/*****************************************************************
*table s6_decile, stat(median cost_eff1 prod_eff1) nformat(%5.3f)
*table s6_decile, stat(mean cost_eff1 prod_eff1) nformat(%5.3f)

foreach x in org mf mc kn{
	xtile `x'_s6decile=`x'_s6, nq(10)
	
	table `x'_s4, stat(median `x'_cf) nformat(%5.3f)
	table `x'_s6decile, stat(median `x'_cf) nformat(%5.3f)
	
	table `x'_s4, stat( mean `x'_cf) nformat(%5.3f)
	table `x'_s6decile, stat( mean `x'_cf) nformat(%5.3f)
}



foreach x in org mf mc kn{
	sort Year
	lowess `x'_cf `x'_s6decile,bw(.9) gen(`x's6) nograph
}

sort mf_s6decile
line orgs6 mf_s6decile|| line mcs6 mf_s6decile|| line mfs6 mf_s6decile ||line kns6 mf_s6decile 


******************************** Split sample Lasso machine learning************************************
/*

Researchers widely use the following steps to find the best predictor.

Divide the sample into training and validation subsamples.
Use the training data to estimate the model parameters of each of the competing estimators.
Use the validation data to estimate the out-of-sample mean squared error (MSE) of the predictions produced by each competing estimator.
The best predictor is the estimator that produces the smallest out-of-sample MSE.
The ordinary least-squares (OLS) estimator is frequently included as a benchmark estimator when it is feasible. We begin the process with splitting the sample and computing the OLS estimates.

In the output below, we read the data into memory and use splitsample with the option split(.75 .25) to generate the variable sample, which is 1 for a 75% of the sample and 2 for the remaining 25% of the sample. The assignment of each observation in sample to 1 or 2 is random, but the rseed option makes the random assignment reproducible.
*/

use hsafety2

splitsample , generate(sample) split(.75 .25) rseed(12345)

label define slabel 1 "Training" 2 "Validation"

label values sample slabel

tabulate sample

