cd "C:\Users\wb450887\WBG\George Joseph - 10_Pulbic Expenditure Review\102_ Syntheis Report\Working Folders\Qiao\basab\Basab Data and Dofiles\Data_files\All data files"

use "efficiency.dta",clear
*	find the mode
gen cost_mode=round(cost_eff1, 0.01)
tab cost_mode

gen prod_mode=round(prod_eff1, 0.01)
tab prod_mode

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
recode s4 (0=0 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"),gen(service_prov_type)

drop if size==.
drop if s4==.

sum bdc7, detail
//note: drop 99th outliers
drop if bdc7>1.18

** Collapsing by country for all 14 years and all available utilities
collapse(sum) mel_cineff_bill mel_costineff bdc7 (mean) cost_eff1 (count)Ucode, by(Country Region Incomegroup size s4)
gen nutilities=round(Ucode/14)
replace mel_cineff_bill = mel_cineff_bill/14
replace bdc7 = bdc7/14
lab var nutilities "Number of utilities for each country"
drop Ucode
save "monetary_equiv_loss.dta", replace


*	Graphs by regions and income groups
*	Pooled average across years
use "monetary_equiv_loss.dta",clear
encode Region,gen(Reg)
encode Country, gen(Cntry)
recode s4 (0=0 "Unidentified group")(1=1 "Municipal")(2=2 "Regional")(3=3 "National"),gen(service_prov_type)
keep mel_cineff_bill bdc7 cost_eff1 nutilities Country Region Incomegroup size s4 service_prov_type


tabstat nutilities, stats(sum) by(Region)
tabstat nutilities, stats(sum) by(size)
tabstat nutilities, stats(sum) by(Incomegroup)
tabstat nutilities, stats(sum) by(service_prov_type)


*	by region and size
table ( size ) () ( Region ), statistic(mean mel_cineff_bill bdc7 cost_eff) statistic(total  nutilities)
*	by income group and size
table ( size ) () ( Incomegroup ), statistic(mean mel_cineff_bill bdc7 cost_eff) statistic(total  nutilities)
*	by ownership and size
table ( size ) () ( service_prov_type ), statistic(mean mel_cineff_bill bdc7 cost_eff) statistic(total  nutilities)





*	Determinants of efficiency
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
keep Country Year CountryCode Ucode cost_eff1 prod_eff1 s1 s2 s3 s4 s5 s6 s7 s8 item303 item304 item305 item306 item308 item309 item313 item315 item316 item317 item318 item319 item320 item324 vae pve gee rqe rle cce s6_decile s3_decile

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

d s42 s43 s41 s73 s83 s63 s13 s23 rqe rle  item305 item309 item316 item317 item318 item319 ///
	 s3_decile2-s3_decile10
