*==========================================.
*Family.
*Main analysis (Table 3C)
*Sensitivity analyses:
*Joint Model
*Completers
*==========================================.

log using "C:\JingPaper\Resubmission\Family.log", replace

clear
cd C:\ELSA\Datasets
use "AnalysisFile.dta", clear

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

keep idauniq indsex w1wgt memory* PS_Family* NS_Family* ///
age* SPart* smoke* drink* ADL* CESD* actlevel* couple* topqual wealthq0 ProblemsW0 DiagnosedW0 ///
family* sc_outcome*

reshape long memory PS_Family NS_Family family age SPart smoke drink ADL CESD actlevel couple sc_outcome, i(idauniq) j(occasion)
generate occasionsq = occasion*occasion

mixed memory c.occasion c.occasionsq c.agebl_65 c.agesq ///
c.occasion#c.agebl_65 c.occasion#c.agesq ///
|| idauniq: c.occasion if (sc_outcome==1), pweight(w1wgt)  variance ml covariance(un) residuals(independent)
gen asample=e(sample)
tab asample
tab indsex asample
keep if asample==1
drop asample

*Number of prior word-recall assessments.

by idauniq, sort: generate ptests=_n

*Subtract by 1.

replace ptests = ptests-1

keep idauniq indsex memory PS_Family NS_Family family ///
wealthq0 topqual ADL CESD SPart couple ptests ///
occasion occasionsq agebl_65 agesq w1wgt ProblemsW0 DiagnosedW0 ///
smoke drink actlevel

mi set mlong
mi misstable summarize PS_Family NS_Family family occasionsq ptests wealthq0 topqual ADL CESD SPart smoke drink actlevel
mi reshape wide memory PS_Family NS_Family family occasionsq ptests ADL CESD SPart couple smoke drink actlevel, i(idauniq) j(occasion)

*Variables to impute.

mi register imputed  ///
PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6 PS_Family7 PS_Family8 ///
NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6 NS_Family7 NS_Family8 ///
family0 family1 family2 family3 family4 family5 family6 family7 family8 ///
wealthq0 topqual ///
CESD0 CESD1 CESD2 CESD3 CESD4 CESD5 CESD6 CESD7 CESD8 ///
ADL0 ADL1 ADL2 ADL3 ADL4 ADL5 ADL6 ADL7 ADL8 ///
SPart0 SPart1 SPart2 SPart3 SPart4 SPart5 SPart6 SPart7 SPart8 ///
smoke0 smoke1 smoke2 smoke3 smoke4 smoke5 smoke6 smoke7 smoke8 ///
drink0 drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 ///
actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5 actlevel6 actlevel7 actlevel8 

mi impute chained ///
(logit) family0 ///
(pmm, knn(10) cond(if family0==1)) PS_Family0 ///
(logit,include(family0)) family1 ///
(pmm, knn(10) include(PS_Family0) cond(if family1==1)) PS_Family1 ///
(logit,include(family0 family1)) family2 ///
(pmm, knn(10) include(PS_Family0 PS_Family1) cond(if family2==1)) PS_Family2 ///
(logit,include(family0 family1 family2)) family3 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2) cond(if family3==1)) PS_Family3 ///
(logit,include(family0 family1 family2 family3)) family4 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2 PS_Family3) cond(if family4==1)) PS_Family4 ///
(logit,include(family0 family1 family2 family3 family4)) family5 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4) cond(if family5==1)) PS_Family5 ///
(logit,include(family0 family1 family2 family3 family4 family5)) family6 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5) cond(if family6==1)) PS_Family6 ///
(logit,include(family0 family1 family2 family3 family4 family5 family6)) family7 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6) cond(if family7==1)) PS_Family7 ///
(logit,include(family0 family1 family2 family3 family4 family5 family6 family7)) family8 ///
(pmm, knn(10) include(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6 PS_Family7) cond(if family8==1)) PS_Family8 ///
(pmm, knn(10) cond(if family0==1)) NS_Family0 ///
(pmm, knn(10) include(NS_Family0) cond(if family1==1)) NS_Family1 ///
(pmm, knn(10) include(NS_Family0 NS_Family1) cond(if family2==1)) NS_Family2 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2) cond(if family3==1)) NS_Family3 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2 NS_Family3) cond(if family4==1)) NS_Family4 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4) cond(if family5==1)) NS_Family5 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5) cond(if family6==1)) NS_Family6 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6) cond(if family7==1)) NS_Family7 ///
(pmm, knn(10) include(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6 NS_Family7) cond(if family8==1)) NS_Family8 ///
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
,add(10) rseed (06598911) orderasis noimputed augment

*Data in wide form.

mi xeq: egen PSmean=rowmean(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6 PS_Family7 PS_Family8)
mi xeq: egen NSmean=rowmean(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6 NS_Family7 NS_Family8)

mi xeq: egen PSgrand = mean(PSmean)
mi xeq: egen NSgrand = mean(NSmean)

*Centre person-mean variables.

mi xeq: gen PS_FamilyBP = PSmean-PSgrand
mi xeq: gen NS_FamilyBP = NSmean-NSgrand

mi xeq: gen PS_FamilyWP0 = (PS_Family0 - PSmean)
mi xeq: gen PS_FamilyWP1 = (PS_Family1 - PSmean)
mi xeq: gen PS_FamilyWP2 = (PS_Family2 - PSmean)
mi xeq: gen PS_FamilyWP3 = (PS_Family3 - PSmean)
mi xeq: gen PS_FamilyWP4 = (PS_Family4 - PSmean)
mi xeq: gen PS_FamilyWP5 = (PS_Family5 - PSmean)
mi xeq: gen PS_FamilyWP6 = (PS_Family6 - PSmean)
mi xeq: gen PS_FamilyWP7 = (PS_Family7 - PSmean)
mi xeq: gen PS_FamilyWP8 = (PS_Family8 - PSmean)
mi xeq: gen NS_FamilyWP0 = (NS_Family0 - NSmean)
mi xeq: gen NS_FamilyWP1 = (NS_Family1 - NSmean)
mi xeq: gen NS_FamilyWP2 = (NS_Family2 - NSmean)
mi xeq: gen NS_FamilyWP3 = (NS_Family3 - NSmean)
mi xeq: gen NS_FamilyWP4 = (NS_Family4 - NSmean)
mi xeq: gen NS_FamilyWP5 = (NS_Family5 - NSmean)
mi xeq: gen NS_FamilyWP6 = (NS_Family6 - NSmean)
mi xeq: gen NS_FamilyWP7 = (NS_Family7 - NSmean)
mi xeq: gen NS_FamilyWP8 = (NS_Family8 - NSmean)

mi reshape long memory PS_FamilyWP NS_FamilyWP CESD ADL SPart occasionsq ptests couple smoke drink actlevel,i(idauniq) j(occasion)   
mi convert flong, clear

misum PS_FamilyBP PS_FamilyWP NS_FamilyBP NS_FamilyWP if indsex==1
misum PS_FamilyBP PS_FamilyWP NS_FamilyBP NS_FamilyWP if indsex==2

*Men.

mi estimate, saving(miestfile7, replace) esample(esample7): mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual  c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PS_FamilyBP c.occasion#c.PS_FamilyBP c.PS_FamilyWP c.occasion#c.PS_FamilyWP  ///
c.NS_FamilyBP c.occasion#c.NS_FamilyBP c.NS_FamilyWP c.occasion#c.NS_FamilyWP if indsex==1 /// 
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)

*Women.

mi estimate, saving(miestfile8, replace) esample(esample8): mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual  c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PS_FamilyBP c.occasion#c.PS_FamilyBP c.PS_FamilyWP c.occasion#c.PS_FamilyWP  ///
c.NS_FamilyBP c.occasion#c.NS_FamilyBP c.NS_FamilyWP c.occasion#c.NS_FamilyWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)

*================.
*Joint model.
*================.

use "AnalysisFile.dta", clear

*Time-invariant flag (must have taken part at wave 1).

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

gen entry_m = iintdtm0
gen entry_y = iintdty0

gen w0int = mdy(entry_m,15,entry_y)
gen dod = mdy(deadm,15,deady)

format w0int dod %td 
drop entry_m entry_y deadm deady

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

*Data in wide form.

egen PSmean=rowmean(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6 PS_Family7 PS_Family8)
egen NSmean=rowmean(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6 NS_Family7 NS_Family8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PS_FamilyBP = PSmean-PSgrand
gen NS_FamilyBP = NSmean-NSgrand

gen PS_FamilyWP0 = (PS_Family0 - PSmean)
gen PS_FamilyWP1 = (PS_Family1 - PSmean)
gen PS_FamilyWP2 = (PS_Family2 - PSmean)
gen PS_FamilyWP3 = (PS_Family3 - PSmean)
gen PS_FamilyWP4 = (PS_Family4 - PSmean)
gen PS_FamilyWP5 = (PS_Family5 - PSmean)
gen PS_FamilyWP6 = (PS_Family6 - PSmean)
gen PS_FamilyWP7 = (PS_Family7 - PSmean)
gen PS_FamilyWP8 = (PS_Family8 - PSmean)

gen NS_FamilyWP0 = (NS_Family0 - NSmean)
gen NS_FamilyWP1 = (NS_Family1 - NSmean)
gen NS_FamilyWP2 = (NS_Family2 - NSmean)
gen NS_FamilyWP3 = (NS_Family3 - NSmean)
gen NS_FamilyWP4 = (NS_Family4 - NSmean)
gen NS_FamilyWP5 = (NS_Family5 - NSmean)
gen NS_FamilyWP6 = (NS_Family6 - NSmean)
gen NS_FamilyWP7 = (NS_Family7 - NSmean)
gen NS_FamilyWP8 = (NS_Family8 - NSmean)

count
by idauniq, sort: generate ptests=_n
*Subtract by 1.
replace ptests = ptests-1

keep idauniq indsex iintdtm* iintdty* memory* asample* dead dod w0int ///
ptests topqual wealthq0 smoke* drink* actlevel* SPart* CESD* ADL* ///
agebl_65 agesq PS_FamilyBP PS_FamilyWP* NS_FamilyBP NS_FamilyWP*

reshape long iintdtm iintdty memory asample smoke drink actlevel SPart CESD ADL PS_FamilyWP NS_FamilyWP, i(idauniq) j(occasion)
sort idauniq occasion
generate occasionsq = occasion*occasion
keep if memory!=.
keep if asample==1
tab1 occasion
count

*Beginning = w0int.
*Exit for each record = interview date of the next record.

by idauniq: gen exit_m = iintdtm[_n+1]         
by idauniq: gen exit_y = iintdty[_n+1]
gen exit = mdy(exit_m,15,exit_y)
format exit %td 

*Censoring date on last record if dead==0.
*15/6/2012 if last interview date is before 15/6/2012 (including those only interviewed at baseline)
*1 month (30 days) past the last interview date if that is after 2012.

by idauniq: replace exit = mdy(6,15,2012) if (_n==_N) & dead==0 & inlist(occasion,0,1,2,3,4)
by idauniq: replace exit = (exit[_n-1]+30) if (_n==_N) & dead==0 & inlist(occasion,5,6,7,8)

*Dead=1 must be only on the last record: exit as time as death.
by idauniq: replace dead=0 if (_n!=_N) & dead==1
by idauniq: replace exit=dod if (_n==_N) & dead==1

drop if iintdtm==. & iintdty==.

*Number of records = number of CF scores.

generate time = (exit-w0int)/365.25 
stset time, id(idauniq) failure(dead==1) 

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

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_FamilyBP NS_FamilyBP PS_FamilyWP NS_FamilyWP if indsex==1, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_FamilyBP NS_FamilyBP PS_FamilyWP NS_FamilyWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) gh(2) 

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_FamilyBP NS_FamilyBP PS_FamilyWP NS_FamilyWP if indsex==2, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_FamilyBP NS_FamilyBP PS_FamilyWP NS_FamilyWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) gh(2) difficult

*========================================.
*Complete cases.
*Uses the wave 8 longitudinal weight.
*========================================.

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

*Number of waves (memory & self-completion).

egen numwaves = rowtotal(x1 x2 x3 x4 x5 x6 x7 x8 x9)
tab1 numwaves

*Took part at all waves (N=2004: 19.8%).
*Took part at only the 1st wave (N=1901).

gen all_waves=0
replace all_waves=1 if (x1==1) & (x2==1) & (x3==1) & (x4==1) & (x5==1) & (x6==1) & (x7==1) & (x8==1) & (x9==1)
tab all_waves indsex
keep if all_waves==1

keep idauniq indsex w1wgt memory* PS_Family* NS_Family* age* SPart* smoke* drink* ADL* CESD* actlevel*    ///
couple* topqual wealthq0 ProblemsW0 DiagnosedW0 sc_outcome* all_waves w8w1lwgt

*Data in wide form.

egen PSmean=rowmean(PS_Family0 PS_Family1 PS_Family2 PS_Family3 PS_Family4 PS_Family5 PS_Family6 PS_Family7 PS_Family8)
egen NSmean=rowmean(NS_Family0 NS_Family1 NS_Family2 NS_Family3 NS_Family4 NS_Family5 NS_Family6 NS_Family7 NS_Family8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PS_FamilyBP = PSmean-PSgrand
gen NS_FamilyBP = NSmean-NSgrand

gen PS_FamilyWP0 = (PS_Family0 - PSmean)
gen PS_FamilyWP1 = (PS_Family1 - PSmean)
gen PS_FamilyWP2 = (PS_Family2 - PSmean)
gen PS_FamilyWP3 = (PS_Family3 - PSmean)
gen PS_FamilyWP4 = (PS_Family4 - PSmean)
gen PS_FamilyWP5 = (PS_Family5 - PSmean)
gen PS_FamilyWP6 = (PS_Family6 - PSmean)
gen PS_FamilyWP7 = (PS_Family7 - PSmean)
gen PS_FamilyWP8 = (PS_Family8 - PSmean)

gen NS_FamilyWP0 = (NS_Family0 - NSmean)
gen NS_FamilyWP1 = (NS_Family1 - NSmean)
gen NS_FamilyWP2 = (NS_Family2 - NSmean)
gen NS_FamilyWP3 = (NS_Family3 - NSmean)
gen NS_FamilyWP4 = (NS_Family4 - NSmean)
gen NS_FamilyWP5 = (NS_Family5 - NSmean)
gen NS_FamilyWP6 = (NS_Family6 - NSmean)
gen NS_FamilyWP7 = (NS_Family7 - NSmean)
gen NS_FamilyWP8 = (NS_Family8 - NSmean)

reshape long memory PS_FamilyWP NS_FamilyWP age SPart smoke drink ADL CESD actlevel couple sc_outcome, i(idauniq) j(occasion)
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
c.PS_FamilyBP c.occasion#c.PS_FamilyBP c.PS_FamilyWP c.occasion#c.PS_FamilyWP  ///
c.NS_FamilyBP c.occasion#c.NS_FamilyBP c.NS_FamilyWP c.occasion#c.NS_FamilyWP if indsex==1 /// 
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
c.PS_FamilyBP c.occasion#c.PS_FamilyBP c.PS_FamilyWP c.occasion#c.PS_FamilyWP  ///
c.NS_FamilyBP c.occasion#c.NS_FamilyBP c.NS_FamilyWP c.occasion#c.NS_FamilyWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w8w1lwgt)  variance ml covariance(un) residuals(independent)

log close


































