*===============================================================================================.
*This do-file follows the ELSA participants over the 9 waves.
*It provides the the numbers for the flowchart (Figure S1).
*Analytical sample = those who respond at self-completion stage & valid memory data (N=10,109).
*===============================================================================================.

*Datasets required:
*h_elsa.dta
*index_file_wave_0-wave_5_v2.dta
*wave_1_core_data_v3.dta
*wave_2_core_data_v4
*wave_3_elsa_data_v4.dta
*wave_4_elsa_data_v3.dta
*wave_5_elsa_data_v4.dta
*wave_6_elsa_data_v2.dta
*wave_7_elsa_data.dta
*wave_8_elsa_data_eul_v2.dta
*wave_9_elsa_data_eul_v1.dta

clear

*===================.
cd C:\ELSA\Datasets
*===================.

use "h_elsa.dta", clear
keep idauniq radyear
tab radyear    /* Year_of_Death */
sort idauniq
save "C:\Temp\IntDatesAndDeath.dta",replace

*SC outcome at Wave 1.
use "index_file_wave_0-wave_5_v2.dta", clear
keep idauniq outscw1 
rename outscw1 outscw0   /* SC at baseline */
sort idauniq
save "C:\Temp\FileA.dta", replace

*Wave 2.
clear
use idauniq askpx C* scw2wgt using "wave_2_core_data_v4.dta"
renvars,lower
tab1 askpx
rename askpx proxy1
generate memory1 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory1
generate outscw1=0
replace outscw1=1 if inrange(scw2wgt,0.5,4.2)
tab1 outscw1
gen wave1=1
sort idauniq
keep idauniq proxy1 memory1 outscw1 wave1
save "C:\Temp\Outcome1.dta", replace

*Wave 3.
clear
use  idauniq askpx outscw3 cflisen cflisd outscw3 using "wave_3_elsa_data_v4.dta"
renvars,lower
tab1 askpx
rename askpx proxy2
rename outscw3 outscw2
generate memory2 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory2
gen wave2=1
sort idauniq
keep idauniq proxy2 memory2 outscw2 wave2
save "C:\Temp\Outcome2.dta", replace

*Wave 4.
clear
use idauniq askpx w4scwt cflisen cflisd using "wave_4_elsa_data_v3.dta"
renvars,lower
tab1 askpx
rename askpx proxy3
generate memory3 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory3
generate outscw3=0
replace outscw3=1 if inrange(w4scwt,0.3,5.7)
tab1 outscw3
gen wave3=1
sort idauniq
keep idauniq proxy3 memory3 outscw3 wave3
save "C:\Temp\Outcome3.dta", replace

*Wave 5.
clear
use idauniq askpx w5scwt cflisen cflisd using "wave_5_elsa_data_v4.dta", clear
renvars,lower
tab1 askpx
rename askpx proxy4
generate memory4 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory4
generate outscw4=0
replace outscw4=1 if inrange(w5scwt,0.3,5.7)
tab1 outscw4
gen wave4=1
sort idauniq
keep idauniq proxy4 memory4 outscw4 wave4
save "C:\Temp\Outcome4.dta", replace

*Wave 6.
use idauniq askpx CfLisD CfLisEn w6scwt using "wave_6_elsa_data_v2.dta", clear
renvars, lower
tab1 askpx
rename askpx proxy5
generate memory5 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory5
generate outscw5=0
replace outscw5=1 if inrange(w6scwt,0.3,9)
tab1 outscw5
gen wave5=1
sort idauniq
keep idauniq proxy5 memory5 outscw5 wave5
save "C:\Temp\Outcome5.dta", replace

*Wave 7.
use idauniq askpx w7scwt CfLisEn CfLisD using "wave_7_elsa_data.dta", clear
renvars, lower
tab1 askpx
rename askpx proxy6
generate memory6 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory6
generate outscw6=0
replace outscw6=1 if inrange(w7scwt,0.2,9)
tab1 outscw6
gen wave6=1
sort idauniq
keep idauniq proxy6 memory6 outscw6 wave6
save "C:\Temp\Outcome6.dta", replace

*Wave 8.
use idauniq askpx w8scwt cflisen cflisd using "wave_8_elsa_data_eul_v2.dta", clear
renvars, lower
tab1 askpx
rename askpx proxy7
generate memory7 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory7
generate outscw7=0
replace outscw7=1 if inrange(w8scwt,0.1,10.3)
tab1 outscw7
gen wave7=1
sort idauniq
keep idauniq proxy7 memory7 outscw7 wave7
save "C:\Temp\Outcome7.dta", replace

*Wave 9.
use idauniq askpx w9scwt cflisen cflisd using "wave_9_elsa_data_eul_v1.dta", clear
renvars, lower
tab1 askpx
rename askpx proxy8
generate memory8 = (cflisen + cflisd) if inrange(cflisen,0,10) & inrange(cflisd,0,10)
summ memory8
generate outscw8=0
replace outscw8=1 if inrange(w9scwt,0.1,10.3)
tab1 outscw8
gen wave8=1
sort idauniq
keep idauniq proxy8 memory8 outscw8 wave8
save "C:\Temp\Outcome8.dta", replace

*==========================================.
*Wave 1 and then match in all other waves. 
*==========================================.

clear
use idauniq finstat cf* w1wgt askpx dhager hedib01-hedib10 using "wave_1_core_data_v3.dta"
renvars, lower
sort idauniq
merge 1:1 idauniq using "C:\Temp\FileA.dta"
keep if _merge==3
drop _merge
summ w1wgt if w1wgt>0
keep if inrange(w1wgt,0.2,8.9)  /* N=11,391 core members */

*Dementia cases (N=126).
*Proxy (n=130).
*Age (90+: n=99).

egen dementia = anycount(hedib01-hedib10),values(6 8 9)
recode dementia (2=1)
tab1 dementia

generate memory0 = cflisen + cflisd if inrange(cflisen,0,10) & inrange(cflisd,0,10) 
summ memory0

gen outcomew1=.
replace outcomew1=11 if dementia==1                                       /* Drop dementia cases (N = 126)  */
replace outcomew1=12 if askpx==1                                          /* Drop proxies (N = 130)  */
replace outcomew1=13 if inrange(dhager,90,99)                             /* Drop 90+ (N = 99)  */
replace outcomew1=3 if outcomew1==. & (memory0==.)                         /* Missing memory (N=199) */ 
replace outcomew1=4 if outcomew1==. & inlist(outscw0,-2,2,3)               /* Missing SC (N=728) */  
replace outcomew1=5 if outcomew1==. & inlist(outscw0,1) & (memory0!=.)     /* ASample (N=10,109) */  

label define outcomew1lbl 11 "Dementia" 12 "Proxy" 13 "90+" 3 "missing CF" 4 "No SC" 5 "Analytical Sample"
label values outcomew1 outcomew1lbl 
tab1 outcomew1
drop if dementia==1
drop if askpx==1                     /* Drop proxies (N=130)  */
drop if inrange(dhager,90,99)        /* Drop 90+ (N=99)  */
count   /* N = 11,036 */
drop if (memory0==.)                 /* Drop missing CF (N=199)  */
count                                /* N=10,837 */
tab1 outscw0, nolabel
drop if inlist(outscw0,-2,2,3)       /* Drop missing SC (N=728)  */
count
*di 11391-(126+130+99+199+728)        /* AS at wave 1 (N=10,109 */

rename outcomew1 outcomew0
keep if outcomew0==5
generate wave0=1
count                                 /*N=10,109*/ 

*===========================.
*Wave 1 to Wave 2.
*===========================.

merge 1:1 idauniq using "C:\Temp\IntDatesAndDeath.dta"
keep if _merge==3
drop _merge

merge 1:1 idauniq using "C:\Temp\Outcome1.dta"
keep if inlist(_merge,1,3)
drop _merge

*All participants at W2 took part at W1.

generate outcomew1=.
replace outcomew1=1 if inlist(radyear,2002,2003)                                       /* Died before W2 (N=185) */ 
replace outcomew1=2 if outcomew1==. & (proxy1==1) & (wave1==1)                         /* Proxy at Wave 2 (N=47) */  
replace outcomew1=3 if outcomew1==. & (memory1==.) & (wave1==1)                        /* Missing memory (N=37) */  
replace outcomew1=4 if outcomew1==. & inlist(outscw1,0) & (wave1==1)                   /* Missing SC (N=641) */  
replace outcomew1=5 if outcomew1==. & inlist(outscw1,1) & (memory1!=.) & (wave1==1)    /* ASample (N=7395) */  
replace outcomew1=6 if (outcomew1==.) & ///
((radyear==.)|(inlist(radyear,2004,2005,2006,2007,2008,2009,2010,2011,2012)))          /* Censored (N=1804) */

label define albl 1 "death before W2" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew1 albl
tab1 outcomew1                       /* Based on 10,109 */

*============================.
*Wave 2 to Wave 3.
*============================.

*Exclude deaths before W2.
*di (10109) - (185) = 9924.

drop if outcomew1==1
count

merge 1:1 idauniq using "C:\Temp\Outcome2.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw2

generate outcomew2=.
replace outcomew2=1 if inlist(radyear,2004,2005)                                  /* Died before W3 (N=354) */ 
replace outcomew2=2 if outcomew2==. & (proxy2==1) & (wave2==1)                    /* Proxy at Wave 3 (N=91) */  
replace outcomew2=3 if outcomew2==. & (memory2==.) & (wave2==1)                   /* Missing memory (N=31) */ 
replace outcomew2=4 if outcomew2==. & inlist(outscw2,-2,2,3) & (wave2==1)         /* Missing SC (N=694) */
replace outcomew2=5 if outcomew2==. & inlist(outscw2,1) & (memory2!=.) & (wave2==1)      /* ASample (N=6184) */  
replace outcomew2=6 if (outcomew2==.) & ///
((radyear==.)|(inlist(radyear,2006,2007,2008,2009,2010,2011,2012)))            /* Censored (N=2570) */

label define blbl 1 "death before W3" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew2 blbl
tab1 outcomew2
tab1 outcomew2 if outcomew1==5                     /* W3 conditional on taking part at W2 */
tab1 outcomew2 if outcomew1!=5 & outcomew2==5      /* Returned at Wave 3*/
di (6184-5704)

*============================
*Wave 3 to Wave 4.
*============================

*Exclude deaths before W3.
*di (9924) - (354) = 9570.

drop if outcomew2==1
count

merge 1:1 idauniq using "C:\Temp\Outcome3.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw3

generate outcomew3=.
replace outcomew3=1 if inlist(radyear,2006,2007)                                          /* Died before W4 (N=382) */ 
replace outcomew3=2 if outcomew3==. & (proxy3==1) & (wave3==1)                            /* Proxy at Wave W4 (N=156) */ 
replace outcomew3=3 if outcomew3==. & (memory3==.) & (wave3==1)                           /* Missing memory (N=26) */ 
replace outcomew3=4 if outcomew3==. & inlist(outscw3,0) & (wave3==1)                      /* Missing SC (N=722) */
replace outcomew3=5 if outcomew3==. & inlist(outscw3,1) & (memory3!=.) & (wave3==1)       /* ASample (N=5271) */ 
replace outcomew3=6 if (outcomew3==.) & ///
((radyear==.)|(inlist(radyear,2008,2009,2010,2011,2012)))                                 /* Censored (N=3013) */

label define clbl 1 "death before W4" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew3 blbl
tab1 outcomew3
tab1 outcomew3 if (outcomew1==5) & (outcomew2==5)      /* W4 conditional on taking part at W2 & W3 */
tab1 outcomew3 if (outcomew2==5)   					   /* W4 conditional on taking part at W3 */
tab1 outcomew3 if outcomew2!=5 & outcomew3==5          /* Returned at Wave 4*/

*====================.
*Wave 4 to Wave 5.
*====================.

*di (9570) - (382) = 9188

drop if outcomew3==1
count

merge 1:1 idauniq using "C:\Temp\Outcome4.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw4

generate outcomew4=.
replace outcomew4=1 if inlist(radyear,2008,2009)                                          /* Died before W5 (N=446) */ 
replace outcomew4=2 if outcomew4==. & (proxy4==1) & (wave4==1)                            /* Proxy at Wave W4 (N=220) */ 
replace outcomew4=3 if outcomew4==. & (memory4==.) & (wave4==1)                           /* Missing memory (N=34) */ 
replace outcomew4=4 if outcomew4==. & inlist(outscw4,0) & (wave4==1)                      /* Missing SC (N=394) */
replace outcomew4=5 if outcomew4==. & inlist(outscw4,1) & (memory4!=.) & (wave4==1)       /* ASample (N=5197) */ 
replace outcomew4=6 if (outcomew4==.) & ///
((radyear==.)|(inlist(radyear,2010,2011,2012)))                                 /* Censored (N=2896) */

label define dlbl 1 "death before W5" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew4 dlbl
tab1 outcomew4
tab1 outcomew4 if (outcomew1==5) & (outcomew2==5) & (outcomew3==5)  /* W5 conditional on taking part at W2, W3 & W4 */

tab1 outcomew4 if (outcomew3==5)   					   /* W5 conditional on taking part at W4 */
tab1 outcomew4 if outcomew3!=5 & outcomew4==5          /* Returned at Wave 5*/

*===================
*Wave 5 to Wave 6.
*==================

*di (9188) - (446) = 8742.

drop if outcomew4==1
count

merge 1:1 idauniq using "C:\Temp\Outcome5.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw5

replace radyear=2010 if idauniq==107609

generate outcomew5=.
replace outcomew5=1 if inlist(radyear,2010,2011,2012)                                          /* Died before W6 (N=581) */ 
replace outcomew5=2 if outcomew5==. & (proxy5==1) & (wave5==1)                            /* Proxy at Wave W6 (N=221) */
replace outcomew5=3 if outcomew5==. & (memory5==.) & (wave5==1)                           /* Missing memory (N=8) */ 
replace outcomew5=4 if outcomew5==. & inlist(outscw5,0) & (wave5==1)                      /* Missing SC (N=439) */
replace outcomew5=5 if outcomew5==. & inlist(outscw5,1) & (memory5!=.) & (wave5==1)       /* ASample (N=4638) */ 
replace outcomew5=6 if (outcomew5==.) & (radyear==.)                                 /* Censored (N=2855) */

label define elbl 1 "death before W6" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew5 elbl
tab1 outcomew5
tab1 outcomew5 if (outcomew1==5) & (outcomew2==5) & (outcomew3==5) & (outcomew4==5) /* W6 conditional on taking part at W2, W3, W4 & W5 */

tab1 outcomew5 if (outcomew4==5)   					   /* W6 conditional on taking part at W5 */
tab1 outcomew5 if outcomew4!=5 & outcomew5==5          /* Returned at Wave 6*/

*=======================.
*Wave 6 to Wave 7.
*=======================

*di (8742) - (581) = 8161.
drop if outcomew5==1
count

merge 1:1 idauniq using "C:\Temp\Outcome6.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw6

generate outcomew6=.
*replace outcomew7=1 if inlist(radyear,2010,2011,2012)                                    /* Died before W7 (N=xxx) */ 
replace outcomew6=2 if outcomew6==. & (proxy6==1) & (wave6==1)                            /* Proxy at Wave W7 (N=204) */
replace outcomew6=3 if outcomew6==. & (memory6==.) & (wave6==1)                           /* Missing memory (N=8) */ 
replace outcomew6=4 if outcomew6==. & inlist(outscw6,0) & (wave6==1)                      /* Missing SC (N=399) */
replace outcomew6=5 if outcomew6==. & inlist(outscw6,1) & (memory6!=.) & (wave6==1)       /* ASample (N=3996) */ 
replace outcomew6=6 if (outcomew6==.) & (radyear==.)                                 /* Censored (N=3554) */

label define flbl 1 "death before W7" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew6 flbl
tab1 outcomew6
tab1 outcomew6 if (outcomew1==5) & (outcomew2==5) & (outcomew3==5) & (outcomew4==5) & (outcomew5==5) /* W7 conditional on taking part at W2, W3, W4, W5 & W6 */

tab1 outcomew6 if (outcomew5==5)   					   /* W6 conditional on taking part at W5 */
tab1 outcomew6 if outcomew5!=5 & outcomew6==5          /* Returned at Wave 6*/

*====================.
*Wave 7 to Wave 8.
*====================.

*di (8161) = 8161.

drop if outcomew6==1
count

merge 1:1 idauniq using "C:\Temp\Outcome7.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw7

generate outcomew7=.
*replace outcomew8=1 if inlist(radyear,2010,2011,2012)                                    /* Died before W8 (N=xxx) */ 
replace outcomew7=2 if outcomew7==. & (proxy7==1) & (wave7==1)                            /* Proxy at Wave W8 (N=160) */
replace outcomew7=3 if outcomew7==. & (memory7==.) & (wave7==1)                           /* Missing memory (N=33) */
replace outcomew7=4 if outcomew7==. & inlist(outscw7,0) & (wave7==1)                      /* Missing SC (N=323) */
replace outcomew7=5 if outcomew7==. & inlist(outscw7,1) & (memory7!=.) & (wave7==1)       /* ASample (N=3463) */
replace outcomew7=6 if (outcomew7==.) & (radyear==.)                                 /* Censored (N=4182) */

label define glbl 1 "death before W8" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew7 glbl
tab1 outcomew7
tab1 outcomew7 if (outcomew1==5) & (outcomew2==5) & (outcomew3==5) & (outcomew4==5) & (outcomew5==5) & (outcomew6==5) /* W8 conditional on taking part at W2, W3, W4, W5, W6 & W7 */

tab1 outcomew7 if (outcomew6==5)   					   /* W7 conditional on taking part at W6 */
tab1 outcomew7 if outcomew6!=5 & outcomew7==5          /* Returned at Wave 7*/

*====================.
*Wave 8 to Wave 9.
*====================.

*di (8161) = 8161.

drop if outcomew7==1
count

merge 1:1 idauniq using "C:\Temp\Outcome8.dta"
keep if inlist(_merge,1,3)
drop _merge
count
tab1 outscw8

generate outcomew8=.
*replace outcomew9=1 if inlist(radyear,2010,2011,2012)                                    /* Died before W9 (N=xxx) */ 
replace outcomew8=2 if outcomew8==. & (proxy8==1) & (wave8==1)                            /* Proxy at Wave W9 (N=169) */
replace outcomew8=3 if outcomew8==. & (memory8==.) & (wave8==1)                           /* Missing memory (N=24) */
replace outcomew8=4 if outcomew8==. & inlist(outscw8,0) & (wave8==1)                      /* Missing SC (N=238) */
replace outcomew8=5 if outcomew8==. & inlist(outscw8,1) & (memory8!=.) & (wave8==1)       /* ASample (N=3003) */
replace outcomew8=6 if (outcomew8==.) & (radyear==.)                                 /* Censored (N=4697) */
label define hlbl 1 "death before W8" 2 "proxy" 3 "missing CF"  4 "No SC" 5 "Analytical sample" 6 "Censored"
label values outcomew8 hlbl
tab1 outcomew8
tab1 outcomew8 if (outcomew1==5) & (outcomew2==5) & (outcomew3==5) & (outcomew4==5) & (outcomew5==5) & (outcomew6==5) & (outcomew7==5) /* W9 conditional on taking part at W2, W3, W4, W5, W6, W7 & W8 */

tab1 outcomew8 if (outcomew7==5)   					   /* W9 conditional on taking part at W8 */
tab1 outcomew8 if outcomew7!=5 & outcomew8==5          /* Returned at Wave 9*/

*Participants at each wave (completers: N=2004).
generate completers=0
replace completers=1 if (memory1!=. & outscw1==1) & (memory2!=. & outscw2==1) ///
& (memory3!=. & outscw3==1) & (memory4!=. & outscw4==1) ///
& (memory5!=. & outscw5==1) & (memory6!=. & outscw6==1) & (memory7!=. & outscw7==1) ///
& (memory8!=. & outscw8==1) 
tab1 completers

*N for main analysis (49286).

di 10109 + 7395 + 6184 + 5271  + 5197  + 4638  + 3996 + 3463 + 3033

*N for completers (42318).

di 10109 + 7395 + 5704 + 4470 + 3907 + 3399 + 2894 + 2436 + 2004


    
































































