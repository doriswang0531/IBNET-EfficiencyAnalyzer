

*-------------------------------------------------------------------------------
*	IBNET UTILITIY EFFICIENCY PAPER (2023)
*	LAST MODIFIED BY QIAO
*	DATE: DEC 2023
*-------------------------------------------------------------------------------

clear all
set more off
capture log close

global project  "C:\Users\doris\OneDrive - UBC\Documents\Learning\WB\IBNET-EfficiencyAnalyzer"
global scripts 	"$project\scripts"
global figures 	"$project\figures"
global do		"$project\do"
global data 	"$project\data"

cd  "$data"

/* NOTE: DON'T RUN THIS PART, IT WILL GIVE A DIFFERENT IBNET3.dta

use "IBNET1.dta",clear  // Calling this data as created from IBNET_LONG.do above.

encode Utility,gen(Ucode)
tostring Ucode,gen(ID)
destring ID,replace
duplicates tag Ucode Year, gen(tag)
tab tag
//note: 6 duplicates
sort Ucode  Year 
list Ucode Year if tag==1
duplicates drop Ucode Year if tag>=1,force
tab Ucode, m nolab
keep if inrange(Year,2004,2017)


** Setting for panel data analysis. Giving variables easier names
tsset Ucode Year

	** Outputs
	ren	R_55_VOLUME_WATER_PRODUCED y1 
	label var y1 "R_55_VOLUME_WATER_PRODUCED"
		ren	R_90_TOTAL_OPERATING_REVENUE y2
		lab var y2 "R_90_TOTAL_OPERATING_REVENUE"
			ren	R_90C_TOTAL_WATER_OPERATING_REVE y3
			lab var y3 "R_90C_TOTAL_WATER_OPERATING_REVE"

	** Parameters such as depriciation exchange rate and Tariff
		ren	R_113_DEPRECIATION_FIXED_ASSETS  d1
		lab var d1 "R_113_DEPRECIATION_FIXED_ASSETS"
			ren	R_113A_DEPR_FIXED_ASSETS_WATER d2
			lab var d2 "R_113A_DEPR_FIXED_ASSETS_WATER"
				ren	R_6_EXCHANGE_RATE e1
				lab var e1 "R_6_EXCHANGE_RATE"
					ren	R_P7_FINAL_TARIFF t1
					lab var t1 "R_P7_FINAL_TARIFF"
	
	** Input quantity
				
							ren	R_121_STAFF_WOMEN x1
							lab var x1 "R_121_STAFF_WOMEN"
								ren	R_122_STAFF_WOMEN_ENGINEER x2
								lab var x2 "R_122_STAFF_WOMEN_ENGINEER"
									ren	R_30_01_TOTAL_ELECTRICITY_CONS x3
									lab var x3 "R_30_01_TOTAL_ELECTRICITY_CONS"
											ren	R_30_02_ELEC_CONS_WATER x4
											lab var x4 "R_30_02_ELEC_CONS_WATER"
											ren R_36_NUM_STAFF_TOTAL x5
											lab var x5 "R_36_NUM_STAFF_TOTAL"
	** Input Cost				
					ren	R_123_STAFF_WOMEN_COSTS c1
					lab var c1 "R_123_STAFF_WOMEN_COSTS"
						ren	R_150_CHEMICAL_COSTS c2
						lab var c2 "R_150_CHEMICAL_COSTS"
							ren	R_97_ELECTRICAL_ENERGY_COSTS c3
							lab var c3 "R_97_ELECTRICAL_ENERGY_COSTS"
								ren	R_98_REPAIR_MAINTENANCE_COSTS c4
								lab var c4 "R_98_REPAIR_MAINTENANCE_COSTS"
									ren	R_99_CONTRACTED_SERVICES_COSTS c5
									lab var c5 "R_99_CONTRACTED_SERVICES_COSTS"
										ren	R_151_OTHER_COSTS c6
										lab var c6 "R_151_OTHER_COSTS"
											ren	R_94_TOTAL_OPERATING_EXPENSES	c7			
											lab var c7 "R_94_TOTAL_OPERATING_EXPENSES"
												ren	R_94A_TOTAL_WATER_OPERATING_EXPE c8
												lab var c8 "R_94A_TOTAL_WATER_OPERATING_EXPE"

                                                     ren R_96_LABOR_COSTS c9
													 lab var c9 "R_96_LABOR_COSTS"
													 
 ** System level information
 
 ren R_112_TOTAL_GROSS_FIXED_ASSETS s1
 lab var s1 "R_112_TOTAL_GROSS_FIXED_ASSETS"
	ren R_115_NEW_INVESTMENTS s2
	lab var s2 "R_115_NEW_INVESTMENTS"
		ren R_30_TOTAL_POP_WATER_SUPPLY s3
		lab var s3 "R_30_TOTAL_POP_WATER_SUPPLY"
			ren R_3A_TYPE_OF_SERVICE_PROVIDER  s4
			lab var s4 "R_3A_TYPE_OF_SERVICE_PROVIDER"
				ren R_3B_UTILITY_OWNERSHIP s5
				lab var s5 "R_3B_UTILITY_OWNERSHIP"
					ren R_40_POP_SERVED_WATER s6
					lab var s6 "R_40_POP_SERVED_WATER"
						ren  R_42_DESIGN_CAPACITY_WATER_INTAK s7
						lab var s7 "R_42_DESIGN_CAPACITY_WATER_INTAK"
							ren  R_54_LENGTH_WATER_DIST_NETWORK s8
							lab var s8 "R_54_LENGTH_WATER_DIST_NETWORK"
sort Country Ucode Year												
save "IBNET2.dta",replace

** Finding out missing values and available data for each variable
//note: eligible utilities with at least 7 available data points for water production or operating cost
use "IBNET2.dta",clear
foreach x in y1 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s4 s5 s6 s7 s8{
gen m`x'=`x'/`x'	
	egen tot_m`x'=total(m`x'),by(Ucode)
}

collapse(mean) tot_m*, by(Country Ucode) // this line of code was to check the data and missing values 

keep if tot_my1>=7 & tot_mc7>=7
keep Country Ucode tot_my1
sort Country Ucode
save "eligible_utilities.dta",replace

use "IBNET2.dta",clear
merge m:1 Country Ucode using "eligible_utilities.dta" // This line of code is to identify utilities with 7 or more observations
tab _merge
drop if _merge!=3
drop _merge
sort Country Year
merge Country Year using "PPP_def.dta" 
tab _merge
keep if _merge==3
keep Country Ucode ID Utility Year y1 y2 y3 x1 x2 x3 x4 x5 c1 c2 c3 c4 c5 c6 c7 c8 c9 e1 t1 s1 s2 s3 s4 s5 s6 s7 s8 PPP_def LCPPP PPP17toUSD15 PPP2US15
*replace s4=. if s4==0
sort Ucode Year

codebook Ucode
save "IBNET3.dta",replace  
*/


**# PART I: DATA SELECTION AND PREPARATION 

*	DATA CLEANING
use "IBNET3.dta",clear
gen time=Year-2003
gen vy1=t1*y1	//tariff * water production

egen c23459=rowtotal(c2 c3 c4 c5 c9)	//total operating cost
replace c6=c7-c23459 if c6==.
replace c6=. if c6<0

*	replace zero with missing
global numeric  s1 s2 x1 x2 c1 c2 c6 x3 x4 s3 x5 s6 s7 s8 y1 e1 y2 y3 c7 c8 c9 c3 c4 c5
foreach x in $numeric {
	replace `x'=. if `x'==0
}


*	flag out values with wrong scale and replace with median
foreach var in $numeric  {
	gen log_`var' = log10(`var')
	bysort Ucode: egen median_`var' = median(`var')
	bysort Ucode: egen median_log_`var' = median(log_`var')
	replace `var' = median_`var' if log_`var' < median_log_`var' - 1
	replace `var' = median_`var' if log_`var' > median_log_`var' + 1 & log_`var' !=.
}
cap drop median_* log_*

*	deflating
tsset Ucode Year
sort Country Ucode Year
global monetary		vy1 s1 s2 c2 c6 y2 c7 c8 c9 c3 c4 c5

foreach x in $monetary	{
*egen m`x'=mean(`x'),by(Year s4 s6_decile)
	*replace `x'=m`x' if `x'==.|`x'==0
	gen d`x'=(`x'*PPP_def)/LCPPP
	lab var d`x' "Cost `x' in PPP at 2017 Constant Int. dollars"
		gen ld`x'=log10(d`x')
		lab var ld`x' "Log10 of Cost `x' in PPP at 2017 Constant Int. dollars"
}




*	fill out missing for utility ownership and type of service provider
gen int negyear = -Year
gen s4a=s4
gen s5a=s5
foreach x in  s4 s5 {
	
bysort Ucode (negyear): carryforward `x' if `x'==., replace
bysort Ucode (Year): carryforward `x' if `x'==., replace
	
}

drop negyear s4a s5a 
sort Country Year
sort ID Year

*	generate decile using populatoion served
bysort Ucode: egen median_pop = median(s6)

xtile s6_decile = s6, nq(10)
gen ID1 = Year * 100 + s6_decile
drop if ID1 == .

preserve
keep ID ID1 Year dc3 dc4 dc5 dc7 dc8 dc9 y1 y2 y3 s1 s3 s4 s5 s6 s6_decile s8 t1 t2 t3 t4 t5

save "IBNET3a4py.dta",replace
restore

*	PRELIMINARY EDA
* Loop over the variables and create kdensity plots
foreach var in $monetary {
    local varlabel : variable label `var'

    twoway (kdensity ld`var' if s6_decile == 1, lcolor(blue)) ///
           (kdensity ld`var' if s6_decile == 2, lcolor(green)) ///
           (kdensity ld`var' if s6_decile == 3, lcolor(red)) ///
           (kdensity ld`var' if s6_decile == 4, lcolor(purple)) ///
           (kdensity ld`var' if s6_decile == 5, lcolor(orange)) ///
           (kdensity ld`var' if s6_decile == 6, lcolor(pink)) ///
           (kdensity ld`var' if s6_decile == 7, lcolor(maroon)) ///
           (kdensity ld`var' if s6_decile == 8, lcolor(lightblue)) ///
           (kdensity ld`var' if s6_decile == 9, lcolor(gold)) ///
           (kdensity ld`var' if s6_decile == 10, lcolor(gray)), ///
           legend(size(small) label(1 "Decile 1") label(2 "Decile 2") /// 
                  label(3 "Decile 3") label(4 "Decile 4") ///
                  label(5 "Decile 5") label(6 "Decile 6") ///
                  label(7 "Decile 7") label(8 "Decile 8") ///
                  label(9 "Decile 9") label(10 "Decile 10")) 	///
           title("Kernel Density of `var' (`varlabel') by s6_decile", size(small))
    graph export "$figures\\`var'_kdensity.png", replace
}


**# PART II: MISSING VALUE IMPUTATION USING PYTHON
*shell "C:/Users/doris/miniconda3/envs/ibnet/python.exe" "c:/Users/doris/OneDrive - UBC/Documents/Learning/WB/IBNET-EfficiencyAnalyzer/scripts/ibnet_missing_value_imputation.py"

