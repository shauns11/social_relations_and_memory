*=====================.
*Descriptive analysis
*Table 1 & Table S1
*=====================.

clear
cd C:\ELSA\Datasets
use "AnalysisFile.dta", clear

*====================================================.
*Table 1.
*Total Obs = 10,109.
*AS by study wave (valid memory and self-completion).
*Wtd by wave 1 weight.
*====================================================.

*=====================================================.
*Time-invariant flag (must have taken part at wave 1).
*======================================================.

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count              /*n=10,109*/

*============.
*Wave 1.
*============.

preserve
svyset [pweight=w1wgt]
count
keep if inrange(memory0,0,20)     /*S at W1 (N=10,837)*/
keep if sc_outcome0==1            /*AS at W1 (N=10,109)*/
foreach var of varlist male low_educ low_wealth smoke0 drink0 actlevel0 {
svy:tab `var'
}
foreach var of varlist age0 memory0 PSall0 NSall0 SPart0 ADL0 CESD0  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 2.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory1,0,20)
keep if inrange(memory1,0,20)         /* S at W2 (N=8036) */
keep if sc_outcome1==1                /* AS at W2 (N=7395) */
foreach var of varlist male low_educ low_wealth smoke1 drink1 actlevel1 {
svy:tab `var'
}
foreach var of varlist age1 memory1 PSall1 NSall1 SPart1 ADL1 CESD1  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 3.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory2,0,20)
keep if inrange(memory2,0,20)         /* S at W3 (N=6878) */
keep if sc_outcome2==1                /* AS at W3 (N=6184) */
foreach var of varlist male low_educ low_wealth smoke2 drink2 actlevel2 {
svy:tab `var'
}
foreach var of varlist age2 memory2 PSall2 NSall2 SPart2 ADL2 CESD2  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 4.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory3,0,20)
keep if inrange(memory3,0,20)         /* S at W4 (N=5994) */
keep if sc_outcome3==1                /* AS at W4 (N=5271) */
foreach var of varlist male low_educ low_wealth smoke3 drink3 actlevel3 {
svy:tab `var'
}
foreach var of varlist age3 memory3 PSall3 NSall3 SPart3 ADL3 CESD3  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 5.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory4,0,20)
keep if inrange(memory4,0,20)         /* S at W5 (N=5591) */
keep if sc_outcome4==1                /* AS at W5 (N=5197) */
foreach var of varlist male low_educ low_wealth smoke4 drink4 actlevel4 {
svy:tab `var'
}
foreach var of varlist age4 memory4 PSall4 NSall4 SPart4 ADL4 CESD4  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 6.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory5,0,20)
keep if inrange(memory5,0,20)         /* S at W6 (N=5077) */
keep if sc_outcome5==1                /* AS at W6 (N=4638) */
foreach var of varlist male low_educ low_wealth smoke5 drink5 actlevel5 {
svy:tab `var'
}
foreach var of varlist age5 memory5 PSall5 NSall5 SPart5 ADL5 CESD5  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 7.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory6,0,20)
keep if inrange(memory6,0,20)          /* S at W7 (N=4395) */
keep if sc_outcome6==1                /* AS at W7 (N=3996) */
foreach var of varlist male low_educ low_wealth smoke6 drink6 actlevel6 {
svy:tab `var'
}
foreach var of varlist age6 memory6 PSall6 NSall6 SPart6 ADL6 CESD6  {
svy:mean `var'
estat sd
}
restore

*============.
*Wave 8.
*============.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory7,0,20)
keep if inrange(memory7,0,20)         /* S at W8 (N=3786) */
keep if sc_outcome7==1                /* AS at W8 (N=3463) */
foreach var of varlist male low_educ low_wealth smoke7 drink7 actlevel7 {
svy:tab `var'
}
foreach var of varlist age7 memory7 PSall7 NSall7 SPart7 ADL7 CESD7  {
svy:mean `var'
estat sd
}
restore

*--------.
*Wave 9.
*--------.

preserve
svyset [pweight=w1wgt]
count
count if inrange(memory8,0,20)
keep if inrange(memory8,0,20)         /* AS at W9 (N=3271) */
keep if sc_outcome8==1                /* AS at W9 (N=3033) */
foreach var of varlist male low_educ low_wealth smoke8 drink8 actlevel8 {
svy:tab `var'
}
foreach var of varlist age8 memory8 PSall8 NSall8 SPart8 ADL8 CESD8  {
svy:mean `var'
estat sd
}
restore

*===================================================.
*Number of waves based on memory & self-completion.
*===================================================.

forvalues i = 1/9 {
generate x`i' = 0
}

replace x1=1 if inrange(memory0,0,20) & sc_outcome0==1
replace x2=1 if inrange(memory1,0,20) & sc_outcome1==1
replace x3=1 if inrange(memory2,0,20) & sc_outcome2==1
replace x4=1 if inrange(memory3,0,20) & sc_outcome3==1
replace x5=1 if inrange(memory4,0,20) & sc_outcome4==1
replace x6=1 if inrange(memory5,0,20) & sc_outcome5==1
replace x7=1 if inrange(memory6,0,20) & sc_outcome6==1
replace x8=1 if inrange(memory7,0,20) & sc_outcome7==1
replace x9=1 if inrange(memory8,0,20) & sc_outcome8==1
tab1 x1-x9

di (10109 + 7395 + 6184 + 5271 + 5197 + 4638 + 3996 + 3463 + 3033)
*49286

*Number of waves (memory & self-completion).

egen numwaves = rowtotal(x1 x2 x3 x4 x5 x6 x7 x8 x9)
tab1 numwaves
summ numwaves

*Took part at all waves (N=2004: 19.8%).
*Took part at only the 1st wave (N=1901).

gen all_waves=0
replace all_waves=1 if (x1==1) & (x2==1) & (x3==1) & (x4==1) & (x5==1) & (x6==1) & (x7==1) & (x8==1) & (x9==1)
tab all_waves indsex

gen first_wave=0
replace first_wave=1 if (x1==1) & (x2==0) & (x3==0) & (x4==0) & (x5==0) & (x6==0) & (x7==0) & (x8==0) & (x9==0)
tab first_wave

*Group number of waves.

recode numwaves (1=1) (2/5=2) (6/9=3)
label define numwaveslbl 1 "1" 2 "2-5" 3 "6-9" 
label values numwaves numwaveslbl
tab numwaves

*==============================.
*Table S1 (number of waves).
*==============================.

svyset [pweight=w1wgt]

*sex.

tab indsex numwaves
svy: tab indsex numwaves,col format(%9.0f) percent

*age at wave 1.

svy:mean age0,over(numwaves)
estat sd
estat size
svy: regress age0 i.numwaves
testparm i.numwaves

*memory at wave 1.

svy:mean memory0,over(numwaves)
estat sd
estat size
svy: regress memory0 i.numwaves
testparm i.numwaves

*support at wave 1.

svy:mean PSall0,over(numwaves)
estat sd
estat size
svy: regress PSall0 i.numwaves
testparm i.numwaves

*strain at wave 1.

svy:mean NSall0,over(numwaves)
estat sd
estat size
svy: regress NSall0 i.numwaves
testparm i.numwaves

*educ.

tab topqual numwaves
svy: tab topqual numwaves,col format(%9.0f) percent

*wealth.
tab wealthq0 numwaves, missing
svy: tab wealthq0 numwaves,col format(%9.0f) percent missing

*smoke.
tab smoke0 numwaves, missing
svy: tab smoke0 numwaves,col format(%9.0f) percent missing

*alcohol.
tab drink0 numwaves, missing
svy: tab drink0 numwaves,col format(%9.0f) percent missing

*inactive.
tab actlevel0 numwaves, missing
svy: tab actlevel0 numwaves,col format(%9.0f) percent missing

*SPart at wave 1.

svy:mean SPart0,over(numwaves)
estat sd
estat size
svy: regress SPart0 i.numwaves
testparm i.numwaves

*ADL at wave 1.
svy:mean ADL0,over(numwaves)
estat sd
estat size
svy: regress ADL0 i.numwaves
testparm i.numwaves

*CESD at wave 1.
svy:mean CESD0,over(numwaves)
estat sd
estat size
svy: regress CESD0 i.numwaves
testparm i.numwaves



















