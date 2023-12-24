
/*

*/
******************************************************************************************************************************************************************
** Creating lags and 3 years moving averages to replace missing values at bottom. We repeat this for 3 times
******************************************************************************************************************************************************************

use "IBNET3.dta",clear
foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*

foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*

foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3* 

**** Y1 is complete. Next steps are to fill out the xs.

foreach x in x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*

foreach x in  x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*

foreach x in x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3* 


save "IBNET4.dta",replace  

*********************************************************************************************************
** Creating Leads and 3 years moving averages to replace missing values at top . We repeat this for 3 times
*********************************************************************************************************
use "IBNET4.dta",clear
foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

**** Y1 is complete. Next step is to complete the xs

foreach x in  x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

foreach x in x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

foreach x in  x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s6 s7 s8 PPP_def LCPPP PPP2US15{
gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*


save "IBNET5.dta",replace  
************************************************2nd  check point for sfpanel sensitivity analysis************************************************************

use "IBNET5.dta",clear
gen time=Year-2003
gen vy1=t1*y1
tsset Ucode Year
foreach x in vy1 y2 y3 c7  c2 c3 c4 c5 c6 c8 c9{
*egen m`x'=mean(`x'),by(Year s4 s6_decile)
	*replace `x'=m`x' if `x'==.|`x'==0
	gen d`x'=(`x'*PPP_def)/LCPPP
	lab var d`x' "Cost `x' in PPP at 2017 Constant Int. dollars"
		gen ld`x'=log(d`x')
		lab var ld`x' "Log of Cost `x' in PPP at 2017 Constant Int. dollars"
}


tsset Ucode Year

*removing other cost (c6) from the model.
sfpanel ldc7 ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) cost nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append

estimates store tre_c 
predict u_tre_c, u
tab Country if u_tre_c==.

gen cost_eff2=exp(-u_tre_c)  if   u_tre_c!=.
replace cost_eff2=1 if cost_eff2!=. & cost_eff2>1
su cost_eff2,de

sfpanel ldvy1  ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) nsim(10) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append


estimates store tre_p 
predict u_tre_p, u
tab Country if u_tre_p==.

gen prod_eff2=exp(-u_tre_p) if u_tre_p!=.
replace prod_eff2=1 if prod_eff2!=. & prod_eff2>1
save "testrun2.dta",replace
****************************************************************************************************************************************************************
use "IBNET5.dta",clear
xtile s6_decile = s6, nq(10)
xtile s3_decile = s3, nq(10)
xtile s1_decile = s1, nq(10)
sort Country Ucode Year

foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s7 s8 PPP_def LCPPP PPP2US15{
	egen mean_`x'=mean(`x'),by(Year s4 s6_decile)
	replace `x'=mean_`x' if `x'==.|`x'==0
}
save "IBNET6.dta",replace  
************************************************ 3rd check point for sfpanel *************************************************************************************

use "IBNET6.dta",clear
gen time=Year-2003
gen vy1=t1*y1
tsset Ucode Year
foreach x in vy1 y2 y3 c7  c2 c3 c4 c5 c6 c8 c9{
*egen m`x'=mean(`x'),by(Year s4 s6_decile)
	*replace `x'=m`x' if `x'==.|`x'==0
	gen d`x'=(`x'*PPP_def)/LCPPP
	lab var d`x' "Cost `x' in PPP at 2017 Constant Int. dollars"
		gen ld`x'=log(d`x')
		lab var ld`x' "Log of Cost `x' in PPP at 2017 Constant Int. dollars"
}


su
** Cost minimization
tsset Ucode Year

*removing other cost (c6) from the model.
sfpanel ldc7 ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) cost nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append

estimates store tre_c 
predict u_tre_c, u
tab Country if u_tre_c==.

gen cost_eff1=exp(-u_tre_c)  if   u_tre_c!=.
replace cost_eff1=1 if cost_eff1!=. & cost_eff1>1
su cost_eff1,de

sfpanel ldvy1  ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) nsim(10) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append


estimates store tre_p 
predict u_tre_p, u
tab Country if u_tre_p==.

gen prod_eff1=exp(-u_tre_p) if u_tre_p!=.
replace prod_eff1=1 if prod_eff1!=. & prod_eff1>1
save "testrun3.dta",replace

**********************************************************************************************************************************************************************


use "IBNET6.dta",clear

gen int negyear = -Year
foreach x in x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s4 s5 s6 s7 s8 PPP_def LCPPP PPP2US15{
	
 bysort Ucode (negyear): carryforward `x' if `x'==.|`x'==0, replace
bysort Ucode (Year): carryforward `x' if `x'==.|`x'==0, replace
	
}
sort Country Year 
*br Country Ucode Year tot_m* if tot_mc8==0 


** Note: One way to replace the zero values is by replacing them by country average by year.

save "final_ibnetdata.dta",replace

** Here we are replacing the missing values by mean of same type, population served for each year. This will keep the replaced values within some reasonable margins.
use "final_ibnetdata.dta",clear

** collapse(mean)y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s7 s8 PPP_def, by(Year s4 s6_decile)
/*
foreach x in y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s7 s8 PPP_def{
	egen mean_`x'=mean(`x'),by(Year s4 s6_decile)
	replace `x'=mean_`x' if `x'==.|`x'==0
	
}
 */
 cap drop s41
 dummies s4
su
*drop mean_*
sort Country Ucode Year
bysort Country Ucode: gen time=_n
order Country Utility Ucode Year y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s4 s5 s6 s7 s8 s6_decile PPP_def LCPPP PPP2US15
su y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s4 s5 s6 s7 s8 s6_decile PPP_def PPP2US15

replace t1=2.95 if  t1==. & Year==2017 
replace t1=2.91 if  t1==. & inlist(Year,2016,2015) 
replace t1=3.01 if  t1==. & inlist(Year,2004,2005, 2006,2007, 2009,2012,2013, 2014) 
replace t1=2.96 if  t1==. & inlist(Year,2008, 2010, 2011)
*bysort Year: su t1 y1

gen vy1=y1*t1

su y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 vy1 s1 s2 s3 s4 s5 s6 s7 s8

*drop if inlist(Country, "Australia", "Romania", "Peru", "Czech Republic")
*br Country Ucode Year x*  c* 

**************************Added s1-s8 uptil this point ****************************


** Setting for panel data analysis
tsset Ucode Year
foreach x in vy1 y2 y3 c7  c2 c3 c4 c5 c6 c8 c9{
egen m`x'=mean(`x'),by(Year s4 s6_decile)
	*replace `x'=m`x' if `x'==.|`x'==0
	gen d`x'=(`x'*PPP_def)/LCPPP
	lab var d`x' "Cost `x' in PPP at 2017 Constant Int. dollars"
		gen ld`x'=log(d`x')
		lab var ld`x' "Log of Cost `x' in PPP at 2017 Constant Int. dollars"
}


su
** Cost minimization
tsset Ucode Year
sfpanel ldc7 ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) cost nsim(20) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append

estimates store tre_c 
predict u_tre_c, u
tab Country if u_tre_c==.

gen cost_eff=exp(-u_tre_c)  if   u_tre_c!=.
replace cost_eff=1 if cost_eff!=. & cost_eff>1
su cost_eff,de

sfpanel ldvy1  ldc3 ldc4 ldc5 ldc9 time, model(tre) distribution(exp) nsim(10) simtype(genhalton) base(7) rescale vce(robust)
outreg2 using "frontier_test.xls", sideway noparen dec(3) nose append


estimates store tre_p 
predict u_tre_p, u
tab Country if u_tre_p==.

gen prod_eff=exp(-u_tre_p) if u_tre_p!=.
replace prod_eff=1 if prod_eff!=. & prod_eff>1
save "efficiency.dta",replace
***************************************************************** Graphs for the report************************************************************
** Dot plots
use "efficiency.dta",clear
dotplot cost_eff1,over(Year) dsize(v.tiny)graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of cost efficiency over the years", size(medium)) ytitle(Cost efficiency) xlabel(2004(1)2017, labsize(small))
graph save "Graph" "dotplot cost eff 31Jan22.gph", replace

dotplot prod_eff1,over(Year) dsize(tiny)graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of technical efficiency over the years", size(medium)) ytitle(Technical efficiency) xlabel(2004(1)2017, labsize(small))
graph save "Graph" "dotplot prod eff 31Jan22.gph", replace


** Box Plots
table s6_decile, stat(median cost_eff1 prod_eff1) nformat(%5.3f)
table s6_decile, stat(mean cost_eff1 prod_eff1) nformat(%5.3f)


table s4, stat(median cost_eff1 prod_eff1) nformat(%5.3f)
table s4, stat(mean cost_eff1 prod_eff1) nformat(%5.3f)

cap drop ds1 s1_decile
gen ds1=s1*PPP_def/*/LCPPP*/
xtile s1_decile=ds1,nq(10)
table s1_decile,stat(median cost_eff1 prod_eff1) nformat(%5.3f)
table s1_decile,stat(mean cost_eff1 prod_eff1) nformat(%5.3f)

** Box plot by population served
graph box cost_eff1,noout over(s6_decile) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of cost efficiency by deciles of Popn. served", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "Boxplot cost eff by pop served31Jan22.gph", replace

graph box prod_eff1, noout over(s6_decile) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of technical efficiency by deciles of Popn. served", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "Boxplot tech eff by pop served31Jan22.gph", replace

** Box plot by service type

recode s4 (0=0 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"),gen(service_prov_type)

table service_prov_type, stat(median cost_eff1 prod_eff1) nformat(%5.3f)


graph box cost_eff1,noout over(service_prov_type) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of cost efficiency by Service providers' type", size(medium)) ytitle(Cost efficiency) 
graph save "Graph" "Boxplot cost eff by service provider31Jan22.gph", replace

graph box prod_eff1, noout over(service_prov_type) graphregion(fcolor(white)) plotregion(fcolor(white)) title("Distribution of technical efficiency by Service providers' type", size(medium)) ytitle(Technical efficiency) 
graph save "Graph" "Boxplot tech eff by service provider31Jan22.gph", replace



recode cat_ceff1(1=1 "0 to 30 percent")(2=2 "30 to 50 percent")(3=3 "50 to 70 percent")(4=4 "70 to 80 percent")(5=5 "80 to 90 percent")(6=6 "80 to 90 percent")(7=7 "90 to 100 percent"),gen(cat_costeff)


*** Lets find out monetory equivalent of loss in efficiency
** bringing in regions
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

use "efficiency.dta",clear
sort Country
 merge m:1 Country using "regions.dta"
 tab _merge
 drop if _merge==2
 sort Country Year
 drop _merge
merge  Country Year using "PPP_def.dta"
tab _merge
 drop if _merge==2
 
 drop _merge
gen mel_costineff=(1-cost_eff1)*dc7*PPP17toUSD15
gen mel_cineff_bill=mel_costineff/1000000000
gen bdc7=dc7*PPP17toUSD15/1000000000
lab var mel_costineff "monetary equivalent of loss (in USD 2015) due to inefficiency"
lab var mel_cineff_bill "monetary equivalent of loss (in billion USD 2015) due to inefficiency"
lab var bdc7 "Operating cost in bill. USD 2015 "
gen size1=0 if inlist(s6_decile, 1,2,3)
replace size1=1 if inlist(s6_decile,4,5,6,7)
replace size1=2 if inlist(s6_decile,8,9,10)
recode size1 (0=0 "Small")(1=1 "Medium")(2=2 "Large"),gen(size)


** Collapsing by country for all 14 years and all available utilities
collapse(sum)mel_cineff_bill mel_costineff bdc7 (mean)cost_eff1 (count)Ucode, by(Country Region Incomegroup size)
gen nutilities=round(Ucode/14)
lab var nutilities "Number of utilities for each country"
drop Ucode
save "monetary_equiv_loss.dta",replace



** Graphs by regions and income groups

* By size Total 
use "monetary_equiv_loss.dta",clear
drop if Country=="Belarus"
encode Region,gen(Reg)
encode Country, gen(Cntry)
tab size,nolab
collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry, by(size)
*collapse(mean)mel_cineff_bill mel_costineff dc7 nutilities (mean) cost_eff1 (count)Cntry, by(size)

sort mel_costineff
graph hbar mel_cineff_bill, over(size) blabel(total) title("Total loss due to cost inefficiency (2004-17)",size(medium)) subtitle("(In Billion USD 2015)") graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)100) note("Note: USD 2015 refers to USD at 2015 constant price")

collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry
save "monetary_equiv_loss_size.dta",replace

/* By size Average 
use "monetary_equiv_loss.dta",clear
drop if Country=="Belarus"
encode Region,gen(Reg)
encode Country, gen(Cntry)
tab size,nolab
collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry, by(size)

sort mel_costineff
graph hbar mel_cineff_bill, over(size) blabel(total) title("Average loss due to cost inefficiency (2004-17)",size(medium)) subtitle("(In Billion PPP)") graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(10)50) note("Note: PPP in 2017 dollar")

collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry
save "avmonetary_equiv_loss_size.dta",replace
*/
***********************************************************************************************
* By Regions  
use "monetary_equiv_loss.dta",clear
drop if Country=="Belarus"
encode Region,gen(Reg)
encode Country, gen(Cntry)
tab Reg,nolab
collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry, by(Reg)
*collapse(mean)mel_cineff_bill mel_costineff dc7 nutilities (mean) cost_eff1 (count)Cntry, by(Reg)

sort mel_costineff
graph hbar mel_cineff_bill, over(Reg) blabel(total) title("Total loss due to cost inefficiency (2004-17)",size(medium)) subtitle("(In Billion USD 2015)") graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)40) note("Note: USD 2015 refers to USD at 2015 constant price ")

collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry
save "monetary_equiv_loss_regional.dta",replace


** By Income group
use "monetary_equiv_loss.dta",clear
drop if Country=="Belarus"
encode Incomegroup,gen(IncGr)
encode Country, gen(Cntry)
recode IncGr (1=1 "High Income")(2=2 "Low Income")(3/4=3 "Middle Income"),gen(IncG)
*collapse(sum)mel_cineff_bill mel_costineff dc7 nutilities (mean) cost_eff1 (count)Cntry, by(IncGr)
collapse(sum)mel_cineff_bill mel_costineff bdc7 nutilities (mean) cost_eff1 (count)Cntry, by(IncGr)

sort mel_costineff
graph hbar mel_cineff_bill, over(IncGr) blabel(total) title("Total loss due to cost inefficiency (2004-17)",size(medium)) subtitle("(In Billion USD 2015)") graphregion(fcolor(white)) plotregion(fcolor(white)) ytitle(Monetary value of loss) ylabel(0(20)60) note("Note: USD 2015 refers to USD at 2015 constant price")

save "monetary_equiv_loss_incgroup.dta",replace

codebook Country   //68 countries
**************************************************************************************************


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
****************************************************************************************************

use "efficiency.dta",clear
br Country Year  *eff1 if inlist(Country, "Bulgaria","Niger","Republic Of Kiribati","Guinea","Pakistan")
sort Country Year
merge Country Year using "wdi.dta", force
tab _merge
drop if _merge!=3
drop _merge
keep Country Year CountryCode Ucode cost_eff1 prod_eff1 s1 s2 s3 s4 s5 s6 s7 s8 *viability item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324 vae pve gee rqe rle cce s6_decile s3_decile

foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 ///
item320 item324{
	replace `x'=`x'/100
}
su

tsset Ucode Year
foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*	
	
foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*	

foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{
gen l1`x'=l1.`x'	
gen l2`x'=l2.`x'
gen l3`x'=l3.`x'
egen ma3_`x'=rowmean(l1`x' l2`x' l3`x')

replace `x'=ma3_`x' if `x'==.|`x'==0
}
drop l1* l2* l3* ma3*	

foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{

gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*
foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{

gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

foreach x in item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324{

gen f1`x'=f1.`x'	
gen f2`x'=f2.`x'
gen f3`x'=f3.`x'
egen maf3_`x'=rowmean(f1`x' f2`x' f3`x')

replace `x'=maf3_`x' if `x'==.|`x'==0
}
drop f1* f2* f3* maf3*

gen s73=s7/s3 
lab var s73 "Design capacity of water intake per unit population coverage"
gen s83=s8/s3 
lab var s83 "Length of network per unit population coverage"
gen s63=s6/s3 
lab var s63 "population served per unit population coverage"
gen s13=s1/s3 
lab var s13 "Gross fixed asset per unit population coverage"
gen s23=s2/s3
lab var s23 "new investment per unit population coverage"
su s*
save "finaleff.dta",replace

pwcorr item317 item318 item319 item320 item324,  star(.01) bonferroni

pwcorr *e ,  star(.01) bonferroni


** Mixed effect Tobit model
use "finaleff.dta",clear
dummies Country
dummies Year
dummies s4
dummies s3_decile
recode s4 (.=4 "Unidentified group")(0=4 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"),gen(service_prov_type)

gen size1=0 if inlist(s6_decile, 1,2,3)
replace size1=1 if inlist(s6_decile,4,5,6,7)
replace size1=2 if inlist(s6_decile,8,9,10)
recode size1 (0=0 "Small")(1=1 "Medium")(2=2 "Large"),gen(size)

replace s4=4 if s4==0|s4==.
tab s4,m
tab service_prov_type,m


order Country1-Country60 Year1-Year14
   xttobit cost_eff1 i.service_prov_type i.size s73 s83 s23 rqe rle item305 item309 item316 item317 item318 item319 ///
	  Year2-Year14 Country1-Country60, re ll(0) ul(1)
	outreg2 using "tobit_eff.xls", sideway noparen dec(3) replace label
	
	order Country1-Country60 Year1-Year14
   xttobit prod_eff1 i.service_prov_type i.size s73 s83 s23 rqe rle item305 item309 item316 item317 item318 item319 ///
	  Year2-Year14 Country1-Country60, re ll(0) ul(1)
	outreg2 using "tobit_eff.xls", sideway noparen dec(3) append label


	 xttobit cost_eff1 i.service_prov_type##i.size s73 s83 s23 rqe rle item305 item309 item316 item317 item318 item319 ///
	  Year2-Year14 Country1-Country60, re ll(0) ul(1)
	outreg2 using "tobit_eff.xls", sideway noparen dec(3) append label

	xttobit prod_eff1 i.service_prov_type##i.size s73 s83 s23 rqe rle  item305 item309 item316 item317 item318 item319 ///
	 Year2-Year14 Country1-Country60, re ll(0) ul(1)
	outreg2 using "tobit_eff.xls", sideway noparen dec(3) append label

d s42 s43 s41 s73 s83 s63 s13 s23 rqe rle viability item305 item309 item316 item317 item318 item319 ///
	 s3_decile2-s3_decile10

 