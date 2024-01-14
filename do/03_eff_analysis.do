
cd  "$data"
*	merge imputed data into original dataset
use "IBNET3-mf-imputed.dta", clear
replace s4=int(s4)
replace s4=0 if s4<00
replace s4=3 if s4>=3
replace s5=round(s5)
replace s5=0 if s5!=1

foreach x in y1 y2 y3 dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5 {
	ren `x' mf_`x'
}
xtile tmf_s6=mf_s6,nq(3)

foreach x in dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s6 s8 y1 y2 y3	{
	replace mf_`x'=. if mf_`x'<10
	egen mf_`x'a=mean(mf_`x') ,by(Year mf_s4 tmf_s6)
	replace mf_`x'=mf_`x'a if mf_`x'==. 
  }
 
sort ID Year
tempfile mf
save `mf'

use "IBNET3-knn-imputed.dta",clear
replace s4=round(s4)
replace s4=0 if s4<00
replace s4=3 if s4>=3
replace s5=round(s5)
replace s5=0 if s5!=1
*replace t1=. if t1>5

foreach x in y1 y2 y3 dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5 {
  ren `x' kn_`x'
}

xtile tkn_s6=kn_s6,nq(3)

foreach x in dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s6 s8 y1 y2 y3	{
	replace kn_`x'=. if kn_`x'<10
    egen kn_`x'a=mean(kn_`x') ,by(Year kn_s4 tkn_s6)
    replace kn_`x'=kn_`x'a if kn_`x'==. 
  }
  
sort ID Year
tempfile knn
save `knn'

use "IBNET3-mice-imputed.dta",clear
replace s4=round(s4)
replace s4=0 if s4<00
replace s4=3 if s4>=3
replace s5=round(s5)
replace s5=0 if s5!=1
*replace t1=. if t1>5

tab1 s4 s5

foreach x in y1 y2 y3 dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5 {
  ren `x' mc_`x'
}

xtile tmc_s6=mc_s6,nq(3)


foreach x in dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s6 s8 y1 y2 y3	{
	replace mc_`x'=. if mc_`x'<10
    egen mc_`x'a=mean(mc_`x') ,by(Year mc_s4 tmc_s6)
    replace mc_`x'=mc_`x'a if mc_`x'==. 
  }
  
 foreach x in t1 t2 t3 t4 t5{
	replace mc_`x'=. if mc_`x'<=0
	egen mc_`x'a=mean(mc_`x') ,by(Year mc_s4 mc_s5)

	replace mc_`x'=mc_`x'a if mc_`x'==.
	*replace mc_t1=1 if mc_t1<1
  }
  
sort ID Year
tempfile mice
save `mice'
 

use "IBNET4.dta",clear
foreach x in y1 y2 y3 dc3 dc4 dc5 dc7 dc8 dc9 s1 s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5 {
  ren `x' org_`x'
}
merge 1:1 ID Year using `mf'
cap drop _merge
merge 1:1 ID Year using `knn'
cap drop _merge
merge 1:1 ID Year using `mice'
cap drop _merge


** Calculating deflated values for all variable used in analysis
drop  *vy1 *ld*

foreach x in org mf kn mc{
	gen `x'_dvy1=(`x'_y1*`x'_t1)*(PPP_def)/LCPPP
	
	foreach var in y2 y3  s1  s3 s4 s5 s6	{
		gen `x'_d`var'=`x'_`var'*(PPP_def)/LCPPP

		}
}

bysort ID: egen median_ldvy1=median(mf_dvy1)
replace mf_dvy1=median_ldvy1 if mf_dvy1==.
drop median_ldvy1

foreach x in dvy1 dy2 dy3  dc3 dc4 dc5 dc7 dc8 dc9 ds1  s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5	{

	lab var org_`x' "Cost `x' in PPP at 2017 Constant Int. dollars (original)"
	lab var mf_`x' "Cost `x' in PPP at 2017 Constant Int. dollars (miss forest)"
	lab var kn_`x' "Cost `x' in PPP at 2017 Constant Int. dollars (knn)"
	lab var mc_`x' " Cost `x' in PPP at 2017 Constant Int. dollars (mice)"
	
	gen org_l`x'=log(org_`x')
	gen mf_l`x'=log(mf_`x')
	gen kn_l`x'=log(kn_`x')
	gen mc_l`x'=log(mc_`x')
		
	lab var org_l`x' "Log cost `x' in PPP at 2017 Constant Int. dollars (original)"
	lab var mf_l`x' "Log cost  `x' in PPP at 2017 Constant Int. dollars (miss forest)"
	lab var kn_l`x' "Log cost  `x' in PPP at 2017 Constant Int. dollars (knn)"
	lab var mc_l`x' "Log cost  `x' in PPP at 2017 Constant Int. dollars (mice)"
		
		}
		
		
foreach x in org_s6 mf_s6 mc_s6 kn_s6{
	gen `x'p10=`x'	
	gen l`x'p10=log(`x'p10)	
	}
dummies org_s4 mf_s4 kn_s4 mc_s4

*removing other cost (c6) from the model.

** Terciles of s6
xtile mf_s6quintile=mf_s6,nq(3)
recode mf_s6quintile (1=1 "Small")(2=2 "Medium")(3=3 "Large"),gen(mf_s6quint)
lab var mf_s6quint "Three quintiles of population served "

** Fixed capital use per unit of production
gen mf_fc2out=mf_ds1/mf_dvy1
lab var mf_fc2out "Output per unit of fixed asset"
xtile mf_xfc2out=mf_fc2out,nq(10)


** Provider's type (Municipal, regional, National)
recode mf_s4 (0=4 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"), gen(prov_type)

codebook Country Ucode
sort index Country ID Year


**Comparing two imputed series with original series using dmariano test************************
/*
DM is simply an asymptotic z-test of the hypothesis that "the mean of a constructed but observed series (the loss differential)
is zero". The only wrinkle is that forecast errors, and hence loss differentials, may be serially correlated for a variety of
reasons, the most obvious being forecast suboptimality. Hence, the standard error in the denominator of the DM statistic  should be calculated robustly. Diebold and Mariano (1995) used
σˆd¯ = √gˆ(0)/T , where gˆ(0) is a consistent estimator of the loss differential spectrum at frequency zero.

Diebold-Mariano forecast comparison test for actual : org_c*
Competing forecasts:  mf_c7 versus kn_c7
Criterion: MAE 


Ref: Francis X. DIEBOLD (2015): Comparing Predictive Accuracy, Twenty Years Later: A Personal Perspective on the Use and Abuse of Diebold–Mariano Tests
Journal of Business & Economic Statistics, January 2015, Vol. 33, No. 1, DOI: 10.1080/07350015.2014.983236
*/
/*
use "dimputed_merged.dta",clear
bysort Year:gen k=_n

foreach x in dc3 dc4 dc5 dc7 dc9 y1 y2{
forvalues i = 1(1)1563 {
preserve
quietly keep  if k == `i'
display as result "k `i'"
quietly tsset Year
dmariano org_`x' mf_`x' mc_`x' if k == `i' & k!=1564, crit(MAE) kernel(bartlett)	max(7)
 
restore
}
}
* Note: missing forest is identified as better forecast between missing forest and mice forest. So in the next step, we compare kn with missing forest to check if it still holds.
foreach x in dc3 dc4 dc5 dc7 dc9 y1 y2{
forvalues i = 1(1)1564 {
preserve
quietly keep  if k == `i'
display as result "k `i'"
quietly tsset Year
dmariano org_`x' mf_`x' kn_`x' if k == `i', crit(MAE) kernel(bartlett)	
*estimates store dm`x'`i' 
restore
}
}
* Note:Missing forest is still identified as better forecast.
 ************************************************************************************************************************************************************************
*/


/*
*	FIGURE 3
*keep if Year<=2019 & Year>=2017
foreach x in org mf mc kn{
	sort Year
	*lowess `x'_t1 Year,bw(.8) gen(`x't1) nograph
	lowess `x'_ldc7 Year,bw(.8)  gen(`x'dc7) nograph
	lowess `x'_ldc9 Year,bw(.8) gen(`x'dc9) nograph
	lowess `x'_ldc4 Year,bw(.8) gen(`x'dc4) nograph
	lowess `x'_ldc3 Year,bw(.8) gen(`x'dc3) nograph
	lowess `x'_ldc5 Year,bw(.8) gen(`x'dc5) nograph
	*lowess `x'_y1 Year,bw(.8) gen(`x'y1) nograph
	lowess `x'_ldvy1 Year,bw(.8) gen(`x'dvy1) nograph
	lowess `x'_ldy2 Year,bw(.8) gen(`x'dy2) nograph
	lowess `x'_ldy3 Year,bw(.8) gen(`x'dy3) nograph
	*lowess `x'_c1 Year,bw(.2) gen(`x'c1) nograph
}

lab var org_ldc3 "Energy cost"
lab var org_ldc4 "R&M cost"
lab var org_ldc5 "Contracted service cost"
lab var org_ldc7 "Total operating cost"
lab var org_ldc9 "Labor cost"
lab var org_ldvy1 "Total production value"
lab var org_ldy2	"Total operating revenue"
lab var org_ldy3	"Total water operating revenue"

sort Year 
foreach x in dc3 dc4 dc5 dc7 dc9 dvy1 dy2 dy3 {
	local xlabel : variable label org_l`x'
	lab var org_l`x' "original `x'"
	lab var mf`x' "Missing Forest `x'"
	lab var mc`x' "MICE `x'"
	lab var kn`x' "K-NN `x'"
	
twoway (qfitci org_l`x' Year) (line mc`x' Year, mcolor(blue)) (line mf`x' Year, mcolor(green) )(line kn`x' Year, mcolor (orange)), graphregion(fcolor(white)) plotregion(fcolor(white)) title(" `xlabel'", size(vhuge)) /*subtitle("Comparison of different imputation methods",size(small))*/ ylabel(, labsize(vsmall)) ytitle(`x' cost) xlabel(2004(2)2020, labsize(medium)) legend(order(1 "95% CI" 2 "Orginal data" 3 "MICE" 4 "MissingForest" 5 "KNN") rows(1) pos(6))
graph save "$figures\\`x'1.gph", replace
 
}

cd "$figures"

grc1leg dc31.gph dc41.gph dc51.gph  dc91.gph dc71.gph dvy11.gph dy21.gph dy31.gph, col(2)  iscale(.2) graphregion(fcolor(white)) plotregion(fcolor(white)) legendfrom(dc31.gph) pos(6)
graph save "$figures/imputed_data.gph", replace

*/
****************************************************************************
cd  "$data"
  
tsset ID Year
*keep if time<=14
*drop if inlist(ID, 192,258,1175,1279,1284,2274,3227,3820,3822)	
gen time_sq=time^2
	
**** Cost efficiency	
*** Original data without imputation
sfpanel org_ldc7 org_ldc3 org_ldc4 org_ldc5 org_ldc9 time time_sq lorg_s6p10, model(tre) distribution(exp) cost nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "$tables/frontier.xls", sideway noparen dec(3) nose replace

estimates store tre_c 
predict orig_utre_c, u
tab Country if orig_utre_c==.

gen org_cf=exp(-orig_utre_c)  if   orig_utre_c!=.
replace org_cf=1 if org_cf!=. & org_cf>1
su org_cf,de



** Imputed data using missing forest
sfpanel mf_ldc7 mf_ldc3 mf_ldc4 mf_ldc5 mf_ldc9 time time_sq lmf_s6p10, model(tre) distribution(exp) cost nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "$tables/frontier.xls", sideway noparen dec(3) nose append

estimates store mf_tre_c 
predict mf_utre_c, u
tab Country if mf_utre_c==.

gen mf_cf=exp(-mf_utre_c)  if   mf_utre_c!=.
replace mf_cf=1 if mf_cf!=. & mf_cf>1
su mf_cf,de




**** Production efficiency
** Original data without imputation
	
sfpanel org_ldvy1 org_ldc3 org_ldc4 org_ldc5 org_ldc9 time time_sq lorg_s6p10, model(tre) distribution(exp)  nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "$tables/frontier.xls", sideway noparen dec(3) nose append

estimates store tre_p1 
predict orig_utre_p1, u
tab Country if orig_utre_p1==.

gen org_pf1=exp(-orig_utre_p1)  if   orig_utre_p1!=.
*replace org_pf1=1 if org_pf1!=. & org_pf1>1
su org_pf1,de


** Imputed data using missing forest
sfpanel mf_ldvy1 mf_ldc3 mf_ldc4 mf_ldc5 mf_ldc9 time time_sq lmf_s6p10, model(tre) distribution(exp) nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "$tables/frontier.xls", sideway noparen dec(3) nose append

estimates store mf_tre_p1 
predict mf_utre_p1, u
tab Country if mf_utre_p1==.

gen mf_pf1=exp(-mf_utre_p1)  if   mf_utre_p1!=.
*replace mf_pf1=1 if mf_pf1!=. & mf_pf1>1
su mf_pf1,de
save "monetary_equiv_loss-k.dta",replace


use "monetary_equiv_loss-k.dta", clear

*	FIGURE 4
*	percentile distribution
tabstat org_cf mf_cf org_pf1 mf_pf1, stats(mean median sd)

foreach var in org_cf mf_cf org_pf1 mf_pf1	{
	preserve
	drop if `var'==.
	xtile decile = `var', nq(10)
	collapse `var', by(decile)
	sort decile
	save `var', replace
	restore
}

use "org_cf.dta", clear
merge 1:1 decile using "mf_cf.dta"
drop _merge
merge 1:1 decile using "org_pf1.dta"
drop _merge
merge 1:1 decile using "mf_pf1.dta"
drop _merge

gen percentile=decile/10
twoway (connected org_cf percentile) (connected mf_cf percentile) (connected org_pf1 percentile) (connected mf_pf1 percentile), ///
ytitle(`"Cost/Technical Efficiency"') ylabel(0(0.1)1) xtitle(`"Percentile"') xlabel(.1(.1)1) ///
legend(order(1 "Cost Eff (original)" 2 "Cost Eff (imputated)" 3 "Tech Eff (original)" 4 "Tech Eff (imputated)"))


use "monetary_equiv_loss-k.dta", clear

*	FIGURE 5
** Graphs for the report************************************************************
** Dot plots

egen mmf_cf=mean(mf_cf),by(Year)
egen mmf_pf1=mean(mf_pf1),by(Year)
gen diff_cf=mf_cf-mmf_cf
gen diff_pf1 = mf_pf1-mmf_pf1
  
table Year if diff_cf>0, stat (n diff_cf)
table Year if diff_cf<0, stat (n diff_cf)

cd "$figures"

/*	
dotplot mf_cf,over(Year) dsize(v.tiny) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Cost efficiency", size(vhuge)) ytitle(Cost efficiency, size(vhuge)) ylabel(0(.1)1) xlabel(2004(1)2020, labsize(huge)) xtitle("")
graph save "Graph" "dpcf24Aug2022.gph", replace


dotplot mf_pf1,over(Year) dsize(tiny) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Technical Efficiency", size(vhuge)) ytitle(Technical efficiency, size(vhuge)) ylabel(0(.1)1) xlabel(2004(1)2020, labsize(huge)) xtitle("")
graph save "Graph" "dpef24Aug2022.gph", replace

grc1leg dpcf24Aug2022.gph dpef24Aug2022.gph, legendfrom() col(1) xcommon ycommon iscale(.3) graphregion(fcolor(white))  plotregion(fcolor(white))

graph save "$figures/eff_year.gph", replace
*/

twoway (lowess  mf_cf Year if mf_s6quint==1)(lowess  mf_cf Year if mf_s6quint==2)(lowess  mf_cf Year if mf_s6quint==3)

twoway (lowess  mf_pf1 Year if mf_s6quint==1)(lowess  mf_pf1 Year if mf_s6quint==2)(lowess  mf_pf1 Year if mf_s6quint==3)

twoway (qfit  mf_cf Year if mf_s6quint==1)(qfit  mf_cf Year if mf_s6quint==2)(qfit  mf_cf Year if mf_s6quint==3), ///
xlabel(2004(2)2020) legend(order(1 "Small"  2 "Medium" 3 "Large")) ytitle("Cost efficiency")

twoway (qfit  mf_pf1 Year if mf_s6quint==1)(qfit  mf_pf1 Year if mf_s6quint==2)(qfit  mf_pf1 Year if mf_s6quint==3), ///
xlabel(2004(2)2020) legend(order(1 "Small" 2 "Medium" 3 "Large")) ytitle("Technical efficiency")


operating expense tercile

collapse mf_cf mf_pf1, by(mf_s6quint Year)





/*
** Box Plots Fig 7 and 8 for the report
** Box plot by population served


graph box mf_cf,noout over(mf_s6quint) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Cost efficiency by size", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "bpareacf24Aug2022.gph", replace

graph box mf_pf1, noout over(mf_s6quint) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Technical efficiency by Size", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "bpareapf24Aug2022.gph", replace


grc1leg "bpareacf24Aug2022.gph" "bpareapf24Aug2022.gph", col(2)row(1) xcommon ycommon iscale(.7) graphregion(fcolor(white)) plotregion(fcolor(white)) /*title(" Distribution of Cost and Technical Efficiency by Year", size(LArge))subtitle("Comparison of different imputation methods",size(small))*/  legendfrom("bpareacf24Aug2022.gph") pos(6)



table mf_s6quint,stat(p50 mf_cf mf_pf1)

** for qtfit graphs for capital output ratio Fig. 9 in the report
twoway (qfit  mf_pf1 mf_xfc2out if mf_s6quint==1)(qfit  mf_pf1 mf_xfc2out if mf_s6quint==2)(qfit  mf_pf1 mf_xfc2out if mf_s6quint==3), graphregion(fcolor(white)) plotregion(fcolor(white))

graph save "Graph" "prod eff by fixed asset per unit of output24Aug2022.gph"


** Box plot by service type


table prov_type, stat(median mf_cf mf_pf1) nformat(%5.3f)
table prov_type,stat(count Ucode)

graph box mf_cf,noout over(prov_type) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Cost efficiency by Service providers' type", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "bpspcf24Aug22.gph", replace

graph box mf_pf1, noout over(prov_type) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Technical efficiency by Service providers' type", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "bpsppf24Aug22.gph", replace


grc1leg "bpspcf24Aug22.gph" "bpsppf24Aug22.gph", col(2)row(1) xcommon ycommon iscale(.7) graphregion(fcolor(white)) plotregion(fcolor(white)) /*title(" Distribution of Cost and Technical Efficiency by Year", size(LArge))subtitle("Comparison of different imputation methods",size(small))*/  legendfrom("bpsppf24Aug22.gph") pos(6)
*/

/*
** Efficiency by region and income group
import excel "regions.xlsx", firstrow sheet("Sheet2") clear
* Micronesia, Fed. Sts.  Kiribati Russian Federation Egypt Cabo Verde
replace Country="Federated States Of Micronesia"	if Country=="Micronesia, Fed. Sts."
replace Country ="Cape Verde" if Country=="Cabo Verde"
replace Country ="Egypt" if Country=="Egypt, Arab Rep."
replace Country ="Republic Of Kiribati" if Country=="Kiribati"
replace Country="Russia" if Country=="Russian Federation"
replace Country="Slovakia" if Country=="Slovak Republic"
sort Country
save "regions.dta",replace

use "imp_efficiency-k.dta",clear
sort Country
 merge m:1 Country using "regions.dta"
 tab _merge
 drop if _merge==2
 sort Country Year
 drop _merge
 
 gen reg=""
 replace reg="EAP" if Region=="East Asia & Pacific"
 replace reg="LAC" if Region=="Latin America & Caribbean"
 replace reg="ECA" if Region=="Europe & Central Asia"
 replace reg="MNA" if Region=="Middle East & North Africa"
 replace reg="SAR" if Region=="South Asia"
 replace reg="SSA" if Region=="Sub-Saharan Africa"
 
 encode reg,gen(region)
 table region, stat(p50 mf_cf mf_pf1)
 
 
** Box plot by income group
 gen ing=""
 replace ing="HIC" if Incomegroup=="High income"
replace ing="LIC" if Incomegroup=="Low income"
replace ing="LMIC" if Incomegroup=="Lower middle income"
replace ing="UMIC" if Incomegroup=="Upper middle income"

encode ing,gen(incomegr)
table incomegr, stat(p50 mf_cf mf_pf1)

encode ing,gen(inc_gr)
lab var inc_gr "Income group of countries"
*/

gen s86=mf_s8/mf_s6 
lab var s86 "Length of network per unit population served"

gen s1y=mf_s1/mf_dvy1 
lab var s1y "Gross fixed asset per unit output produced"


*tercile of fixed capital
xtile ter_fixedk= s1y,nq(3)
label define alabel 1 "Low" 2 "Moderate" 3 "High"

label values ter_fixedk alabel

tabulate ter_fixedk
lab var ter_fixedk "Terciles of fixed capital use per unit of output"


******************************************************* *************Monetary Equivalence *******************************************************

 ** Generating monetary equivalence of inefficiency
gen mel_costineff=((1-mf_cf)*mf_dc7*PPP17toUSD15)/1000000000  //Monetary equivalent loss of cost inefficincy
gen mel_prodineff=(1-mf_pf1)*mf_dc7*PPP17toUSD15/1000000000  //Monetary equivalent loss of cost inefficincy

gen mf_bdc7=mf_dc7*PPP17toUSD15/1000000000                  //Total operating cost in bill.


lab var mel_costineff "monetary equivalent of loss (in USD 2015) due to cost inefficiency"
lab var mel_prodineff "monetary equivalent of loss (in billion USD 2015) due to prod inefficiency"
lab var mf_bdc7 "Operating cost in bill. USD 2015 "

recode mf_s6quint (1=1 "Small")(2=2 "Medium")(3=3 "Large"),gen(size)

** Provider's type (Municipal, regional, National)
*recode mf_s4 (0=4 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"),gen(prov_type)


gen nutilities=1
lab var nutilities "Number of utilities for each country"
*drop Ucode


*encode Region,gen(Reg)
encode Country, gen(Cntry)
tab size,nolab


*save "monetary_equiv_loss-k.dta",replace


** Collapsing by country for all 14 years and all available utilities
/*
use "monetary_equiv_loss.dta",clear
** Box plot by region
  graph box mf_cf,noout over(reg) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of cost efficiency by region", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "bprgcf24Aug22.gph", replace

graph box mf_pf1, noout over(reg) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of technical efficiency by region", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "bprgpf24Aug22.gph", replace

grc1leg "bprgcf24Aug22.gph" "bprgpf24Aug22.gph", col(2)row(1) xcommon ycommon iscale(.7) graphregion(fcolor(white)) plotregion(fcolor(white)) /*title(" Distribution of Cost and Technical Efficiency by region", size(LArge))subtitle("Comparison of different imputation methods",size(small))*/  legendfrom( "bprgpf24Aug22.gph") pos(6)

graph box mf_cf,noout over(ing) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of cost efficiency by income group", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "bpinccf24Aug22.gph", replace

graph box mf_pf1, noout over(ing) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of technical efficiency by income group", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "bpincpf24Aug22.gph", replace

grc1leg "bpinccf24Aug22.gph" "bpincpf24Aug22.gph", col(2)row(1) xcommon ycommon iscale(.7) graphregion(fcolor(white)) plotregion(fcolor(white)) /*title(" Distribution of Cost and Technical Efficiency by income group", size(LArge))subtitle("Comparison of different imputation methods",size(small))*/  legendfrom( "bpincpf24Aug22.gph") pos(6)

*/
                                                      ** Effciency graphs region
** Provider's type *********************************************************************************************************************************
use "monetary_equiv_loss-k.dta",clear
recode region(1=1 "EAP")(2=2 "ECA")(3=3 "LAC")(4=4 "MENA")(5=5 "SAR")(6=6 "SSA"), gen (r)
drop region
ren r region

*drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(region prov_type)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(region prov_type)


*production
forval i=1(1)6{

graph hbar mf_pf1 if region==`i', over(prov_type) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbytypereg`i'24Aug22.gph", replace
}

grc1leg "p_effbytypereg124Aug22.gph" "p_effbytypereg224Aug22.gph" "p_effbytypereg324Aug22.gph" "p_effbytypereg424Aug22.gph" "p_effbytypereg524Aug22.gph" "p_effbytypereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across region(2004-20)", size(Large)) subtitle("(By type of ownership)") legendfrom( "p_effbytypereg124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byreg_type_5Aug2022.gph", replace


/*cost
forval i=1(1)6{
graph hbar mel_costineff1 if region==`i', over(prov_type) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss)  note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbytypereg`i'24Aug22.gph", replace
}
grc1leg "c_melbytypereg124Aug22.gph" "c_melbytypereg224Aug22.gph" "c_melbytypereg324Aug22.gph" "c_melbytypereg424Aug22.gph" "c_melbytypereg524Aug22.gph" "c_melbytypereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Million USD 2015)")  legendfrom( "c_melbytypereg124Aug22.gph") pos(6)
*/

** ************By size******************************************************** *********************************************************************************

use "monetary_equiv_loss-k.dta",clear
recode region(1=1 "EAP")(2=2 "ECA")(3=3 "LAC")(4=4 "MENA")(5=5 "SAR")(6=6 "SSA"), gen (r)
drop region
ren r region

drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(wbregion size)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(region size)


*production
forval i=1(1)6{

graph hbar mf_pf1 if region==`i', over(size) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbysizereg`i'24Aug22.gph", replace
}

grc1leg "p_effbysizereg124Aug22.gph" "p_effbysizereg224Aug22.gph" "p_effbysizereg324Aug22.gph" "p_effbysizereg424Aug22.gph" "p_effbysizereg524Aug22.gph" "p_effbysizereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across region(2004-20)", size(Large)) subtitle("(By Size)") legendfrom( "p_effbysizereg124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byreg_size_5Aug2022.gph", replace

/*cost
forval i=1(1)6{
graph hbar mel_costineff if region==`i', over(size) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)100) note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbysizereg`i'24Aug22.gph", replace
}
grc1leg "c_melbysizereg124Aug22.gph" "c_melbysizereg224Aug22.gph" "c_melbysizereg324Aug22.gph" "c_melbysizereg424Aug22.gph" "c_melbysizereg524Aug22.gph" "c_melbysizereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Billion USD 2015)")  legendfrom( "c_melbysizereg124Aug22.gph") pos(6)
*/


** ******************************************************************** Effciency by fixed Capital use*********************************************************************************

use "monetary_equiv_loss-k.dta",clear
recode region(1=1 "EAP")(2=2 "ECA")(3=3 "LAC")(4=4 "MENA")(5=5 "SAR")(6=6 "SSA"), gen (r)
drop region
ren r region

drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(region ter_fixedk)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(region ter_fixedk)


*production
forval i=1(1)6{

graph hbar mf_pf1 if region==`i', over(ter_fixedk) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbyfkreg`i'24Aug22.gph", replace
}

grc1leg "p_effbyfkreg124Aug22.gph" "p_effbyfkreg224Aug22.gph" "p_effbyfkreg324Aug22.gph" "p_effbyfkreg424Aug22.gph" "p_effbyfkreg524Aug22.gph" "p_effbyfkreg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across region(2004-20)", size(Large)) subtitle("(By fixed capital use)") legendfrom( "p_effbyfkreg124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byreg_fixedk_5Aug2022.gph", replace

/*cost
forval i=1(1)6{
graph hbar mel_costineff if region==`i', over(size) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)100) note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbysizereg`i'24Aug22.gph", replace
}
grc1leg "c_melbysizereg124Aug22.gph" "c_melbysizereg224Aug22.gph" "c_melbysizereg324Aug22.gph" "c_melbysizereg424Aug22.gph" "c_melbysizereg524Aug22.gph" "c_melbysizereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Billion USD 2015)")  legendfrom( "c_melbysizereg124Aug22.gph") pos(6)
*/



                                                *** Efficiency graph by income group
	                     
** Provider's type *********************************************************************************************************************************
use "monetary_equiv_loss-k.dta",clear

drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(inc_gr prov_type)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(inc_gr prov_type)


*production
forval i=1(1)4{

graph hbar mf_pf1 if inc_gr==`i', over(prov_type) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbytypeinc`i'24Aug22.gph", replace
}

grc1leg "p_effbytypeinc124Aug22.gph" "p_effbytypeinc224Aug22.gph" "p_effbytypeinc324Aug22.gph" "p_effbytypeinc424Aug22.gph" , col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across income group(2004-20)", size(Large)) subtitle("(By type of ownership)") legendfrom( "p_effbytypeinc124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byinc_type_5Aug2022.gph", replace


/*cost
forval i=1(1)6{
graph hbar mel_costineff1 if region==`i', over(prov_type) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss)  note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbytypereg`i'24Aug22.gph", replace
}
grc1leg "c_melbytypereg124Aug22.gph" "c_melbytypereg224Aug22.gph" "c_melbytypereg324Aug22.gph" "c_melbytypereg424Aug22.gph" "c_melbytypereg524Aug22.gph" "c_melbytypereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Million USD 2015)")  legendfrom( "c_melbytypereg124Aug22.gph") pos(6)
*/

** ************By size******************************************************** *********************************************************************************

use "monetary_equiv_loss-k.dta",clear

drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(inc_gr size)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(inc_gr size)


*production
forval i=1(1)4{

graph hbar mf_pf1 if inc_gr==`i', over(size) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbysizeinc`i'24Aug22.gph", replace
}

grc1leg "p_effbysizeinc124Aug22.gph" "p_effbysizeinc224Aug22.gph" "p_effbysizeinc324Aug22.gph" "p_effbysizeinc424Aug22.gph" , col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across income group(2004-20)", size(Large)) subtitle("(By Size)") legendfrom( "p_effbysizeinc124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byinc_incsize_5Aug2022.gph", replace

/*cost
forval i=1(1)6{
graph hbar mel_costineff if region==`i', over(size) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)100) note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbysizereg`i'24Aug22.gph", replace
}
grc1leg "c_melbysizereg124Aug22.gph" "c_melbysizereg224Aug22.gph" "c_melbysizereg324Aug22.gph" "c_melbysizereg424Aug22.gph" "c_melbysizereg524Aug22.gph" "c_melbysizereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Billion USD 2015)")  legendfrom( "c_melbysizereg124Aug22.gph") pos(6)
*/


** ******************************************************************** Effciency by fixed Capital use*********************************************************************************

use "monetary_equiv_loss-k.dta",clear

drop if Country=="Belarus"
collapse(sum)mf_bdc7 nutilities (mean)mf_cf mf_pf1 (count)Cntry, by(inc_gr ter_fixedk)
gen mel_prodineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000   
gen mel_costineff1=((1-mf_pf1)*mf_bdc7/Cntry)*1000
lab var mel_prodineff1 "Monetary equivalence of loss in million"
lab var mel_costineff1 "Monetary equivalence of loss in million"



collapse (mean)mel_costineff1 mel_prodineff1 (mean)mf_cf mf_pf1, by(inc_gr ter_fixedk)
tab inc_gr,m
drop if ter_fixedk==.
*production
forval i=1(1)4{

graph hbar mf_pf1 if inc_gr==`i', over(ter_fixedk) blabel(total,format (%15.2f)) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle("Technical efficiency") /*ylabel(0(50)600)*/ /*note("Note: USD 2015 refers to USD at 2015 constant price")*/
graph save "Graph" "p_effbyfkinc`i'24Aug22.gph", replace
}

grc1leg "p_effbyfkinc124Aug22.gph" "p_effbyfkinc224Aug22.gph" "p_effbyfkinc324Aug22.gph" "p_effbyfkinc424Aug22.gph" , col(2)row(2) xcommon ycommon iscale(.45) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Average tecnical inefficiency across income group(2004-20)", size(Large)) subtitle("(By fixed capital use)") legendfrom( "p_effbyfkinc124Aug22.gph") pos(6)
graph save "Graph" "efficiency_byinc_fixedk_5Aug2022.gph", replace

/*cost
forval i=1(1)6{
graph hbar mel_costineff if region==`i', over(size) blabel(total) title(`i',size(v.large))  graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)100) note("Note: USD 2015 refers to USD at 2015 constant price")
graph save "Graph" "c_melbysizereg`i'24Aug22.gph", replace
}
grc1leg "c_melbysizereg124Aug22.gph" "c_melbysizereg224Aug22.gph" "c_melbysizereg324Aug22.gph" "c_melbysizereg424Aug22.gph" "c_melbysizereg524Aug22.gph" "c_melbysizereg624Aug22.gph", col(2)row(2) xcommon ycommon iscale(.3) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Total loss due to cost inefficiency (2004-20)", size(Large))subtitle("(In Billion USD 2015)")  legendfrom( "c_melbysizereg124Aug22.gph") pos(6)
*/

