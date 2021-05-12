*==========================================.
*Global support/strain.
*Baseline model (Table 2)
*Main analysis (Table 3A)
*Sensitivity analyses:
*Joint Model
*Completers
*==========================================.

log using "C:\JingPaper\Resubmission\Global_Support.log", replace

clear
cd C:\ELSA\Datasets
use "AnalysisFile.dta", clear

*Time-invariant flag (must have taken part at wave 1).

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

*Analytical sample at each wave .

generate asample0=0
generate asample1=0
generate asample2=0
generate asample3=0
generate asample4=0
generate asample5=0
generate asample6=0
generate asample7=0
generate asample8=0

replace asample0=1 if inrange(memory0,0,20) & (sc_outcome0==1)
replace asample1=1 if inrange(memory1,0,20) & (sc_outcome1==1) & (asample0==1)
replace asample2=1 if inrange(memory2,0,20) & (sc_outcome2==1) & (asample0==1)
replace asample3=1 if inrange(memory3,0,20) & (sc_outcome3==1) & (asample0==1)
replace asample4=1 if inrange(memory4,0,20) & (sc_outcome4==1) & (asample0==1)
replace asample5=1 if inrange(memory5,0,20) & (sc_outcome5==1) & (asample0==1)
replace asample6=1 if inrange(memory6,0,20) & (sc_outcome6==1) & (asample0==1)
replace asample7=1 if inrange(memory7,0,20) & (sc_outcome7==1) & (asample0==1)
replace asample8=1 if inrange(memory8,0,20) & (sc_outcome8==1) & (asample0==1)

tab1 asample0  /*10,109 */
tab1 asample1  /*7,395 */
tab1 asample2   /*6,184 */
tab1 asample3   /*5,271 */
tab1 asample4   /*5,197 */
tab1 asample5   /*4,638 */
tab1 asample6   /*3,996 */
tab1 asample7   /*3,463 */
tab1 asample8   /*3,003 */

*N=49286.
*di (10109 + 7395 + 6184 + 5271 + 5197 + 4638 + 3996 + 3463 + 3033)

keep idauniq indsex w1wgt memory* PSall* NSall* age* SPart* smoke* drink* ADL* CESD* actlevel*    ///
couple* topqual wealthq0 ProblemsW0 DiagnosedW0 sc_outcome* asample* 

reshape long memory PSall NSall age SPart smoke drink ADL CESD actlevel couple sc_outcome asample, i(idauniq) j(occasion)
generate occasionsq = occasion*occasion

*==========================.
*Baseline model.
*constant + 6 terms: 
*==========================.

*N=10,109: N=49,286.
*Pool over sex.

mixed memory c.occasion c.occasionsq c.agebl_65 c.agesq ///
c.occasion#c.agebl_65 c.occasion#c.agesq ///
|| idauniq: c.occasion if (asample==1), pweight(w1wgt)  variance ml covariance(un) residuals(independent)
gen base=e(sample)
tab base
tab indsex base
keep if base==1

*===================.
*Baseline models.
*Table S2; Figure 1.
*===================.

*Males (N=21,818); Females (N=27,468).
*c.occasion#c.agesq (P>0.05).

*=====.
*Men.
*=====.

mixed memory c.occasion c.occasionsq c.agebl_65 c.agesq ///
c.occasion#c.agebl_65 if (indsex==1 & asample==1) ///
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)
nlcom (-_b[occasion]/(2*_b[occasionsq]))             /* maximum */

*Plot.
margins, at(occasion=0 occasionsq=0 agebl_65=0 agesq=0) 
margins, at(occasion=2 occasionsq=4 agebl_65=0 agesq=0) 
margins, at(occasion=4 occasionsq=16 agebl_65=0 agesq=0) 
margins, at(occasion=6 occasionsq=36 agebl_65=0 agesq=0) 
margins, at(occasion=8 occasionsq=64 agebl_65=0 agesq=0)

*=====.
*Women.
*=====.

mixed memory c.occasion c.occasionsq c.agebl_65 c.agesq ///
c.occasion#c.agebl_65 if (indsex==2 & asample==1) ///
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)
nlcom (-_b[occasion]/(2*_b[occasionsq]))              /* maximum */

*Plot.
margins, at(occasion=0 occasionsq=0 agebl_65=0 agesq=0) 
margins, at(occasion=2 occasionsq=4 agebl_65=0 agesq=0) 
margins, at(occasion=4 occasionsq=16 agebl_65=0 agesq=0) 
margins, at(occasion=6 occasionsq=36 agebl_65=0 agesq=0) 
margins, at(occasion=8 occasionsq=64 agebl_65=0 agesq=0)

*Number of prior word-recall assessments.
*Done after restricting on the N=49,286.

count
by idauniq, sort: generate ptests=_n

*Subtract by 1.
replace ptests = ptests-1

keep idauniq indsex memory ADL CESD SPart couple ptests occasion occasionsq agebl_65 agesq w1wgt ///
PSall NSall topqual wealthq0 ProblemsW0 DiagnosedW0 smoke drink actlevel 
count  /* N=49,286 */

*Multiple Imputation.

mi set mlong
mi misstable summarize PSall NSall occasionsq ptests wealthq0 topqual ADL CESD SPart smoke drink actlevel
mi reshape wide memory PSall NSall occasionsq ptests ADL CESD SPart couple smoke drink actlevel, i(idauniq) j(occasion)

*Variables to impute.

mi register imputed  ///
PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6 PSall7 PSall8 ///
NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6 NSall7 NSall8 wealthq0 topqual ///
CESD0 CESD1 CESD2 CESD3 CESD4 CESD5 CESD6 CESD7 CESD8 ///
ADL0 ADL1 ADL2 ADL3 ADL4 ADL5 ADL6 ADL7 ADL8 ///
SPart0 SPart1 SPart2 SPart3 SPart4 SPart5 SPart6 SPart7 SPart8 ///
smoke0 smoke1 smoke2 smoke3 smoke4 smoke5 smoke6 smoke7 smoke8 ///
drink0 drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 ///
actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5 actlevel6 actlevel7 actlevel8 

*10 imputations.

mi impute chained ///
(pmm,knn(10)) PSall0  ///
(pmm,knn(10) include(PSall0)) PSall1  ///
(pmm,knn(10) include(PSall0 PSall1)) PSall2 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2)) PSall3 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2 PSall3)) PSall4 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2 PSall3 PSall4)) PSall5 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5)) PSall6 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6)) PSall7 ///
(pmm,knn(10) include(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6 PSall7)) PSall8 ///
(pmm,knn(10)) NSall0  ///
(pmm,knn(10) include(NSall0)) NSall1  ///
(pmm,knn(10) include(NSall0 NSall1)) NSall2 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2)) NSall3 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2 NSall3)) NSall4 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2 NSall3 NSall4)) NSall5 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5)) NSall6 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6)) NSall7 ///
(pmm,knn(10) include(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6 NSall7)) NSall8 ///
(pmm,knn(10)) CESD0  ///
(pmm,knn(10) include(CESD0)) CESD1  ///
(pmm,knn(10) include(CESD0 CESD1)) CESD2 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2)) CESD3 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2 CESD3)) CESD4 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2 CESD3 CESD4)) CESD5 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2 CESD3 CESD4 CESD5)) CESD6 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2 CESD3 CESD4 CESD5 CESD6)) CESD7 ///
(pmm,knn(10) include(CESD0 CESD1 CESD2 CESD3 CESD4 CESD5 CESD6 CESD7)) CESD8 ///
(pmm,knn(10)) ADL0  ///
(pmm,knn(10) include(ADL0)) ADL1  ///
(pmm,knn(10) include(ADL0 ADL1)) ADL2 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2)) ADL3 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2 ADL3)) ADL4 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2 ADL3 ADL4)) ADL5 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2 ADL3 ADL4 ADL5)) ADL6 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2 ADL3 ADL4 ADL5 ADL6)) ADL7 ///
(pmm,knn(10) include(ADL0 ADL1 ADL2 ADL3 ADL4 ADL5 ADL6 ADL7)) ADL8 ///
(pmm,knn(10)) SPart0  ///
(pmm,knn(10) include(SPart0)) SPart1  ///
(pmm,knn(10) include(SPart0 SPart1)) SPart2 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2)) SPart3 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2 SPart3)) SPart4 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2 SPart3 SPart4)) SPart5 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2 SPart3 SPart4 SPart5)) SPart6 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2 SPart3 SPart4 SPart5 SPart6)) SPart7 ///
(pmm,knn(10) include(SPart0 SPart1 SPart2 SPart3 SPart4 SPart5 SPart6 SPart7)) SPart8 ///
(pmm,knn(10)) smoke0  ///
(pmm,knn(10) include(smoke0)) smoke1  ///
(pmm,knn(10) include(smoke0 smoke1)) smoke2 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2)) smoke3 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2 smoke3)) smoke4 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2 smoke3 smoke4)) smoke5 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2 smoke3 smoke4 smoke5)) smoke6 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2 smoke3 smoke4 smoke5 smoke6)) smoke7 ///
(pmm,knn(10) include(smoke0 smoke1 smoke2 smoke3 smoke4 smoke5 smoke6 smoke7)) smoke8 ///
(pmm,knn(10)) drink0  ///
(pmm,knn(10) include(drink0)) drink1  ///
(pmm,knn(10) include(drink0 drink1)) drink2 ///
(pmm,knn(10) include(drink0 drink1 drink2)) drink3 ///
(pmm,knn(10) include(drink0 drink1 drink2 drink3)) drink4 ///
(pmm,knn(10) include(drink0 drink1 drink2 drink3 drink4)) drink5 ///
(pmm,knn(10) include(drink0 drink1 drink2 drink3 drink4 drink5)) drink6 ///
(pmm,knn(10) include(drink0 drink1 drink2 drink3 drink4 drink5 drink6)) drink7 ///
(pmm,knn(10) include(drink0 drink1 drink2 drink3 drink4 drink5 drink6 drink7)) drink8 ///
(pmm,knn(10)) actlevel0  ///
(pmm,knn(10) include(actlevel0)) actlevel1  ///
(pmm,knn(10) include(actlevel0 actlevel1)) actlevel2 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2)) actlevel3 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2 actlevel3)) actlevel4 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2 actlevel3 actlevel4)) actlevel5 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5)) actlevel6 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5 actlevel6)) actlevel7 ///
(pmm,knn(10) include(actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5 actlevel6 actlevel7)) actlevel8 ///
(pmm,knn(10)) wealthq0 topqual ///
= w1wgt indsex agebl_65 memory0 couple0 ProblemsW0 DiagnosedW0 ///
,add(10) rseed (55368953) orderasis augment noimputed

*========================================================.
*Split support/strain variables into between and within.
*=======================================================.

*Data in wide form.

mi xeq: egen PSmean=rowmean(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6 PSall7 PSall8)
mi xeq: egen NSmean=rowmean(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6 NSall7 NSall8)
mi xeq: egen PSgrand = mean(PSmean)   /* for centering */
mi xeq: egen NSgrand = mean(NSmean)   /* for centering */

*Centre person-mean variables.

mi xeq: gen PSallBP = PSmean-PSgrand
mi xeq: gen NSallBP = NSmean-NSgrand

*Person-specific deviation scores.

mi xeq: gen PSallWP0 = (PSall0 - PSmean)
mi xeq: gen PSallWP1 = (PSall1 - PSmean)
mi xeq: gen PSallWP2 = (PSall2 - PSmean)
mi xeq: gen PSallWP3 = (PSall3 - PSmean)
mi xeq: gen PSallWP4 = (PSall4 - PSmean)
mi xeq: gen PSallWP5 = (PSall5 - PSmean)
mi xeq: gen PSallWP6 = (PSall6 - PSmean)
mi xeq: gen PSallWP7 = (PSall7 - PSmean)
mi xeq: gen PSallWP8 = (PSall8 - PSmean)
mi xeq: gen NSallWP0 = (NSall0 - NSmean)
mi xeq: gen NSallWP1 = (NSall1 - NSmean)
mi xeq: gen NSallWP2 = (NSall2 - NSmean)
mi xeq: gen NSallWP3 = (NSall3 - NSmean)
mi xeq: gen NSallWP4 = (NSall4 - NSmean)
mi xeq: gen NSallWP5 = (NSall5 - NSmean)
mi xeq: gen NSallWP6 = (NSall6 - NSmean)
mi xeq: gen NSallWP7 = (NSall7 - NSmean)
mi xeq: gen NSallWP8 = (NSall8 - NSmean)

mi reshape long memory PSallWP NSallWP CESD ADL SPart occasionsq ptests couple smoke drink actlevel,i(idauniq) j(occasion)   

mi convert flong, clear

*====================================.
*Men.
*test interaction between BP and WP.
*====================================.

*mi estimate: mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
*c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
*i.topqual c.occasion#i.topqual  ///
*i.wealthq0 c.occasion#i.wealthq0  ///
*i.smoke c.occasion#i.smoke ///
*i.drink c.occasion#i.drink ///
*i.actlevel c.occasion#i.actlevel ///
*c.SPart c.occasion#c.SPart ///
*c.CESD c.occasion#c.CESD ///
*c.ADL c.occasion#c.ADL ///
*c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP c.PSallBP#c.PSallWP  ///
*c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP c.NSallBP#c.NSallWP if indsex==1 /// 
*|| idauniq: c.occasion, pweight(w1wgt) variance ml covariance(un) residuals(independent)
*mi test c.PSallBP#c.PSallWP    
*mi test c.NSallBP#c.NSallWP

*===================================.
*Women.
*test interaction between BP and WP.
*====================================.

*mi estimate: mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
*c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
*i.topqual  c.occasion#i.topqual  ///
*i.wealthq0 c.occasion#i.wealthq0  ///
*i.smoke c.occasion#i.smoke ///
*i.drink c.occasion#i.drink ///
*i.actlevel c.occasion#i.actlevel ///
*c.SPart c.occasion#c.SPart ///
*c.CESD c.occasion#c.CESD ///
*c.ADL c.occasion#c.ADL ///
*c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP c.PSallBP#c.PSallWP  ///
*c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP c.NSallBP#c.NSallWP if indsex==2 /// 
*|| idauniq: c.occasion, pweight(w1wgt) variance ml covariance(un) residuals(independent)
*mi test c.PSallBP#c.PSallWP 
*mi test c.NSallBP#c.NSallWP


*=========================================.
*Now without the cross-level interactions.
*Table 3A.
*==========================================.

*=====.
*Men.
*=====.

mi estimate: mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP  ///
c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP if indsex==1 /// 
|| idauniq: c.occasion, pweight(w1wgt) variance ml covariance(un) residuals(independent)

*=====.
*Women.
*=====.

mi estimate: mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual  c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP  ///
c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w1wgt) variance ml covariance(un) residuals(independent)


*===========================================.
*Joint Model (no multiple imputation)
*===========================================.

use "AnalysisFile.dta", clear

*Time-invariant flag (must have taken part at wave 1).

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

*n=10,109 participants at wave 1 followed.

*AS at each wave .

generate asample0=0
generate asample1=0
generate asample2=0
generate asample3=0
generate asample4=0
generate asample5=0
generate asample6=0
generate asample7=0
generate asample8=0

replace asample0=1 if inrange(memory0,0,20) & (sc_outcome0==1)
replace asample1=1 if inrange(memory1,0,20) & (sc_outcome1==1) & (asample0==1)
replace asample2=1 if inrange(memory2,0,20) & (sc_outcome2==1) & (asample0==1)
replace asample3=1 if inrange(memory3,0,20) & (sc_outcome3==1) & (asample0==1)
replace asample4=1 if inrange(memory4,0,20) & (sc_outcome4==1) & (asample0==1)
replace asample5=1 if inrange(memory5,0,20) & (sc_outcome5==1) & (asample0==1)
replace asample6=1 if inrange(memory6,0,20) & (sc_outcome6==1) & (asample0==1)
replace asample7=1 if inrange(memory7,0,20) & (sc_outcome7==1) & (asample0==1)
replace asample8=1 if inrange(memory8,0,20) & (sc_outcome8==1) & (asample0==1)

tab1 asample0  /*10,109 */
tab1 asample1  /*7,395 */
tab1 asample2   /*6,184 */
tab1 asample3   /*5,271 */
tab1 asample4   /*5,197 */
tab1 asample5   /*4,638 */
tab1 asample6   /*3,996 */
tab1 asample7   /*3,463 */
tab1 asample8   /*3,003 */

*======================.
*Wave1 interview date.
*=======================.
gen entry_m = iintdtm0
gen entry_y = iintdty0
gen w0int = mdy(entry_m,15,entry_y)

*================.
*date of death.
*===============.
gen dod = mdy(deadm,15,deady)

format w0int dod %td 

*==========================================.
*Social relationships: between and within.
*==========================================.

*Data in wide form.

egen PSmean=rowmean(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6 PSall7 PSall8)
egen NSmean=rowmean(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6 NSall7 NSall8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PSallBP = PSmean-PSgrand
gen NSallBP = NSmean-NSgrand

gen PSallWP0 = (PSall0 - PSmean)
gen PSallWP1 = (PSall1 - PSmean)
gen PSallWP2 = (PSall2 - PSmean)
gen PSallWP3 = (PSall3 - PSmean)
gen PSallWP4 = (PSall4 - PSmean)
gen PSallWP5 = (PSall5 - PSmean)
gen PSallWP6 = (PSall6 - PSmean)
gen PSallWP7 = (PSall7 - PSmean)
gen PSallWP8 = (PSall8 - PSmean)

gen NSallWP0 = (NSall0 - NSmean)
gen NSallWP1 = (NSall1 - NSmean)
gen NSallWP2 = (NSall2 - NSmean)
gen NSallWP3 = (NSall3 - NSmean)
gen NSallWP4 = (NSall4 - NSmean)
gen NSallWP5 = (NSall5 - NSmean)
gen NSallWP6 = (NSall6 - NSmean)
gen NSallWP7 = (NSall7 - NSmean)
gen NSallWP8 = (NSall8 - NSmean)

keep idauniq indsex iintdtm* iintdty* memory* asample* dead dod w0int ///
topqual wealthq0 smoke* drink* actlevel* SPart* CESD* ADL* ///
agebl_65 agesq PSallBP PSallWP* NSallBP NSallWP*

reshape long iintdtm iintdty memory asample smoke drink actlevel SPart CESD ADL PSallWP NSallWP, i(idauniq) j(occasion)
sort idauniq occasion
generate occasionsq = occasion*occasion
keep if memory!=.
keep if asample==1
tab1 occasion
count     
egen first = tag(idauniq) 
tab1 dead if first==1     /* 1947 deaths */
drop first

*Long dataset contains the same records as the main analysis.
*N=10,109 (with 49,286 observations).
*Dataset contains interview dates; binary variable for death; date-of-death.
*For each record the participant was alive.

*===========================================================.
*Analysis time = (interview date - baseline interview date).
*time at _n=1: W2 interview date (exit) - W1 interview date (w0int)
*time at _n=2: W3 interview date (exit) - W1 interview date (w0int)
*===========================================================.

*Beginning = w0int.
*Exit for each record = interview date of the next record.

by idauniq: gen exit_m = iintdtm[_n+1]     /* W2int_m moved to _n==1 */        
by idauniq: gen exit_y = iintdty[_n+1]     /* W2int_y moved to _n==1 */  
gen exit = mdy(exit_m,15,exit_y)
format exit %td 

list idauniq memory w0int iintdtm iintdty exit occasion in 1/7

*================================================================================================================.
*Censoring date MUST be on last record if dead==0.
*(i) set to 15/6/2012 if last interview date is before 15/6/2012 (including those only interviewed at baseline)
*(ii) set to 1 month (30 days) past the LAST interview date if that is after 2012.
*We only have mortality data to wave 6.
*================================================================================================================.

by idauniq: replace exit = mdy(6,15,2012) if (_n==_N) & dead==0 & inlist(occasion,0,1,2,3,4)
by idauniq: replace exit = (exit[_n-1]+30) if (_n==_N) & dead==0 & inlist(occasion,5,6,7,8)
list idauniq memory w0int iintdtm iintdty exit occasion in 1/7

*==============================================================.
*Dead=1 must be only on the last record: exit as time as death.
*==============================================================.

by idauniq: replace dead=0 if (_n!=_N) & dead==1
by idauniq: replace exit=dod if (_n==_N) & dead==1

*=====================.
*stset
*======================

drop if iintdtm==. & iintdty==.
generate time = (exit-w0int)/365.25 
stset time, id(idauniq) failure(dead==1) 

*========================================================.
*Binary variables as stjm does not use factor variables.
*=======================================================.

gen topqual0=0
gen topqual1=0
gen topqual2=0
replace topqual0=1 if topqual==0
replace topqual1=1 if topqual==1
replace topqual2=1 if topqual==2

gen wealth1=0
gen wealth2=0
gen wealth3=0
gen wealth4=0
gen wealth5=0
replace wealth1=1 if wealthq0==1
replace wealth2=1 if wealthq0==2
replace wealth3=1 if wealthq0==3
replace wealth4=1 if wealthq0==4
replace wealth5=1 if wealthq0==5

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PSallBP NSallBP PSallWP NSallWP if indsex==1, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PSallBP NSallBP PSallWP NSallWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) 

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PSallBP NSallBP PSallWP NSallWP if indsex==2, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PSallBP NSallBP PSallWP NSallWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) 

*=======================================.
*Complete cases.
*Uses the wave 8 longitudinal weight.
*=======================================.

use "AnalysisFile.dta", clear

*Time-invariant flag (must have taken part at wave 1).

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

*--------------------------------------------------.
*Number of waves based on memory & self-completion.
*--------------------------------------------------.

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

*Took part at all waves (N=2004: 19.8%).

gen all_waves=0
replace all_waves=1 if (x1==1) & (x2==1) & (x3==1) & (x4==1) & (x5==1) & (x6==1) & (x7==1) & (x8==1) & (x9==1)
tab all_waves indsex

*=====================.
*Subset = completers.
*=====================.

keep if all_waves==1

keep idauniq indsex w1wgt memory* PSall* NSall* age* SPart* smoke* drink* ADL* CESD* actlevel*    ///
couple* topqual wealthq0 ProblemsW0 DiagnosedW0 sc_outcome* all_waves w8w1lwgt

*Data in wide form.

egen PSmean=rowmean(PSall0 PSall1 PSall2 PSall3 PSall4 PSall5 PSall6 PSall7 PSall8)
egen NSmean=rowmean(NSall0 NSall1 NSall2 NSall3 NSall4 NSall5 NSall6 NSall7 NSall8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PSallBP = PSmean-PSgrand
gen NSallBP = NSmean-NSgrand

gen PSallWP0 = (PSall0 - PSmean)
gen PSallWP1 = (PSall1 - PSmean)
gen PSallWP2 = (PSall2 - PSmean)
gen PSallWP3 = (PSall3 - PSmean)
gen PSallWP4 = (PSall4 - PSmean)
gen PSallWP5 = (PSall5 - PSmean)
gen PSallWP6 = (PSall6 - PSmean)
gen PSallWP7 = (PSall7 - PSmean)
gen PSallWP8 = (PSall8 - PSmean)

gen NSallWP0 = (NSall0 - NSmean)
gen NSallWP1 = (NSall1 - NSmean)
gen NSallWP2 = (NSall2 - NSmean)
gen NSallWP3 = (NSall3 - NSmean)
gen NSallWP4 = (NSall4 - NSmean)
gen NSallWP5 = (NSall5 - NSmean)
gen NSallWP6 = (NSall6 - NSmean)
gen NSallWP7 = (NSall7 - NSmean)
gen NSallWP8 = (NSall8 - NSmean)

reshape long memory PSallWP NSallWP age SPart smoke drink ADL CESD actlevel couple sc_outcome, i(idauniq) j(occasion)
generate occasionsq = occasion*occasion

count
by idauniq, sort: generate ptests=_n

*Subtract by 1.
replace ptests = ptests-1

*Men.
*ptests could not be used (multicollinearity).

mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP  ///
c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP if indsex==1 /// 
|| idauniq: c.occasion, pweight(w8w1lwgt)  variance ml covariance(un) residuals(independent)

*Women.

mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual  c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PSallBP c.occasion#c.PSallBP c.PSallWP c.occasion#c.PSallWP  ///
c.NSallBP c.occasion#c.NSallBP c.NSallWP c.occasion#c.NSallWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w8w1lwgt)  variance ml covariance(un) residuals(independent)

log close


























