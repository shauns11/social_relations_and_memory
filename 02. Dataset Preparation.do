*==========================================================================.
*Do-file for global support/strain.
*This file must be run before separate do-files for each relationship type
*as it creates the dataset for those analyses.
*==========================================================================.

*Datasets required:
*"h_elsa.dta"
*"index_file_wave_0-wave_5_v2.dta"
*"Wave_1_Financial_Derived_Variables.dta"
*"wave_1_core_data_v3.dta"
*"wave_2_financial_derived_variables.dta"
*"wave_2_core_data_v4.dta"
*"wave_3_financial_derived_variables.dta"
*"wave_3_elsa_data_v4.dta"
*"wave_4_ifs_derived_variables.dta"
*"wave_4_financial_derived_variables.dta"
*"wave_4_elsa_data_v3.dta"
*"wave_5_financial_derived_variables.dta"
*"wave_5_elsa_data_v4.dta"
*"wave_6_financial_derived_variables.dta"
*"wave_6_elsa_data_v2.dta"
*"wave_7_financial_derived_variables.dta"
*"wave_7_elsa_data.dta", clear
*"wave_8_elsa_financial_dvs_eul_v1.dta"
*"wave_8_elsa_data_eul_v2.dta", clear

clear
cd C:\ELSA\Datasets

*===============================.
*Harmonised datasets with HRB.
*===============================.

use "h_elsa.dta", clear
keep idauniq r1smoken r1drink r1vgactx_e r1mdactx_e r1ltactx_e
sort idauniq
save "C:/Temp/W1_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r2smoken r2drink r2vgactx_e r2mdactx_e r2ltactx_e
sort idauniq
save "C:/Temp/W2_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r3smoken r3drink r3vgactx_e r3mdactx_e r3ltactx_e
sort idauniq
save "C:/Temp/W3_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r4smoken r4drink r4vgactx_e r4mdactx_e r4ltactx_e
sort idauniq
save "C:/Temp/W4_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r5smoken r5drink r5vgactx_e r5mdactx_e r5ltactx_e
sort idauniq
save "C:/Temp/W5_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r6smoken r6drink r6vgactx_e r6mdactx_e r6ltactx_e
sort idauniq
save "C:/Temp/W6_HRBs.dta",replace

use "h_elsa.dta", clear
keep idauniq r7smoken r7drink r7vgactx_e r7mdactx_e r7ltactx_e
sort idauniq
save "C:/Temp/W7_HRBs.dta",replace

*=========================================================================.
*Mortality information for joint modelling of longitudinal & survival data.
*Month and year of death.
*===========================================================================.

use "C:/ELSA/Datasets/h_elsa.dta", clear
keep idauniq radyear r1cwtresp 
keep if r1cwtresp>0 & r1cwtresp!=. 
tab radyear                            /* Year of Death */
gen dead=0
replace dead=1 if inlist(radyear,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012)
tab1 dead
gen deadm=.
gen deady=.
replace deadm=12 if (dead==1)           /* at the end of year in case interviewed earlier that year */
replace deady=radyear if (dead==1)

*manual recodes: death = 1 month after interview.
list deadm deady if idauniq==120425
replace deadm=1 if  idauniq==120425
replace deady=2005 if  idauniq==120425

*death: 1 month after W3 interview.
list deadm deady if idauniq==111294
replace deadm=1 if  idauniq==111294
replace deady=2009 if idauniq==111294    

*death: 1 month after W5 interview.
list deadm deady if idauniq==108676
replace deadm=1 if  idauniq==108676
replace deady=2011 if idauniq==108676 

keep idauniq dead deadm deady radyear
sort idauniq
save "C:/Temp/Year_of_death.dta",replace

*======================.
*Main analysis file.
*======================.

*Index File.

use "index_file_wave_0-wave_5_v2.dta", clear
keep idauniq yrdeath mortstat mortwave outscw1 outscw2 outscw3 outscw4 outscw5
sort idauniq
save "C:/Temp/IndexFile.dta", replace

use "index_file_wave_0-wave_5_v2.dta", clear
keep idauniq outscw1 
sort idauniq
save "C:/Temp/outscw1.dta", replace


*=====================.
*Wave 1 (baseline).
*=====================.

* Wealth quintile.

use idauniq idahhw1 tnhwq5_bu_s tnhwq10_bu_s using "Wave_1_Financial_Derived_Variables.dta", clear
sort idahhw1
tab tnhwq10_bu_s tnhwq5_bu_s
collapse (mean) tnhwq5_bu_s,by(idahhw1)
replace tnhwq5_bu_s = round(tnhwq5_bu_s,1)
tab1 tnhwq5_bu_s
sort idahhw1
save "C:/Temp/W1_Wealthq.dta",replace

*Main file.

clear
use idauniq idahhw1 indsex finstat edqual cf* w1wgt askpx nmissed nrowclm dhager psc* headb01-headb13 sc* hedib01-hedib10 heska heacta heactb heactc hesmk heska heala dimar couple1 iintdtm iintdty using "wave_1_core_data_v3.dta"
renvars, lower
rename iintdtm iintdtm0
rename iintdty iintdty0 
summ w1wgt if w1wgt>0
keep if inrange(w1wgt,0.2,8.9)  /* N=11,391 core members */

sort idahhw1
merge n:1 idahhw1 using "C:/Temp/W1_Wealthq.dta"
keep if _merge==3
drop _merge
merge 1:1 idauniq using "C:/Temp/outscw1.dta"
keep if _merge==3
drop _merge

tab1 headb01           /* Difficulties */
tab1 hedib01           /* Diagnosed conditions */
tab1 couple1
rename couple1 couple0

generate ProblemsW0=0
replace ProblemsW0=1 if inrange(headb01,1,13)
tab1 ProblemsW0

generate DiagnosedW0=0
replace DiagnosedW0=1 if inrange(headb01,1,9)
tab1 DiagnosedW0

keep idauniq indsex dimar couple0 scptrg w1wgt edqual askpx tnhwq5_bu_s dhager cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headb01-headb13 hedib01-hedib10 scptr scchd scfrd scfam scptra scptrb scptrc scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
hesmk heska heacta heactb heactc heala scorg1 scorga2 scorg3 scorg4 scorg5 scorg6 scorg7 scorg8 ProblemsW0 DiagnosedW0 outscw1 iintdtm0 iintdty0 
rename scorga2 scorg2

order idauniq indsex dimar couple0 scptrg w1wgt edqual askpx tnhwq5_bu_s  dhager cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headb01-headb13 hedib01-hedib10 scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
hesmk heska heacta heactb heactc heala scorg1 scorg2 scorg3 scorg4 scorg5 scorg6 scorg7 scorg8 ProblemsW0 DiagnosedW0 outscw1 iintdtm0 iintdty0 

merge 1:1 idauniq using "C:/Temp/W1_HRBs.dta"
keep if _merge==3
drop _merge
mvdecode _all, mv(-90/-1)

*==============.
*Demographics.
*==============.

tab1 dimar couple0

*==================.
*Analytical sample.
*==================.

*Dementia cases (N = 126).
*Proxy (n=130).
*Age (90+: n=99).

egen dementia = anycount(hedib01-hedib10),values(6 8 9)
recode dementia (2=1)
tab1 dementia
drop if dementia==1                      /* Drop dementia cases (N = 126)  */
drop if askpx==1                         /* Drop proxies (N = 130)  */
count
drop if inrange(dhager,90,99)
count                                     /* N = 11,036 */


*======================================.
* Currently smokes. (cigarettes only).
*=======================================.

generate smoke0=.
replace smoke0=1 if hesmk==2
replace smoke0=2 if (hesmk==1 & heska==2)
replace smoke0=3 if (hesmk==1 & heska==1)
tab1 smoke0, missing 				    
tab smoke0 r1smoken  /* compare with harmonised data */
recode smoke0 (1=0) (2=0) (3=1)
label define smoke0lbl 0 "non-smoker" 1 "current smoker"  
label values smoke0 smoke0lbl
tab1 smoke0

*==========.
* Alcohol.
*==========.

tab heala           /*in the last 12 months*/

*generate drink1=.
*replace drink1 = 0 if inlist(heala,3,4,5,6)
*replace drink1 = 1 if inlist(heala,1,2)
*tab drink1 r1drink  /* compare with harmonised data */
*label define dlbl 0 "non-daily" 1 "daily" 
*label values drink1 dlbl
*tab1 drink1

tab1 r1drink        /*ever drinks alcohol (harmonised data) */
rename r1drink drink0
tab1 drink0

*====================.
* Physical activity.
*====================.

generate actlevel0=.
replace actlevel0=1 if (r1vgactx_e==5) & (r1mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel0=2 if (r1vgactx_e==5) & inlist(r1mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel0=3 if ((r1mdactx_e==2) & r1vgactx_e==5)|(r1vgactx_e==4 & r1mdactx_e==5)   																		/* some mod or vig */
replace actlevel0=4 if (inlist(r1mdactx_e,2,3) & inlist(r1vgactx_e,3,4))| inlist(r1mdactx_e,4,5) & inlist(r1vgactx_e,3) | inlist(r1mdactx_e,4) & inlist(r1vgactx_e,4)  					 /* more mod or vig */
replace actlevel0=5 if inlist(r1vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel0, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel0 actlbl

*Dichotomous (actlevel1): inactive vs rest.

recode actlevel0 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel0 actlbl
tab1 actlevel0

*=========================.
* Educational attainment.
*=========================.

generate topqual=.
replace topqual=1 if edqual==1
replace topqual=2 if inrange(edqual,2,3)
replace topqual=3 if edqual==4
replace topqual=4 if inrange(edqual,5,6)
replace topqual=5 if edqual==7
label define blbl 1 "Degree or equivalent" 2 "A level/higher education below degree" 3 "O level or other" 4 "CSE or other" 5 "No qualifications" 
label values topqual blbl
tab1 topqual, missing

*High/middle/low.

recode topqual (1=0) (2/4=1) (5=2)
label define b2lbl 0 "high" 1 "middle" 2 "low"  
label values topqual b2lbl
tab1 topqual, missing

*===================.
*Weath quintile.
*===================.

rename tnhwq5_bu_s wealthq0
tab1 wealthq0, missing

recode wealthq0 (1=5) (2=4) (3=3) (4=2) (5=1)

label define wlbl 1 "Highest" 2 "2" 3 "3" 4 "4" 5 "lowest"
label values wealthq0 wlbl
tab1 wealthq0

*===================.
*Age.
*===================.

generate age0 = dhager
generate agegroup=0
replace agegroup=1 if inrange(dhager,50,54)
replace agegroup=2 if inrange(dhager,55,59)
replace agegroup=3 if inrange(dhager,60,64)
replace agegroup=4 if inrange(dhager,65,69)
replace agegroup=5 if inrange(dhager,70,74)
replace agegroup=6 if inrange(dhager,75,79)
replace agegroup=7 if inrange(dhager,80,89)
label define albl 1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75-79" 7 "80-89" 
label values agegroup albl
tab1 agegroup

*====================================.
*CESD (number of depressive symptoms.
*====================================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD0 = c
tab CESD0

*====================================.
*ADL & iADL.
*====================================.

tab1 headb01-headb10

egen z1 = anycount(headb01-headb10),values(1)
egen z2 = anycount(headb01-headb10),values(2)
egen z3 = anycount(headb01-headb10),values(3)
egen z4 = anycount(headb01-headb10),values(4)
egen z5 = anycount(headb01-headb10),values(5)
egen z6 = anycount(headb01-headb10),values(6)

egen ADL0 = rsum(z1-z6) if headb01!=.    /* 11,121   */
tab1 ADL0

*iADL.

drop z1-z6

egen z1 = anycount(headb01-headb13),values(7)
egen z2 = anycount(headb01-headb13),values(8)
egen z3 = anycount(headb01-headb13),values(9)
egen z4 = anycount(headb01-headb13),values(10)
egen z5 = anycount(headb01-headb13),values(11)
egen z6 = anycount(headb01-headb13),values(12)
egen z7 = anycount(headb01-headb13),values(13)

egen iADL0 = rsum(z1-z7)  if headb01!=.    /* 11,121   */
tab1 iADL0

*====================================.
*Positive (social support)
*Negative (social strain)
*====================================.

*=======.
*Spouse.
*========.

*How close is your relationship with your spouse or partner?

rename scptrg scptrg0
tab1 scptrg0

*do you have a husband or wife or partner with whom you live (self-reported).

count if (scptr==2)   /* 2824 */

*IF has a husband, wife or partner with whom they live: Scptr = 1
*how much can you rely on your spouse/partner if you have a serious problem?
*but not restricted to married.

preserve
drop s
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /* 7194 */
count if inlist(s2,0,1,2)     /* 7185 */
restore

di 2869+7194   /* 10 063 */
di 2869+7185   /* 10 054 */

* Spouse.
* Positive (Spouse).

tab1 scptra          /* understand */
tab1 scptrb         /* rely on */
tab1 scptrc         /* open up  */

recode scptra (1=3) (2=2) (3=1) (4=0)           /* positive views to high scores */
recode scptrb (1=3) (2=2) (3=1) (4=0) 			/* positive views to high scores */
recode scptrc (1=3) (2=2) (3=1) (4=0) 		 /* positive views to high scores */

* Negative (Spouse).

tab1 scptrd                      /* criticise */
tab1 scptre                     /* let you down */
tab1 scptrf                     /* get on nerves */

recode scptrd (1=3) (2=2) (3=1) (4=0)           		/* negative views to high scores */
recode scptre (1=3) (2=2) (3=1) (4=0) 					/* negative views to high scores */
recode scptrf (1=3) (2=2) (3=1) (4=0) 					/* negative views to high scores */

egen PS_Spouse0 = rowmean(scptra scptrb scptrc)      /* mean of available items */
egen NS_Spouse0 = rowmean(scptrd scptre scptrf)      /* mean of available items */
summ PS_Spouse0 NS_Spouse0

* recode no spouse to zero.
* No positive support/no negative support.

replace PS_Spouse0=0 if (scptr==2)
replace NS_Spouse0=0 if (scptr==2)

label variable PS_Spouse0 "Support (spouse)"
label variable NS_Spouse0 "Strain (spouse)"
summ PS_Spouse0 NS_Spouse0

*==========.
*Children.
*==========.

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 1301 */

preserve
drop s
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 7194 */
count if inlist(s2,0,1,2)     /* 7185 */
restore

di 1301+8764  /* 10 065 */
di 1301+8752   /* 10 053 */

* Positive.

tab1 scchd scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child0 = rowmean(scchda scchdb scchdc)
egen NS_Child0 = rowmean(scchdd scchde scchdf) 

* recode no children to zero.

replace PS_Child0=0 if scchd==2
replace NS_Child0=0 if scchd==2
  
label variable PS_Child0 "Support (children)"
label variable NS_Child0 "Strain (children)"
summ PS_Child0 NS_Child0

*=================.
*Friends.
*=================.

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 542 */

preserve
drop s
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 9280 */
count if inlist(s2,0,1,2)     /* 9224 */
restore

di 542+9280  /* 9822 */
di 542+9224   /* 9766 */

* Positive.

tab1 scfrd scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend0 = rowmean(scfrda scfrdb scfrdc)
egen NS_Friend0 = rowmean(scfrdd scfrde scfrdf)

* recode no friends to zero.

replace PS_Friend0=0 if scfrd==2
replace NS_Friend0=0 if scfrd==2

label variable PS_Friend0 "Support (friends)"
label variable NS_Friend0 "Strain (friends)"
summ PS_Friend0 NS_Friend0

*===============.
*Family.
*===============.

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 820 */

preserve
drop s
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 8932 */
count if inlist(s2,0,1,2)     /* 8851 */
restore

di 820+8932  /* 9752 */
di 820+8851   /* 9671 */

* Positive.

tab1 scfam scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family0 = rowmean(scfama scfamb scfamc) 
egen NS_Family0 = rowmean(scfamd scfame scfamf)

* recode no immediate family members to zero.

replace PS_Family0=0 if scfam==2
replace NS_Family0=0 if scfam==2

label variable PS_Family0 "Support (family)"
label variable NS_Family0 "Strain (family)"
summ PS_Family0 NS_Family0

*==================.
*Global scores
*==================.

egen PSall0 = rowmean(PS_Spouse0 PS_Child0 PS_Friend0 PS_Family0)
egen NSall0 = rowmean(NS_Spouse0 NS_Child0 NS_Friend0 NS_Family0)

label variable PSall0 "Positive support from spouse, children, family, friends"
label variable NSall0 "Negative support from spouse, children, family, friends"
summ PSall0 NSall0

tab1 scptr, nolabel
generate spouse0=.
replace spouse0=0 if scptr==2
replace spouse0=1 if scptr==1
tab1 spouse0

tab1 scchd, nolabel
generate child0=.
replace child0=0 if scchd==2
replace child0=1 if scchd==1
tab1 child0

tab1 scfrd, nolabel
generate friend0=.
replace friend0=0 if scfrd==2
replace friend0=1 if scfrd==1
tab1 friend0

tab1 scfam, nolabel
generate family0=.
replace family0=0 if scfam==2
replace family0=1 if scfam==1
tab1 family0

*==============================.
*Social Participation (9745).
*People miss all items.
*=============================.

summ scorg1 scorg2 scorg3 scorg4 scorg5 scorg6 scorg7 scorg8

egen sp = rowmiss(scorg1 scorg2 scorg3 scorg4 scorg5 scorg6 scorg7 scorg8)
tab sp

generate SPart0 = (scorg1 + scorg2 + scorg3 + scorg4 + scorg5 + scorg6 + scorg7 + scorg8) if sp==0
label variable SPart0 "Social participation at Wave 1"
summ SPart0
tab1 SPart0

*=====================.
*Rename memory scores.
*=====================.

rename cflisen cflisen0
rename cflisd cflisd0
summ cflisen0 cflisd0 

generate wave0=1
tab1 indsex agegroup wealthq0 CESD0 ADL0 iADL0 PSall0 NSall0, missing

generate sc_outcome0=0
replace sc_outcome0=1 if outscw1==1
tab1 sc_outcome0

*N in file = 11,036.
count if (sc_outcome0==1) & (cflisen0!=.) & (cflisd0!=.)  /*N=10,109*/

keep idauniq indsex wave0 cflisen0 cflisd0 w1wgt age0 CESD0 ADL0 iADL0 wealthq0 askpx ///
PSall0 NSall0 scptrg0 PS_Spouse0 NS_Spouse0 PS_Child0 NS_Child0 PS_Friend0 NS_Friend0 PS_Family0 NS_Family0 ///
spouse0 child0 friend0 family0 ///
topqual smoke0 drink0 actlevel0 SPart0 couple0 ProblemsW0 DiagnosedW0 sc_outcome0 iintdtm0 iintdty0 
save "C:/Temp/Wave0DVs.dta", replace


*=========.
*Wave 2.
*=========.

use idauniq tnhwq5_bu_s using "wave_2_financial_derived_variables.dta", clear
sort idauniq
save "C:/Temp/Tempa.dta",replace

* Wave 2.

clear
use idauniq DiMar couple scptrg dhager finstat He* indsex w2wgt askpx outscw2 C* n* P* headb01-headb13 iintdtm iintdty sc* using "wave_2_core_data_v4.dta"
renvars,lower
rename iintdtm iintdtm1
rename iintdty iintdty1
rename dhager age1
summ w2wgt
keep if inrange(w2wgt,0.02,10)
keep if finstat=="C1CM"
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
count
drop if askpx==1
count     /* 8688   */

generate sc_outcome1=0
replace sc_outcome1=1 if inrange(scw2wgt,0.5,4.2)
tab1 sc_outcome1

keep idauniq dimar couple scptrg tnhwq5_bu age1 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headb01-headb13 scptr scchd scfrd scfam scptra scptrb scptrc scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scako scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome1 iintdtm1 iintdty1

merge 1:1 idauniq using "C:/Temp/W2_HRBs.dta"
keep if _merge==3
drop _merge

mvdecode _all, mv(-90/-1)

tab1 dimar couple

rename tnhwq5_bu wealthq1

*========================.
*ADL & iADL.
*========================.

tab1 headb01-headb10

egen z1 = anycount(headb01-headb10),values(1)
egen z2 = anycount(headb01-headb10),values(2)
egen z3 = anycount(headb01-headb10),values(3)
egen z4 = anycount(headb01-headb10),values(4)
egen z5 = anycount(headb01-headb10),values(5)
egen z6 = anycount(headb01-headb10),values(6)

egen ADL1 = rsum(z1-z6) if headb01!=.    
tab1 ADL1

*========================.
* Currently smokes. (cigarettes only).
*========================.

tab1 r2smoken                   /* use harmonised data */
generate smoke1=r2smoken
label define smoke2lbl 0 "non-smoker" 1 "current smoker"  
label values smoke1 smoke2lbl
tab1 smoke1

*========================.
* Drink.
*========================.

tab1 r2drink                /*ever drinks alcohol (harmonised data) */
rename r2drink drink1
tab1 drink1

*========================.
* Physical activity.
*========================.

generate actlevel1=.
replace actlevel1=1 if (r2vgactx_e==5) & (r2mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel1=2 if (r2vgactx_e==5) & inlist(r2mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel1=3 if ((r2mdactx_e==2) & r2vgactx_e==5)|(r2vgactx_e==4 & r2mdactx_e==5)   																		/* some mod or vig */
replace actlevel1=4 if (inlist(r2mdactx_e,2,3) & inlist(r2vgactx_e,3,4))| inlist(r2mdactx_e,4,5) & inlist(r2vgactx_e,3) | inlist(r2mdactx_e,4) & inlist(r2vgactx_e,4)  					 /* more mod or vig */
replace actlevel1=5 if inlist(r2vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel1, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel1 actlbl

*Dichotomous (actlevel2): inactive vs rest.

recode actlevel1 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel1 actlbl
tab1 actlevel1

*========================.
*CESD (number of depressive symptoms.
*========================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD1 = c
tab CESD1

* word recall: cflisen (immediate)
* word recall: cflisd (delayed)

summ cflisen 
summ cflisd

generate wave1=1

*========================.
*Social relationships.
*========================.

* Spouse.
* how close is your relationship.

tab1 scptrg
rename scptrg scptrg1
tab1 scptrg1

count if (scptr==2)   /* 2175 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /* 5399 */
count if inlist(s2,0,1,2)     /* 5391 */
restore

di 2175+5399   /* 7574 */
di 2175+5391   /* 7566 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse1 = rowmean(scptra scptrb scptrc)
egen NS_Spouse1 = rowmean(scptrd scptre scptrf)

* recode no spouse to zero.

replace PS_Spouse1=0 if scptr==2
replace NS_Spouse1=0 if scptr==2

label variable PS_Spouse1 "Support (spouse)"
label variable NS_Spouse1 "Strain (spouse)"
summ PS_Spouse1 NS_Spouse1

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 923 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 6658 */
count if inlist(s2,0,1,2)     /* 6643 */
restore

di 923+6658  /* 7581 */
di 923+6643   /* 7566 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child1 = rowmean(scchda scchdb scchdc) 
egen NS_Child1 = rowmean(scchdd scchde scchdf)

* recode no children to zero.

replace PS_Child1=0 if scchd==2
replace NS_Child1=0 if scchd==2

label variable PS_Child1 "Support (children)"
label variable NS_Child1 "Strain (children)"

summ PS_Child1 NS_Child1

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 373 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 7273 */
count if inlist(s2,0,1,2)     /* 7234 */
restore

di 373+7273  /* 7646 */
di 373+7234   /* 7607 */

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend1 = rowmean(scfrda scfrdb scfrdc) 
egen NS_Friend1 = rowmean(scfrdd scfrde scfrdf)

* recode no friends to zero.

replace PS_Friend1=0 if scfrd==2
replace NS_Friend1=0 if scfrd==2

label variable PS_Friend1 "Support (friends)"
label variable NS_Friend1 "Strain (friends)"
summ PS_Friend1 NS_Friend1

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 586 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 6990 */
count if inlist(s2,0,1,2)     /* 6945 */
restore

di 586+6990  /* 7576 */
di 586+6945   /* 7531 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family1 = rowmean(scfama scfamb scfamc) 
egen NS_Family1 = rowmean(scfamd scfame scfamf)

* recode no family to zero.

replace PS_Family1=0 if scfam==2
replace NS_Family1=0 if scfam==2

label variable PS_Family1 "Support (family)"
label variable NS_Family1 "Strain (family)"
summ PS_Family1 NS_Family1

* Overall summary.

egen PSall1 = rowmean(PS_Spouse1 PS_Child1 PS_Friend1 PS_Family1) 
egen NSall1 = rowmean(NS_Spouse1 NS_Child1 NS_Friend1 NS_Family1)

label variable PSall1 "Positive support from spouse, children, family, friends"
label variable NSall1 "Negative support from spouse, children, family, friends"

rename cflisen cflisen1
rename cflisd cflisd1

tab1 scptr, nolabel
generate spouse1=.
replace spouse1=0 if scptr==2
replace spouse1=1 if scptr==1
tab1 spouse1

tab1 scchd, nolabel
generate child1=.
replace child1=0 if scchd==2
replace child1=1 if scchd==1
tab1 child1

tab1 scfrd, nolabel
generate friend1=.
replace friend1=0 if scfrd==2
replace friend1=1 if scfrd==1
tab1 friend1

tab1 scfam, nolabel
generate family1=.
replace family1=0 if scfam==2
replace family1=1 if scfam==1
tab1 family1

*=====================.
*Social Participation.
*======================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart1 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart1 "Social participation at Wave 1"
summ SPart1
tab1 SPart1

summ age1 cflisen1 cflisd1 wealthq1 ///
PSall1 NSall1 PS_Spouse1 NS_Spouse1 PS_Child1 NS_Child1 PS_Friend1 NS_Friend1 PS_Family1 NS_Family1

rename couple couple1 

*N in file = 8,688.

keep idauniq wave1 age1 cflisen1 cflisd1 wealthq1 smoke1 drink1 actlevel1 ADL1 CESD1 ///
PSall1 NSall1 scptrg1 PS_Spouse1 NS_Spouse1 PS_Child1 NS_Child1 PS_Friend1 NS_Friend1 PS_Family1 NS_Family1 ///
spouse1 child1 friend1 family1 SPart1 couple1 sc_outcome1 iintdtm1 iintdty1
save "C:/Temp/Wave1DVs.dta", replace


*===============.
*ELSA Wave 3.
*===============.

clear
use idauniq tnhwq5_bu_s using "wave_3_financial_derived_variables.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

clear
use  idauniq dimar couple dhager scptrg finstat indsex askpx w3lwgt sc* c* n* outscw3 psc* he* sc* iintdatm iintdaty using "wave_3_elsa_data_v4.dta"
renvars,lower
rename iintdatm iintdtm2
rename iintdaty iintdty2
rename dhager age2
keep if finstat=="C1CM"
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
count
drop if askpx==1
count    /* 7382 */

generate sc_outcome2=0
replace sc_outcome2=1 if outscw3==1
tab1 sc_outcome2

keep idauniq dimar couple scptrg askpx tnhwq5_bu age2 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlph headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome2 iintdtm2 iintdty2
 
merge 1:1 idauniq using "C:/Temp/W3_HRBs.dta"
keep if _merge==3
drop _merge

mvdecode _all, mv(-90/-1)
tab1 dimar couple

rename tnhwq5_bu wealthq2

*===================.
*ADL & iADL.
*===================.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL2 = rsum(z1-z6) if headldr!=.    /*    */
tab1 ADL2

*===================.
* Currently smokes. (cigarettes only).
*===================.

tab1 r3smoken                   /* use harmonised data */
generate smoke2=r3smoken
label define smoke2lbl 0 "non-smoker" 1 "current smoker"  
label values smoke2 smoke2lbl
tab1 smoke2

*===================.
* Drink.
*===================.

tab1 r3drink                /*ever drinks alcohol (harmonised data) */
rename r3drink drink2
tab1 drink2

*===================.
*Physical activity
*===================.

generate actlevel2=.
replace actlevel2=1 if (r3vgactx_e==5) & (r3mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel2=2 if (r3vgactx_e==5) & inlist(r3mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel2=3 if ((r3mdactx_e==2) & r3vgactx_e==5)|(r3vgactx_e==4 & r3mdactx_e==5)   																		/* some mod or vig */
replace actlevel2=4 if (inlist(r3mdactx_e,2,3) & inlist(r3vgactx_e,3,4))| inlist(r3mdactx_e,4,5) & inlist(r3vgactx_e,3) | inlist(r3mdactx_e,4) & inlist(r3vgactx_e,4)  					 /* more mod or vig */
replace actlevel2=5 if inlist(r3vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel2, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel2 actlbl

*Dichotomous (actlevel3): inactive vs rest.

recode actlevel2 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel2 actlbl
tab1 actlevel2

*===================.
*CESD (number of depressive symptoms.
*===================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD2 = c
tab CESD2

* word recall: cflisen (immediate)
* word recall: cflisd (delayed)

tab1 cflisen cflisd

*===================.
*Social relationships
*===================.

* Spouse.

tab1 scptrg
rename scptrg scptrg2
tab1 scptrg2

count if (scptr==2)   /* 1943 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /* 4416 */
count if inlist(s2,0,1,2)     /* 4411 */
restore

di 1943+4416   /* 6359 */
di 1943+4411   /* 6354 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse2 = rowmean(scptra scptrb scptrc) 
egen NS_Spouse2 = rowmean(scptrd scptre scptrf) 

* recode no spouse to zero.

replace PS_Spouse2=0 if scptr==2
replace NS_Spouse2=0 if scptr==2

label variable PS_Spouse2 "Support (spouse)"
label variable NS_Spouse2 "Strain (spouse)"
summ PS_Spouse2 NS_Spouse2

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 783 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 5602 */
count if inlist(s2,0,1,2)     /* 5596 */
restore

di 783+5602  /*6385 */
di 783+5596   /* 6379 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child2 = rowmean(scchda scchdb scchdc) 
egen NS_Child2 = rowmean(scchdd scchde scchdf)

* recode no children to zero.

replace PS_Child2=0 if scchd==2
replace NS_Child2=0 if scchd==2

label variable PS_Child2 "Support (children)"
label variable NS_Child2 "Strain (children)"

summ PS_Child2 NS_Child2

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 332 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 6039 */
count if inlist(s2,0,1,2)     /* 6003 */
restore

di 332+6039  /* 6371 */
di 332+6003   /* 6335 */

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend2 = rowmean(scfrda scfrdb scfrdc)
egen NS_Friend2 = rowmean(scfrdd scfrde scfrdf) 

* recode no friends to zero.

replace PS_Friend2=0 if scfrd==2
replace NS_Friend2=0 if scfrd==2

label variable PS_Friend2 "Support (friends)"
label variable NS_Friend2 "Strain (friends)"
summ PS_Friend2 NS_Friend2

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

**.
count if (scfam==2)   /* 533 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 5777 */
count if inlist(s2,0,1,2)     /* 5739 */
restore

di 533+5777  /* 6310 */
di 533+5739   /* 6272 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family2 = rowmean(scfama scfamb scfamc)
egen NS_Family2 = rowmean(scfamd scfame scfamf)

* recode no friends to zero.

replace PS_Family2=0 if scfam==2
replace NS_Family2=0 if scfam==2

label variable PS_Family2 "Support (family)"
label variable NS_Family2 "Strain (family)"
summ PS_Family2 NS_Family2

* Overall summary.

egen PSall2 = rowmean(PS_Spouse2 PS_Child2 PS_Friend2 PS_Family2)
egen NSall2 = rowmean(NS_Spouse2 NS_Child2 NS_Friend2 NS_Family2)   

label variable PSall2 "Positive support from spouse, children, family, friends"
label variable NSall2 "Negative support from spouse, children, family, friends"
summ PSall2 NSall2

generate wave2=1

rename cflisen cflisen2
rename cflisd cflisd2

tab1 scptr, nolabel
generate spouse2=.
replace spouse2=0 if scptr==2
replace spouse2=1 if scptr==1
tab1 spouse2

tab1 scchd, nolabel
generate child2=.
replace child2=0 if scchd==2
replace child2=1 if scchd==1
tab1 child2

tab1 scfrd, nolabel
generate friend2=.
replace friend2=0 if scfrd==2
replace friend2=1 if scfrd==1
tab1 friend2

tab1 scfam, nolabel
generate family2=.
replace family2=0 if scfam==2
replace family2=1 if scfam==1
tab1 family2

*===================.
*Social Participation.
*===================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart2 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart2 "Social participation at Wave 3"
summ SPart2
tab1 SPart2

rename couple couple2

*N in file = 7,382.

keep idauniq wave2 age2 couple2 cflisen2 cflisd2 wealthq2 smoke2 drink2 actlevel2 ADL2 CESD2 ///
PSall2 NSall2 scptrg2 PS_Spouse2 NS_Spouse2 PS_Child2 NS_Child2 PS_Friend2 NS_Friend2 PS_Family2 NS_Family2 ///
spouse2 child2 friend2 family2 SPart2 sc_outcome2 iintdtm2 iintdty2
save "C:/Temp/Wave2DVs.dta", replace

*===================.
* Wave4.
*===================.

use  "wave_4_ifs_derived_variables.dta", clear
keep idauniq memtot memtotb
save "C:/Temp/Temp52.dta", replace

clear
use idauniq tnhwq5_bu_s using "wave_4_financial_derived_variables.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

* ELSA Wave 4.

clear
use idauniq dimar couple indager scptrg finstat indsex askpx sc* c* n* psc* hea* sc* w4scwt iintdatm iintdaty using "wave_4_elsa_data_v3.dta"
renvars,lower
rename iintdatm iintdtm3
rename iintdaty iintdty3
rename indager age3
keep if finstat=="C1CM"
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
drop _merge
rename tnhwq5_bu wealthq3
merge 1:1 idauniq using "C:/Temp/Temp52.dta"
keep if _merge==3
count
drop if askpx==1
count

generate sc_outcome3=0
replace sc_outcome3=1 if inrange(w4scwt,0.3,5.7)
tab1 sc_outcome3

keep idauniq dimar couple scptrg askpx wealthq3 age3 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlte headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome3 iintdtm3 iintdty3

merge 1:1 idauniq using "C:/Temp/W4_HRBs.dta"
keep if _merge==3
drop _merge

mvdecode _all, mv(-90/-1)
tab1 dimar couple

*===================.
*ADL & iADL.
*===================.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL3 = rsum(z1-z6) if headldr!=.    
tab1 ADL3

*===================.
* Currently smokes. (cigarettes only).
*===================.

tab1 r4smoken     /* use harmonised data */
generate smoke3=r4smoken
label define smoke3lbl 0 "non-smoker" 1 "current smoker"  
label values smoke3 smoke3lbl
tab1 smoke3

*===================.
* Drink.
*===================.

tab1 r4drink     /*ever drinks alcohol (harmonised data) */
rename r4drink drink3
tab1 drink3

*===================.
*Physical Activity
*===================.

generate actlevel3=.
replace actlevel3=1 if (r4vgactx_e==5) & (r4mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel3=2 if (r4vgactx_e==5) & inlist(r4mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel3=3 if ((r4mdactx_e==2) & r4vgactx_e==5)|(r4vgactx_e==4 & r4mdactx_e==5)   																		/* some mod or vig */
replace actlevel3=4 if (inlist(r4mdactx_e,2,3) & inlist(r4vgactx_e,3,4))| inlist(r4mdactx_e,4,5) & inlist(r4vgactx_e,3) | inlist(r4mdactx_e,4) & inlist(r4vgactx_e,4)  					 /* more mod or vig */
replace actlevel3=5 if inlist(r4vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel3, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel3 actlbl

*Dichotomous (actlevel4): inactive vs rest.

recode actlevel3 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel3 actlbl
tab1 actlevel3

*===================.
*CESD (number of depressive symptoms.
*===================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD3 = c
tab CESD3

* word recall: cflisen (immediate)
* word recall: cflisd (delayed)

tab1 cflisen cflisd

*===================.
*Social relationships
*===================.

* Spouse.

tab1 scptrg
rename scptrg scptrg3
tab1 scptrg3

count if (scptr==2)   /* 1751 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /* 3779 */
count if inlist(s2,0,1,2)     /* 3776 */
restore

di 1751+3779   /* 5530 */
di 1751+3776   /* 5527 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse3 = rowmean(scptra scptrb scptrc)
egen NS_Spouse3 = rowmean(scptrd scptre scptrf)

* recode no spouse to zero.

replace PS_Spouse3=0 if scptr==2
replace NS_Spouse3=0 if scptr==2

label variable PS_Spouse3 "Support (spouse)"
label variable NS_Spouse3 "Strain (spouse)"
summ PS_Spouse3 NS_Spouse3

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 683 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 4862 */
count if inlist(s2,0,1,2)     /* 4857 */
restore

di 683+4862  /*5545 */
di 683+4857   /* 5540 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child3 = rowmean(scchda scchdb scchdc) 
egen NS_Child3 = rowmean(scchdd scchde scchdf) 

* recode no children to zero.

replace PS_Child3=0 if scchd==2
replace NS_Child3=0 if scchd==2

label variable PS_Child3 "Support (children)"
label variable NS_Child3 "Strain (children)"

summ PS_Child3 NS_Child3

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 291 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 5255 */
count if inlist(s2,0,1,2)     /* 5237 */
restore

di 291+5255  /* 5546 */
di 291+5237   /* 5528 */

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend3 = rowmean(scfrda scfrdb scfrdc) 
egen NS_Friend3 = rowmean(scfrdd scfrde scfrdf)

 * recode no friends to zero.

replace PS_Friend3=0 if scfrd==2
replace NS_Friend3=0 if scfrd==2

label variable PS_Friend3 "Support (friends)"
label variable NS_Friend3 "Strain (friends)"
summ PS_Friend3 NS_Friend3

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

**.
count if (scfam==2)   /* 478 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 5011 */
count if inlist(s2,0,1,2)     /* 4992 */
restore

di 478+5011  /* 5489 */
di 478+4992   /* 5470 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family3 = rowmean(scfama scfamb scfamc) 
egen NS_Family3 = rowmean(scfamd scfame scfamf) 

* recode no family to zero.

replace PS_Family3=0 if scfam==2
replace NS_Family3=0 if scfam==2

label variable PS_Family3 "Support (family)"
label variable NS_Family3 "Strain (family)"

summ PS_Family3 NS_Family3

* Overall summary.

egen PSall3 = rowmean(PS_Spouse3 PS_Child3 PS_Friend3 PS_Family3)  
egen NSall3 = rowmean(NS_Spouse3 NS_Child3 NS_Friend3 NS_Family3)  

summ PSall3 NSall3
label variable PSall3 "Positive support from spouse, children, family, friends"
label variable NSall3 "Negative support from spouse, children, family, friends"

rename cflisen cflisen3
rename cflisd cflisd3

tab1 scptr, nolabel
generate spouse3=.
replace spouse3=0 if scptr==2
replace spouse3=1 if scptr==1
tab1 spouse3

tab1 scchd, nolabel
generate child3=.
replace child3=0 if scchd==2
replace child3=1 if scchd==1
tab1 child3

tab1 scfrd, nolabel
generate friend3=.
replace friend3=0 if scfrd==2
replace friend3=1 if scfrd==1
tab1 friend3

tab1 scfam, nolabel
generate family3=.
replace family3=0 if scfam==2
replace family3=1 if scfam==1
tab1 family3

*===================.
*Social Participation.
*===================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart3 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart3 "Social participation at Wave 4"
summ SPart3
tab1 SPart3

rename couple couple3

*N in file = 6,406.

generate wave3=1
keep idauniq wave3 age3 couple3 cflisen3 cflisd3 wealthq3 smoke3 drink3 actlevel3 ADL3 CESD3 ///
PSall3 NSall3 scptrg3 PS_Spouse3 NS_Spouse3 PS_Child3 NS_Child3 PS_Friend3 NS_Friend3 PS_Family3 NS_Family3 ///
spouse3 child3 friend3 family3 SPart3 sc_outcome3 iintdtm3 iintdty3
save "C:/Temp/Wave3DVs.dta", replace

*===================.
* Wave 5.
*===================.

clear
use idauniq tnhwq5_bu_s using "wave_5_financial_derived_variables.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

use idauniq dimar couple scptrg finstat indager indsex askpx cf* psc* head* sc* w5scwt iintdatm iintdaty using "wave_5_elsa_data_v4.dta", clear
rename indager age4
rename iintdatm iintdtm4
rename iintdaty iintdty4
keep if finstat=="C1CM"
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
rename tnhwq5_bu wealthq4
count
drop if askpx==1
count

generate sc_outcome4=0
replace sc_outcome4=1 if inrange(w5scwt,0.3,5.7)
tab1 sc_outcome4

keep idauniq dimar couple scptrg askpx wealthq4 age4 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlte headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome4 iintdtm4 iintdty4

merge 1:1 idauniq using "C:/Temp/W5_HRBs.dta"
keep if _merge==3
drop _merge

mvdecode _all, mv(-90/-1)
tab1 dimar couple

*===================.
*ADL & iADL.
*===================.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL4 = rsum(z1-z6) if headldr!=.    /*    */
tab1 ADL4

tab1 r5smoken                   /* use harmonised data */
generate smoke4=r5smoken
label define smoke4lbl 0 "non-smoker" 1 "current smoker"  
label values smoke4 smoke4lbl
tab1 smoke4

*===================.
* Drink.
*===================.

tab1 r5drink                /*ever drinks alcohol (harmonised data) */
rename r5drink drink4
tab1 drink4

*===================.
*PA.
*===================.

generate actlevel4=.
replace actlevel4=1 if (r5vgactx_e==5) & (r5mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel4=2 if (r5vgactx_e==5) & inlist(r5mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel4=3 if ((r5mdactx_e==2) & r5vgactx_e==5)|(r5vgactx_e==4 & r5mdactx_e==5)   																		/* some mod or vig */
replace actlevel4=4 if (inlist(r5mdactx_e,2,3) & inlist(r5vgactx_e,3,4))| inlist(r5mdactx_e,4,5) & inlist(r5vgactx_e,3) | inlist(r5mdactx_e,4) & inlist(r5vgactx_e,4)  					 /* more mod or vig */
replace actlevel4=5 if inlist(r5vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel4, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel4 actlbl

*Dichotomous (actlevel5): inactive vs rest.

recode actlevel4 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel4 actlbl
tab1 actlevel4

*===================.
*CESD (number of depressive symptoms.
*===================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD4 = c
tab CESD4

* word recall: cflisen (immediate)
* word recall: cflisd (delayed)

tab1 cflisen cflisd

*===================.
*Social relationships
*===================.

* Spouse.

tab1 scptrg
rename scptrg scptrg4
tab1 scptrg4

count if (scptr==2)   /* 1771 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /*3636  */
count if inlist(s2,0,1,2)     /* 3634 */
restore

di 1771+3636   /* 5407 */
di 1771+3634   /* 5405 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse4 = rowmean(scptra scptrb scptrc) 
egen NS_Spouse4 = rowmean(scptrd scptre scptrf)
 
* recode no spouse to zero.

replace PS_Spouse4=0 if scptr==2
replace NS_Spouse4=0 if scptr==2

label variable PS_Spouse4 "Support (spouse)"
label variable NS_Spouse4 "Strain (spouse)"
summ PS_Spouse4 NS_Spouse4

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

**.
count if (scchd==2)   /* 650 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 4758 */
count if inlist(s2,0,1,2)     /* 4746 */
restore

di 650+4758  /*5408 */
di 650+4746   /* 5396 */


* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child4 = rowmean(scchda scchdb scchdc) 
egen NS_Child4 = rowmean(scchdd scchde scchdf) 

* recode no children to zero.

replace PS_Child4=0 if scchd==2
replace NS_Child4=0 if scchd==2

label variable PS_Child4 "Support (children)"
label variable NS_Child4 "Strain (children)"

summ PS_Child4 NS_Child4

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 332 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 5074 */
count if inlist(s2,0,1,2)     /* 5048 */
restore

di 332+5074  /* 5406 */
di 332+5048   /* 5380 */

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend4 = rowmean(scfrda scfrdb scfrdc) 
egen NS_Friend4 = rowmean(scfrdd scfrde scfrdf) 

* recode no friends to zero.

replace PS_Friend4=0 if scfrd==2
replace NS_Friend4=0 if scfrd==2

label variable PS_Friend4 "Support (friends)"
label variable NS_Friend4 "Strain (friends)"

summ PS_Friend4 NS_Friend4

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 455 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 4908 */
count if inlist(s2,0,1,2)     /* 4883 */
restore

di 455+4908  /* 5363 */
di 455+4883   /* 5338 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family4 = rowmean(scfama scfamb scfamc)
egen NS_Family4 = rowmean(scfamd scfame scfamf) 

* recode no family to zero.

replace PS_Family4=0 if scfam==2
replace NS_Family4=0 if scfam==2

label variable PS_Family4 "Support (family)"
label variable NS_Family4 "Strain (family)"

summ PS_Family4 NS_Family4

* Overall summary.

egen PSall4 = rowmean(PS_Spouse4 PS_Child4 PS_Friend4 PS_Family4)
egen NSall4 = rowmean(NS_Spouse4 NS_Child4 NS_Friend4 NS_Family4)  

summ PSall4 NSall4

label variable PSall4 "Positive support from children, family, friends"
label variable NSall4 "Negative support from children, family, friends"

generate wave4=1

rename cflisen cflisen4
rename cflisd cflisd4

tab1 scptr, nolabel
generate spouse4=.
replace spouse4=0 if scptr==2
replace spouse4=1 if scptr==1
tab1 spouse4

tab1 scchd, nolabel
generate child4=.
replace child4=0 if scchd==2
replace child4=1 if scchd==1
tab1 child4

tab1 scfrd, nolabel
generate friend4=.
replace friend4=0 if scfrd==2
replace friend4=1 if scfrd==1
tab1 friend4

tab1 scfam, nolabel
generate family4=.
replace family4=0 if scfam==2
replace family4=1 if scfam==1
tab1 family4

*===================.
*Social Participation.
*===================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart4 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart4 "Social participation at Wave 4"
summ SPart4
tab1 SPart4

rename couple couple4

*N in file = 5,974.

keep idauniq wave4 age4 couple4 cflisen4 cflisd4 wealthq4 smoke4 drink4 actlevel4 ADL4 CESD4 ///
PSall4 NSall4 scptrg4 PS_Spouse4 NS_Spouse4 PS_Child4 NS_Child4 PS_Friend4 NS_Friend4 PS_Family4 NS_Family4 ///
spouse4 child4 friend4 family4 SPart4 sc_outcome4 iintdtm4 iintdty4
save "C:/Temp/Wave4DVs.dta", replace


*=============.
* Wave 6.
*=============.

clear
use idauniq tnhwq5_bu_s using "wave_6_financial_derived_variables.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

use idauniq DiMar couple finstat scptrg indager indsex askpx C* c* cf* PS* head*  sc* w6scwt iintdatm iintdaty using "wave_6_elsa_data_v2.dta", clear
renvars, lower
rename iintdatm iintdtm5
rename iintdaty iintdty5
tab1 finstat
keep if finstat==1
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
rename tnhwq5_bu wealthq5
rename indager age5
rename scprtr scptr
count
drop if askpx==1
count

generate sc_outcome5=0
replace sc_outcome5=1 if inrange(w6scwt,0.3,8)
tab1 sc_outcome5

keep idauniq dimar couple scptrg askpx wealthq5 age5 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlph headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome5 iintdtm5 iintdty5

merge 1:1 idauniq using "C:/Temp/W6_HRBs.dta"
keep if _merge==3
drop _merge

tab1 dimar couple

*=============.
*ADL & iADL.
*=============.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL5 = rsum(z1-z6) if headldr!=.    /*    */
tab1 ADL5

tab1 r6smoken                   /* use harmonised data */
generate smoke5=r6smoken
label define smoke5lbl 0 "non-smoker" 1 "current smoker"  
label values smoke5 smoke5lbl
tab1 smoke5

*=============.
* Drink.
*=============.

tab1 r6drink                /*ever drinks alcohol (harmonised data) */
rename r6drink drink5
tab1 drink5

*=============.
*PA.
*=============.

generate actlevel5=.
replace actlevel5=1 if (r6vgactx_e==5) & (r6mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel5=2 if (r6vgactx_e==5) & inlist(r6mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel5=3 if ((r6mdactx_e==2) & r6vgactx_e==5)|(r6vgactx_e==4 & r6mdactx_e==5)   																		/* some mod or vig */
replace actlevel5=4 if (inlist(r6mdactx_e,2,3) & inlist(r6vgactx_e,3,4))| inlist(r6mdactx_e,4,5) & inlist(r6vgactx_e,3) | inlist(r6mdactx_e,4) & inlist(r6vgactx_e,4)  					 /* more mod or vig */
replace actlevel5=5 if inlist(r6vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel5, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel5 actlbl

*Dichotomous (actlevel6): inactive vs rest.

recode actlevel5 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel5 actlbl
tab1 actlevel5

*=============.
*CESD (number of depressive symptoms.
*=============.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD5 = c
tab CESD5

mvdecode _all, mv(-90/-1)
summ cflisen cflisd 

*=====================.
*Social relationships
*=====================.

* Spouse.

tab1 scptrg
rename scptrg scptrg5
tab1 scptrg5

count if (scptr==2)   /* 1605 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /*3235  */
count if inlist(s2,0,1,2)     /*3228 */
restore

di 1605+3235   /* 4840 */
di 1605+3228   /* 4833 */

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse5 = rowmean(scptra scptrb scptrc)
egen NS_Spouse5 = rowmean(scptrd scptre scptrf)
 
* recode no spouse to zero.

replace PS_Spouse5=0 if scptr==2
replace NS_Spouse5=0 if scptr==2

label variable PS_Spouse5 "Support (spouse)"
label variable NS_Spouse5 "Strain (spouse)"
summ PS_Spouse5 NS_Spouse5

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 578 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 4270 */
count if inlist(s2,0,1,2)     /* 4261 */
restore

di 578+4270  /*4848 */
di 578+4261   /*4839 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child5 = rowmean(scchda scchdb scchdc)
egen NS_Child5 = rowmean(scchdd scchde scchdf) 

* recode no children to zero.

replace PS_Child5=0 if scchd==2
replace NS_Child5=0 if scchd==2

label variable PS_Child5 "Support (children)"
label variable NS_Child5 "Strain (children)"

summ PS_Child5 NS_Child5

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 315 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 4509 */
count if inlist(s2,0,1,2)     /* 4481 */
restore

di 315+4509  /* 4824 */
di 315+4481   /* 4796*/

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend5 = rowmean(scfrda scfrdb scfrdc)
egen NS_Friend5 = rowmean(scfrdd scfrde scfrdf)

* recode no friends to zero.

replace PS_Friend5=0 if scfrd==2
replace NS_Friend5=0 if scfrd==2

label variable PS_Friend5 "Support (friends)"
label variable NS_Friend5 "Strain (friends)"

summ PS_Friend5 NS_Friend5

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 409 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 4378 */
count if inlist(s2,0,1,2)     /* 4348 */
restore

di 409+4378  /*4787 */
di 409+4348   /* 4757 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family5 = rowmean(scfama scfamb scfamc)
egen NS_Family5 = rowmean(scfamd scfame scfamf) 

* recode no family to zero.

replace PS_Family5=0 if scfam==2
replace NS_Family5=0 if scfam==2

label variable PS_Family5 "Support (family)"
label variable NS_Family5 "Strain (family)"

summ PS_Family5 NS_Family5

* Overall summary.

egen PSall5 = rowmean(PS_Spouse5 PS_Child5 PS_Friend5 PS_Family5)
egen NSall5 = rowmean(NS_Spouse5 NS_Child5 NS_Friend5 NS_Family5) 

summ PSall5 NSall5

label variable PSall5 "Positive support from children, family, friends"
label variable NSall5 "Negative support from children, family, friends"

rename cflisen cflisen5
rename cflisd cflisd5

tab1 scptr, nolabel
generate spouse5=.
replace spouse5=0 if scptr==2
replace spouse5=1 if scptr==1
tab1 spouse5

tab1 scchd, nolabel
generate child5=.
replace child5=0 if scchd==2
replace child5=1 if scchd==1
tab1 child5

tab1 scfrd, nolabel
generate friend5=.
replace friend5=0 if scfrd==2
replace friend5=1 if scfrd==1
tab1 friend5

tab1 scfam, nolabel
generate family5=.
replace family5=0 if scfam==2
replace family5=1 if scfam==1
tab1 family5

generate wave5=1

*=============.
*Social Participation.
*=============.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart5 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart5 "Social participation at Wave 6"
summ SPart5
tab1 SPart5

rename couple couple5

*N in file = 5,385.

keep idauniq wave5 age5 couple5 cflisen5 cflisd5 wealthq5 smoke5 drink5 actlevel5 ADL5 CESD5 ///
PSall5 NSall5 scptrg5 PS_Spouse5 NS_Spouse5 PS_Child5 NS_Child5 PS_Friend5 NS_Friend5 PS_Family5 NS_Family5 ///
spouse5 child5 friend5 family5 SPart5 sc_outcome5 iintdtm5 iintdty5
save "C:/Temp/Wave5DVs.dta", replace


*============.
* Wave 7.
*============.

clear
use idauniq tnhwq5_bu_s using "wave_7_financial_derived_variables.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

use idauniq DiMar couple finstat scptrh indager indsex askpx C* c* cf* PS* head* sc* w7scwt iintdatm iintdaty using "wave_7_elsa_data.dta", clear
rename iintdatm iintdtm6
rename iintdaty iintdty6
renvars, lower
tab1 finstat
keep if finstat==1
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
rename tnhwq5_bu wealthq6
rename indager age6
rename scprtr scptr
count
drop if askpx==1
count

generate sc_outcome6=0
replace sc_outcome6=1 if inrange(w7scwt,0.2,9)
tab1 sc_outcome6

keep idauniq dimar couple scptrh askpx wealthq6 age6 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlph headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08 sc_outcome6 iintdtm6 iintdty6

merge 1:1 idauniq using "C:/Temp/W7_HRBs.dta"
keep if _merge==3
drop _merge

tab1 dimar couple

*============.
*ADL & iADL.
*============.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL6 = rsum(z1-z6) if headldr!=.    
tab1 ADL6

tab1 r7smoken                   /* use harmonised data */
generate smoke6=r7smoken
label define smoke6lbl 0 "non-smoker" 1 "current smoker"  
label values smoke6 smoke6lbl
tab1 smoke6

*============.
* Drink.
*============.

tab1 r7drink                /*ever drinks alcohol (harmonised data) */
rename r7drink drink6
tab1 drink6

*============.
*PA.
*============.

generate actlevel6=.
replace actlevel6=1 if (r7vgactx_e==5) & (r7mdactx_e==5)                                    																									/* sedentary: hardly ever moderate (5) and hardly ever vigorous (5) */
replace actlevel6=2 if (r7vgactx_e==5) & inlist(r7mdactx_e,3,4)                 																												/* low moderate (3,4) */
replace actlevel6=3 if ((r7mdactx_e==2) & r7vgactx_e==5)|(r7vgactx_e==4 & r7mdactx_e==5)   																		/* some mod or vig */
replace actlevel6=4 if (inlist(r7mdactx_e,2,3) & inlist(r7vgactx_e,3,4))| inlist(r7mdactx_e,4,5) & inlist(r7vgactx_e,3) | inlist(r7mdactx_e,4) & inlist(r7vgactx_e,4)  					 /* more mod or vig */
replace actlevel6=5 if inlist(r7vgactx_e,2)                                              																														/* vigorous (2) */
tab actlevel6, missing 		
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel6 actlbl

*Dichotomous (actlevel7): inactive vs rest.

recode actlevel6 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel6 actlbl
tab1 actlevel6

*============.
*CESD (number of depressive symptoms.
*============.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD6 = c
tab CESD6

mvdecode _all, mv(-90/-1)

*====================.
*Social relationships
*====================.

* Spouse.

tab1 scptrh
rename scptrh scptrg6
tab1 scptrg6

count if (scptr==2)   /* 1391 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /*2744  */
count if inlist(s2,0,1,2)     /*2739 */
restore

di 1391+2744   /* 4135 */
di 1391+2739   /* 4130 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse6 = rowmean(scptra scptrb scptrc) 
egen NS_Spouse6 = rowmean(scptrd scptre scptrf)
 
* recode no spouse to zero.

replace PS_Spouse6=0 if scptr==2
replace NS_Spouse6=0 if scptr==2

label variable PS_Spouse6 "Support (spouse)"
label variable NS_Spouse6 "Strain (spouse)"
summ PS_Spouse6 NS_Spouse6

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 497 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 3647 */
count if inlist(s2,0,1,2)     /* 3639 */
restore

di 497+3647 /*4144 */
di 497+3639   /*4136 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child6 = rowmean(scchda scchdb scchdc) 
egen NS_Child6 = rowmean(scchdd scchde scchdf)

* recode no children to zero.

replace PS_Child6=0 if scchd==2
replace NS_Child6=0 if scchd==2

label variable PS_Child6 "Support (children)"
label variable NS_Child6 "Strain (children)"

summ PS_Child6 NS_Child6

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 272 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 3847 */
count if inlist(s2,0,1,2)     /* 3838 */
restore

di 272+3847  /* 4119 */
di 272+3838   /* 4110*/

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend6 = rowmean(scfrda scfrdb scfrdc)
egen NS_Friend6 = rowmean(scfrdd scfrde scfrdf)

* recode no friends to zero.

replace PS_Friend6=0 if scfrd==2
replace NS_Friend6=0 if scfrd==2

label variable PS_Friend6 "Support (friends)"
label variable NS_Friend6 "Strain (friends)"

summ PS_Friend6 NS_Friend6

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 349 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 3755 */
count if inlist(s2,0,1,2)     /* 3742 */
restore

di 349+3755  /*4104 */
di 349+3742   /* 4091 */


* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family6 = rowmean(scfama scfamb scfamc)
egen NS_Family6 = rowmean(scfamd scfame scfamf)

* recode no family to zero.

replace PS_Family6=0 if scfam==2
replace NS_Family6=0 if scfam==2

label variable PS_Family6 "Support (family)"
label variable NS_Family6 "Strain (family)"

summ PS_Family6 NS_Family6

* Overall summary.

egen PSall6 = rowmean(PS_Spouse6 PS_Child6 PS_Friend6 PS_Family6) 
egen NSall6 = rowmean(NS_Spouse6 NS_Child6 NS_Friend6 NS_Family6)  

summ PSall6 NSall6

label variable PSall6 "Positive support from children, family, friends"
label variable NSall6 "Negative support from children, family, friends"

rename cflisen cflisen6
rename cflisd cflisd6

tab1 scptr, nolabel
generate spouse6=.
replace spouse6=0 if scptr==2
replace spouse6=1 if scptr==1
tab1 spouse6

tab1 scchd, nolabel
generate child6=.
replace child6=0 if scchd==2
replace child6=1 if scchd==1
tab1 child6

tab1 scfrd, nolabel
generate friend6=.
replace friend6=0 if scfrd==2
replace friend6=1 if scfrd==1
tab1 friend6

tab1 scfam, nolabel
generate family6=.
replace family6=0 if scfam==2
replace family6=1 if scfam==1
tab1 family6

generate wave6=1

*============.
*Social Participation.
*============.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart6 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart6 "Social participation at Wave 6"
summ SPart6
tab1 SPart6

rename couple couple6

*N in file = 4,647.

keep idauniq wave6 age6 couple6 cflisen6 cflisd6 wealthq6 smoke6 drink6 actlevel6 ADL6 CESD6 ///
PSall6 NSall6 scptrg6 PS_Spouse6 NS_Spouse6 PS_Child6 NS_Child6 PS_Friend6 NS_Friend6 PS_Family6 NS_Family6 ///
spouse6 child6 friend6 family6 SPart6 sc_outcome6 iintdtm6 iintdty6
save "C:/Temp/Wave6DVs.dta", replace

*==========================.
* Wave 8.
*==========================.

clear
use idauniq tnhwq5_bu_s using "wave_8_elsa_financial_dvs_eul_v1.dta"
sort idauniq
save "C:/Temp/Tempa.dta",replace

*Wave 8.
*use "C:\ELSA\datasets\wave_8_elsa_data_eul_v2.dta", clear

use idauniq finstat dimar couple indager indsex askpx  c* cf* ps* head* sc* w8w1lwgt w8scwt hesmk heska scako heacta heactb iintdatm iintdaty using "wave_8_elsa_data_eul_v2.dta", clear
renvars, lower
rename iintdatm iintdtm7
rename iintdaty iintdty7
tab1 finstat
keep if finstat==1
sort idauniq
merge 1:1 idauniq using "C:/Temp/Tempa.dta"
keep if _merge==3
rename tnhwq5_bu wealthq7
rename indager age7
count
drop if askpx==1
count

rename scprt scptr
rename scprta scptra 
rename scprtb scptrb 
rename scprtc scptrc 
rename scprtd scptrd 
rename scprte scptre 
rename scprtf scptrf 
rename scprtm scptrg

generate sc_outcome7=0
replace sc_outcome7=1 if inrange(w8scwt,0.1,10.3)
tab1 sc_outcome7

keep idauniq scprtg dimar couple scptrg w8w1lwgt askpx wealthq7 age7 cflisen cflisd psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh ///
headldr headlwa headlba headlea headlbe headlwc headlma headlpr headlsh headlph headlme headlho headlmo ///
scptr scchd scfrd scfam scptra scptrb scptrc  scptrd scptre scptrf  scchda scchdb scchdc  scchdd scchde scchdf scfrda scfrdb scfrdc scfrdd scfrde scfrdf scfama scfamb scfamc  scfamd scfame scfamf ///
hesmk heska scako heacta heactb scorgpo scorgnw scorgrl scorgch scorged scorgsc scorgsp scorg95 sc_outcome7 iintdtm7 iintdty7

rename scorgpo scorg01
rename scorgnw scorg02
rename scorgrl scorg03
rename scorgch scorg04
rename scorged scorg05
rename scorgsc scorg06
rename scorgsp scorg07
rename scorg95 scorg08

mvdecode _all, mv(-90/-1)

tab1 dimar couple

*==========================.
*ADL & iADL.
*==========================.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL7 = rsum(z1-z6) if headldr!=.    /*    */
tab1 ADL7

*==========================.
*CESD (number of depressive symptoms.
*==========================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD7 = c
tab CESD7

*==========================.
*Social relationships
*==========================.

* Spouse.

tab1 scptrg
rename scptrg scptrg7
tab1 scptrg7

count if (scptr==2)   /* 1242 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /*2376  */
count if inlist(s2,0,1,2)     /*2373 */
restore

di 1242+2376   /* 3618 */
di 1242+2373   /* 3615 */

tab1 scptr scptra scptrb scptrc scptrd scptre scptrf

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse7 = rowmean(scptra scptrb scptrc)
egen NS_Spouse7 = rowmean(scptrd scptre scptrf)
 
* recode no spouse to zero.

replace PS_Spouse7=0 if scptr==2
replace NS_Spouse7=0 if scptr==2

label variable PS_Spouse7 "Support (spouse)"
label variable NS_Spouse7 "Strain (spouse)"
summ PS_Spouse7 NS_Spouse7

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 425 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 3212 */
count if inlist(s2,0,1,2)     /* 3206 */
restore

di 425+3212 /*3637 */
di 425+3206   /*3631 */

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child7 = rowmean(scchda scchdb scchdc) 
egen NS_Child7 = rowmean(scchdd scchde scchdf)

* recode no children to zero.

replace PS_Child7=0 if scchd==2
replace NS_Child7=0 if scchd==2

label variable PS_Child7 "Support (children)"
label variable NS_Child7 "Strain (children)"

summ PS_Child7 NS_Child7

** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 242 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 3368 */
count if inlist(s2,0,1,2)     /* 3361 */
restore

di 242+3368  /* 3610 */
di 242+3361   /* 3603*/

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend7 = rowmean(scfrda scfrdb scfrdc) 
egen NS_Friend7 = rowmean(scfrdd scfrde scfrdf)

* recode no friends to zero.

replace PS_Friend7=0 if scfrd==2
replace NS_Friend7=0 if scfrd==2

label variable PS_Friend7 "Support (friends)"
label variable NS_Friend7 "Strain (friends)"

summ PS_Friend7 NS_Friend7

** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 310 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 3269 */
count if inlist(s2,0,1,2)     /* 3262 */
restore

di 310+3269  /*3579 */
di 310+3262   /*3572 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family7 = rowmean(scfama scfamb scfamc) 
egen NS_Family7 = rowmean(scfamd scfame scfamf) 

* recode no family to zero.

replace PS_Family7=0 if scfam==2
replace NS_Family7=0 if scfam==2

label variable PS_Family7 "Support (family)"
label variable NS_Family7 "Strain (family)"

summ PS_Family7 NS_Family7

* Overall summary.

egen PSall7 = rowmean(PS_Spouse7 PS_Child7 PS_Friend7 PS_Family7) 
egen NSall7 = rowmean(NS_Spouse7 NS_Child7 NS_Friend7 NS_Family7)  

summ PSall7 NSall7

label variable PSall7 "Positive support from children, family, friends"
label variable NSall7 "Negative support from children, family, friends"

rename cflisen cflisen7
rename cflisd cflisd7

generate wave7=1

tab1 scptr, nolabel
generate spouse7=.
replace spouse7=0 if scptr==2
replace spouse7=1 if scptr==1
tab1 spouse7

tab1 scchd, nolabel
generate child7=.
replace child7=0 if scchd==2
replace child7=1 if scchd==1
tab1 child7

tab1 scfrd, nolabel
generate friend7=.
replace friend7=0 if scfrd==2
replace friend7=1 if scfrd==1
tab1 friend7

tab1 scfam, nolabel
generate family7=.
replace family7=0 if scfam==2
replace family7=1 if scfam==1
tab1 family7

*HRBs.

*==========================.
*Smoke
*==========================.

tab hesmk heska
generate smoke7=-2
replace smoke7=0 if (hesmk==2)|(heska==2)
replace smoke7=1 if (heska==1)
label define smoke7lbl 0 "non-smoker" 1 "current smoker"  
label values smoke7 smoke7lbl
tab1 smoke7

*======================.
*Drink (ever: no/yes).
*scako scal7a scal7b
*==========================.

tab1 scako, nolabel

generate drink7=-2
replace drink7=0 if scako==8
replace drink7=1 if inrange(scako,1,7)
label define drink7lbl 0 "no" 1 "yes"  
label values drink7 drink7lbl
tab1 drink7

*==========================.
*PA.
*==========================.

rename heacta vig
rename heactb mod

generate actlevel7=.
replace actlevel7=1 if (vig==4) & (mod==4)   /* vig:never; mod:never)  */
replace actlevel7=2 if (vig==4) & inlist(mod,2,3)   /* vig:never; mod:some)  */
replace actlevel7=3 if (vig==4 & mod==1)|(vig==3 & mod==4)   /* vig:never; mod:some)  */
replace actlevel7=4 if (inlist(vig,2,3) & inlist(mod,1,2)) ///
|(inlist(vig,2) & inlist(mod,3,4)) ///
|(inlist(vig,3) & inlist(mod,3)) 
replace actlevel7=5 if inlist(vig,1) 
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel7 actlbl
tab1 actlevel7

*Dichotomous (actlevel1): inactive vs rest.

recode actlevel7 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel7 actlbl
tab1 actlevel7

*==========================.
*Social Participation.
*==========================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart7 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart7 "Social participation at Wave 8"
summ SPart7
tab1 SPart7

rename couple couple7

*N in file = 4,023.

keep idauniq w8w1lwgt wave7 age7 couple7 cflisen7 cflisd7 wealthq7 smoke7 drink7 actlevel7 ADL7 CESD7 ///
PSall7 NSall7 scptrg7 PS_Spouse7 NS_Spouse7 PS_Child7 NS_Child7 PS_Friend7 NS_Friend7 PS_Family7 NS_Family7 ///
spouse7 child7 friend7 family7 SPart7 sc_outcome7 iintdtm7 iintdty7
save "C:/Temp/Wave7DVs.dta", replace

*================.
*Wave 9.
*================.

local a "scprt scprta scprtb scprtc scprtd scprte scprtf"
local b "scchd scchda scchdb scchdc scchdd scchde scchdf"
local c "scfrd scfrda scfrdb scfrdc scfrdd scfrde scfrdf"
local d "scfam scfama scfamb scfamc scfamd scfame scfamf" 
local e "psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh"
local f "scorgpo scorgnw scorgrl scorgch scorged scorgsc scorgsp scorg95"
local g "headldr headlwa headlba headlea headlbe headlwc"

use idauniq scprtm dimar couple finstat indager askpx w9scwt iintdatm iintdaty `a' `b' `c' `d' `e' `f' `g' cflisen cflisd hesmk heska scalcm heacta heactb using "wave_9_elsa_data_eul_v1.dta", clear
renvars, lower
rename iintdatm iintdtm8
rename iintdaty iintdty8
tab1 finstat
keep if finstat==1
tab1 indager
replace indager=90 if indager==-7
rename indager age8
replace age8=64 if age8==54     /* Manual recode */

generate sc_outcome8=0
replace sc_outcome8=1 if inrange(w9scwt,0.1,9)
tab1 sc_outcome8

rename scprtm scptrg

count
drop if askpx==1
count

tab1 dimar couple

rename scorgpo scorg01
rename scorgnw scorg02
rename scorgrl scorg03
rename scorgch scorg04
rename scorged scorg05
rename scorgsc scorg06
rename scorgsp scorg07
rename scorg95 scorg08

*================.
*ADL & iADL.
*================.

tab1 headldr /*dressing */
tab1 headlwa /*walking */
tab1 headlba /*bathing */
tab1 headlea /*eating */
tab1 headlbe /*bed */
tab1 headlwc /*toilet */

egen z1 = anycount(headldr),values(1)
egen z2 = anycount(headlwa),values(1)
egen z3 = anycount(headlba),values(1)
egen z4 = anycount(headlea),values(1)
egen z5 = anycount(headlbe),values(1)
egen z6 = anycount(headlwc),values(1)

egen ADL8 = rsum(z1-z6) if headldr!=.   
tab1 ADL8

*================.
*CESD (number of depressive symptoms.
*================.

tab1 psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh
egen s = rowmiss(psceda pscedb pscedc pscedd pscede pscedf pscedg pscedh)
tab s

forvalues i = 1/8 {
generate f`i'=-2
}

replace f1=0 if psceda==2
replace f2=0 if pscedb==2
replace f3=0 if pscedc==2
replace f4=0 if pscedd==1
replace f5=0 if pscede==2
replace f6=0 if pscedf==1
replace f7=0 if pscedg==2
replace f8=0 if pscedh==2

replace f1=1 if psceda==1
replace f2=1 if pscedb==1
replace f3=1 if pscedc==1
replace f4=1 if pscedd==2
replace f5=1 if pscede==1
replace f6=1 if pscedf==2
replace f7=1 if pscedg==1
replace f8=1 if pscedh==1

mvdecode f1-f8,mv(-2)
egen c = rsum(f1-f8) if s==0              /* must have valid values on all 8 items */
tab1 c             /* 10,851  */
generate CESD8 = c
tab CESD8

summ cflisen cflisd

mvdecode sc*, mv(-90/-1)

*================.
*Social relationships
*================.

* Spouse.

rename scprt scptr
rename scprta scptra 
rename scprtb scptrb 
rename scprtc scptrc 
rename scprtd scptrd 
rename scprte scptre 
rename scprtf scptrf 

tab scptrg

rename scptrg scptrg8
tab1 scptrg8

count if (scptr==2)   /* 1106 */

preserve
keep if scptr==1
egen s1 = rowmiss(scptra scptrb scptrc)
egen s2 = rowmiss(scptrd scptre scptrf)
count if inlist(s1,0,1,2)     /*2044  */
count if inlist(s2,0,1,2)     /*2041 */
restore

di 1106+2044   /* 3150 */
di 1106+2041   /* 3147 */

* Positive.

tab1 scptra scptrb scptrc 

recode scptra (1=3) (2=2) (3=1) (4=0)
recode scptrb (1=3) (2=2) (3=1) (4=0)
recode scptrc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scptrd scptre scptrf

recode scptrd (1=3) (2=2) (3=1) (4=0)
recode scptre (1=3) (2=2) (3=1) (4=0)
recode scptrf (1=3) (2=2) (3=1) (4=0)

egen PS_Spouse8 = rowmean(scptra scptrb scptrc) 
egen NS_Spouse8 = rowmean(scptrd scptre scptrf)

* recode no spouse to zero.

replace PS_Spouse8=0 if scptr==2
replace NS_Spouse8=0 if scptr==2

label variable PS_Spouse8 "Support (spouse)"
label variable NS_Spouse8 "Strain (spouse)"
summ PS_Spouse8 NS_Spouse8

* Children (3 positive items): high scores = high positive.
* Children (3 negative items): high scores = high negative.

count if (scchd==2)   /* 387 */

preserve
keep if scchd==1
egen s1 = rowmiss(scchda scchdb scchdc)
egen s2 = rowmiss(scchdd scchde scchdf )
count if inlist(s1,0,1,2)     /* 2768 */
count if inlist(s2,0,1,2)     /* 2760 */
restore

di 387+2768 /*3155*/
di 387+2760   /*3147*/

* Positive.

tab1 scchda scchdb scchdc 

recode scchda (1=3) (2=2) (3=1) (4=0)
recode scchdb (1=3) (2=2) (3=1) (4=0)
recode scchdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scchdd scchde scchdf 

recode scchdd (1=3) (2=2) (3=1) (4=0)
recode scchde (1=3) (2=2) (3=1) (4=0)
recode scchdf (1=3) (2=2) (3=1) (4=0)

egen PS_Child8 = rowmean(scchda scchdb scchdc) 
egen NS_Child8 = rowmean(scchdd scchde scchdf) 

* recode no children to zero.

replace PS_Child8=0 if scchd==2
replace NS_Child8=0 if scchd==2

label variable PS_Child8 "Support (child)"
label variable NS_Child8 "Strain (child)"

summ PS_Child8 NS_Child8


** Friends (3 positive items): high scores = high positive.
** Friends (3 negative items): high scores = high negative.

count if (scfrd==2)   /* 194 */

preserve
keep if scfrd==1
egen s1 = rowmiss(scfrda scfrdb scfrdc)
egen s2 = rowmiss(scfrdd scfrde scfrdf)
count if inlist(s1,0,1,2)     /* 2952 */
count if inlist(s2,0,1,2)     /* 2939 */
restore

di 194+2952  /* 3146 */
di 194+2939   /* 3133*/

* Positive.

tab1 scfrda scfrdb scfrdc

recode scfrda (1=3) (2=2) (3=1) (4=0)
recode scfrdb (1=3) (2=2) (3=1) (4=0)
recode scfrdc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfrdd scfrde scfrdf 

recode scfrdd (1=3) (2=2) (3=1) (4=0)
recode scfrde (1=3) (2=2) (3=1) (4=0)
recode scfrdf (1=3) (2=2) (3=1) (4=0)

egen PS_Friend8 = rowmean(scfrda scfrdb scfrdc) 
egen NS_Friend8 = rowmean(scfrdd scfrde scfrdf) 

* recode no friends to zero.

replace PS_Friend8=0 if scfrd==2
replace NS_Friend8=0 if scfrd==2

label variable PS_Friend8 "Support (friends)"
label variable NS_Friend8 "Strain (friends)"

summ PS_Friend8 NS_Friend8


** Family members (3 positive items): high scores = high positive.
** Family members (3 negative items): high scores = high negative.

count if (scfam==2)   /* 309 */

preserve
keep if scfam==1
egen s1 = rowmiss(scfama scfamb scfamc)
egen s2 = rowmiss(scfamd scfame scfamf )
count if inlist(s1,0,1,2)     /* 2817 */
count if inlist(s2,0,1,2)     /* 2802 */
restore

di 309+2817  /*3126 */
di 309+2802   /*3111 */

* Positive.

tab1 scfama scfamb scfamc

recode scfama (1=3) (2=2) (3=1) (4=0)
recode scfamb (1=3) (2=2) (3=1) (4=0)
recode scfamc (1=3) (2=2) (3=1) (4=0)

* Negative.

tab1 scfamd scfame scfamf 

recode scfamd (1=3) (2=2) (3=1) (4=0)
recode scfame (1=3) (2=2) (3=1) (4=0)
recode scfamf (1=3) (2=2) (3=1) (4=0)

egen PS_Family8 = rowmean(scfama scfamb scfamc) 
egen NS_Family8 = rowmean(scfamd scfame scfamf)

* recode no family to zero.

replace PS_Family8=0 if scfam==2
replace NS_Family8=0 if scfam==2

label variable PS_Family8 "Support (family)"
label variable NS_Family8 "Strain (family)"

summ PS_Family8 NS_Family8

* Overall summary.

egen PSall8 = rowmean(PS_Spouse8 PS_Child8 PS_Friend8 PS_Family8) 
egen NSall8 = rowmean(NS_Spouse8 NS_Child8 NS_Friend8 NS_Family8)  

summ PSall8 NSall8

label variable PSall8 "Positive support from children, family, friends"
label variable NSall8 "Negative support from children, family, friends"

rename cflisen cflisen8
rename cflisd cflisd8
mvdecode cflisen8 cflisd8, mv(-9 -1)

generate wave8=1

tab1 scptr, nolabel
generate spouse8=.
replace spouse8=0 if scptr==2
replace spouse8=1 if scptr==1
tab1 spouse8

tab1 scchd, nolabel
generate child8=.
replace child8=0 if scchd==2
replace child8=1 if scchd==1
tab1 child8

tab1 scfrd, nolabel
generate friend8=.
replace friend8=0 if scfrd==2
replace friend8=1 if scfrd==1
tab1 friend8

tab1 scfam, nolabel
generate family8=.
replace family8=0 if scfam==2
replace family8=1 if scfam==1
tab1 family8

*================.
*smoke
*================.

tab hesmk heska
generate smoke8=-2
replace smoke8=0 if (hesmk==2)|(heska==2)
replace smoke8=1 if (heska==1)
label define smoke8lbl 0 "non-smoker" 1 "current smoker"  
label values smoke8 smoke8lbl
tab1 smoke8

*================.
*Drink (ever: no/yes).
*================.
*tab1 scalcm scalcy scalcd

tab1 scalcm, nolabel

generate drink8=-2
replace drink8=0 if scalcm==8
replace drink8=1 if inrange(scalcm,1,7)
label define drinklbl 0 "no" 1 "yes"  
label values drink8 drink8lbl
tab1 drink8

*================.
*PA.
*================.

rename heacta vig
rename heactb mod

generate actlevel8=.
replace actlevel8=1 if (vig==4) & (mod==4)   /* vig:never; mod:never)  */
replace actlevel8=2 if (vig==4) & inlist(mod,2,3)   /* vig:never; mod:some)  */
replace actlevel8=3 if (vig==4 & mod==1)|(vig==3 & mod==4)   /* vig:never; mod:some)  */
replace actlevel8=4 if (inlist(vig,2,3) & inlist(mod,1,2)) ///
|(inlist(vig,2) & inlist(mod,3,4)) ///
|(inlist(vig,3) & inlist(mod,3)) 
replace actlevel8=5 if inlist(vig,1) 
label define actlbl 1 "sedentary" 2 "low moderate" 3 "some mod or vig" 4 "More mod or vig" 5 "Vig"
label values actlevel8 actlbl
tab1 actlevel8

recode actlevel8 (1=1) (2/5=0)
label drop actlbl
label define actlbl 0 "active" 1 "inactive"
label values actlevel8 actlbl
tab1 actlevel8

*================.
*Social Participation.
*================.

egen sp = rowmiss(scorg01 scorg02 scorg03 scorg04 scorg05 scorg06 scorg07 scorg08)
tab sp

generate SPart8 = (scorg01 + scorg02 + scorg03 + scorg04 + scorg05 + scorg06 + scorg07 + scorg08) if sp==0
label variable SPart8 "Social participation at Wave 8"
summ SPart8
tab1 SPart8

rename couple couple8

*N in file = 3,464

keep idauniq wave8 age8 couple8 cflisen8 cflisd8 ADL8 CESD8 ///
PSall8 NSall8 scptrg8 PS_Spouse8 NS_Spouse8 PS_Child8 NS_Child8 PS_Friend8 NS_Friend8 PS_Family8 NS_Family8 ///
spouse8 child8 friend8 family8 smoke8 drink8 actlevel8 SPart8 sc_outcome8 iintdtm8 iintdty8
save "C:/Temp/Wave8DVs.dta", replace


*==============================================.
* Put the datasets together (in wide format).
*=============================================.

use "C:/Temp/Wave0DVs.dta", clear
merge 1:1 idauniq using "C:/Temp/Wave1DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave2DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave3DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave4DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave5DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave6DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave7DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Year_of_death.dta"
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/IndexFile.dta" 
keep if (_merge==1|_merge==3)
drop _merge
merge 1:1 idauniq using "C:/Temp/Wave8DVs.dta" 
keep if (_merge==1|_merge==3)
drop _merge
count        /* N = 11,036 */

*11,391 at wave 1 - (126 (dementia) + 130 (proxy) + 99 (age90+))
di (11391)-(126+130+99)

*Exclude missing memory at Wave 1 (n=199).

drop if (cflisen0==.|cflisd0==.)
count                            /*n=10,837*/

tab1 sc_outcome0                 /*728 not respond to self-completion at baseline */
di 11391-(126+130+99+199+728)    /*analytical sample at wave 0 (n=10,109) */


*================================.
*Between-test Pearson correlation.
*(Self-completion).
*Wave 2 (0.69) to Wave 6 (0.76).
*---------------------------------.

summ cflisen* cflisd* if sc_outcome0==1

forvalues i = 0/8 {
pwcorr cflisen`i' cflisd`i' if sc_outcome0==1
}

*Compute the memory scores.

generate memory0 = (cflisen0 + cflisd0) if inrange(cflisen0,0,10) & inrange(cflisd0,0,10)
generate memory1 = (cflisen1 + cflisd1) if inrange(cflisen1,0,10) & inrange(cflisd1,0,10)
generate memory2 = (cflisen2 + cflisd2) if inrange(cflisen2,0,10) & inrange(cflisd2,0,10)
generate memory3 = (cflisen3 + cflisd3) if inrange(cflisen3,0,10) & inrange(cflisd3,0,10)
generate memory4 = (cflisen4 + cflisd4) if inrange(cflisen4,0,10) & inrange(cflisd4,0,10)
generate memory5 = (cflisen5 + cflisd5) if inrange(cflisen5,0,10) & inrange(cflisd5,0,10)
generate memory6 = (cflisen6 + cflisd6) if inrange(cflisen6,0,10) & inrange(cflisd6,0,10)
generate memory7 = (cflisen7 + cflisd7) if inrange(cflisen7,0,10) & inrange(cflisd7,0,10)
generate memory8 = (cflisen8 + cflisd8) if inrange(cflisen8,0,10) & inrange(cflisd8,0,10)
summ memory*

*Centre age (at 65).

gen agebl_65=age0-65                 
gen agesq = (agebl_65*agebl_65)

mvdecode smoke7 smoke8 drink7 drink8, mv(-2)
summ CESD* ADL* SPart* smoke* drink* actlevel*

*Variables for descriptive Tables.

gen male=0
replace male=1 if indsex==1

gen low_wealth=-2
replace low_wealth=0 if inlist(wealthq0,1,2,3,4)
replace low_wealth=1 if wealthq0==5
mvdecode low_wealth,mv(-2)

gen low_educ=-2
replace low_educ=0 if inlist(topqual,0,1)
replace low_educ=1 if topqual==2
mvdecode low_educ,mv(-2)
summ w8w1lwgt

*===================================================================.
*This file is the starting point for the:
*(1) descriptive analysis;
*(2) analysis of global support/strain (all sources); and
*(3) the relationship-specific analyses.
*====================================================================.

save "AnalysisFile.dta", replace






