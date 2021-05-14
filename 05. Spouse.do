
*==========================================.
*Spousal support/strain.
*Main analysis (Table 3B)
*Sensitivity analyses:
*Joint Model
*Completers
*==========================================.

log using "C:\JingPaper\Resubmission\Spouse_Support.log", replace

clear
cd C:\ELSA\Datasets
use "AnalysisFile.dta", clear

generate flag=0
replace flag=1 if inrange(memory0,0,20) & (sc_outcome0==1)
tab1 flag
keep if flag==1
count

keep idauniq indsex w1wgt memory* PS_Spouse* NS_Spouse* ///
age* SPart* smoke* drink* ADL* CESD* actlevel* couple* topqual wealthq0 ProblemsW0 DiagnosedW0 ///
spouse* sc_outcome*

reshape long memory PS_Spouse NS_Spouse spouse age SPart smoke drink ADL CESD actlevel couple sc_outcome, i(idauniq) j(occasion)
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

keep idauniq indsex memory PS_Spouse NS_Spouse spouse ///
wealthq0 topqual ADL CESD SPart couple ptests ///
occasion occasionsq agebl_65 agesq w1wgt ProblemsW0 DiagnosedW0 ///
smoke drink actlevel

mi set mlong
mi misstable summarize PS_Spouse NS_Spouse spouse occasionsq ptests wealthq0 topqual ADL CESD SPart smoke drink actlevel

mi reshape wide memory PS_Spouse NS_Spouse spouse occasionsq ptests ADL CESD SPart couple smoke drink actlevel, i(idauniq) j(occasion)

*Variables to impute.

mi register imputed  ///
PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6 PS_Spouse7 PS_Spouse8 ///
NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6 NS_Spouse7 NS_Spouse8 ///
spouse0 spouse1 spouse2 spouse3 spouse4 spouse5 spouse6 spouse7 spouse8 ///
wealthq0 topqual ///
CESD0 CESD1 CESD2 CESD3 CESD4 CESD5 CESD6 CESD7 CESD8 ///
ADL0 ADL1 ADL2 ADL3 ADL4 ADL5 ADL6 ADL7 ADL8 ///
SPart0 SPart1 SPart2 SPart3 SPart4 SPart5 SPart6 SPart7 SPart8 ///
smoke0 smoke1 smoke2 smoke3 smoke4 smoke5 smoke6 smoke7 smoke8 ///
drink0 drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 ///
actlevel0 actlevel1 actlevel2 actlevel3 actlevel4 actlevel5 actlevel6 actlevel7 actlevel8 

mi impute chained ///
(logit) spouse0 ///
(pmm, knn(10) cond(if spouse0==1)) PS_Spouse0 ///
(logit,include(spouse0)) spouse1 ///
(pmm, knn(10) include(PS_Spouse0) cond(if spouse1==1)) PS_Spouse1 ///
(logit,include(spouse0 spouse1)) spouse2 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1) cond(if spouse2==1)) PS_Spouse2 ///
(logit,include(spouse0 spouse1 spouse2)) spouse3 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2) cond(if spouse3==1)) PS_Spouse3 ///
(logit,include(spouse0 spouse1 spouse2 spouse3)) spouse4 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3) cond(if spouse4==1)) PS_Spouse4 ///
(logit,include(spouse0 spouse1 spouse2 spouse3 spouse4)) spouse5 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4) cond(if spouse5==1)) PS_Spouse5 ///
(logit,include(spouse0 spouse1 spouse2 spouse3 spouse4 spouse5)) spouse6 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5) cond(if spouse6==1)) PS_Spouse6 ///
(logit,include(spouse0 spouse1 spouse2 spouse3 spouse4 spouse5 spouse6)) spouse7 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6) cond(if spouse7==1)) PS_Spouse7 ///
(logit,include(spouse0 spouse1 spouse2 spouse3 spouse4 spouse5 spouse6 spouse7)) spouse8 ///
(pmm, knn(10) include(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6 PS_Spouse7) cond(if spouse8==1)) PS_Spouse8 ///
(pmm, knn(10) cond(if spouse0==1)) NS_Spouse0 ///
(pmm, knn(10) include(NS_Spouse0) cond(if spouse1==1)) NS_Spouse1 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1) cond(if spouse2==1)) NS_Spouse2 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2) cond(if spouse3==1)) NS_Spouse3 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3) cond(if spouse4==1)) NS_Spouse4 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4) cond(if spouse5==1)) NS_Spouse5 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5) cond(if spouse6==1)) NS_Spouse6 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6) cond(if spouse7==1)) NS_Spouse7 ///
(pmm, knn(10) include(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6 NS_Spouse7) cond(if spouse8==1)) NS_Spouse8 ///
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
,add(10) rseed (0659814) orderasis noimputed augment

*Data in wide form.

mi xeq: egen PSmean=rowmean(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6 PS_Spouse7 PS_Spouse8)
mi xeq: egen NSmean=rowmean(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6 NS_Spouse7 NS_Spouse8)
mi xeq: egen PSgrand = mean(PSmean)
mi xeq: egen NSgrand = mean(NSmean)

*Centre person-mean variables.

mi xeq: gen PS_SpouseBP = PSmean-PSgrand
mi xeq: gen NS_SpouseBP = NSmean-NSgrand

mi xeq: gen PS_SpouseWP0 = (PS_Spouse0 - PSmean)
mi xeq: gen PS_SpouseWP1 = (PS_Spouse1 - PSmean)
mi xeq: gen PS_SpouseWP2 = (PS_Spouse2 - PSmean)
mi xeq: gen PS_SpouseWP3 = (PS_Spouse3 - PSmean)
mi xeq: gen PS_SpouseWP4 = (PS_Spouse4 - PSmean)
mi xeq: gen PS_SpouseWP5 = (PS_Spouse5 - PSmean)
mi xeq: gen PS_SpouseWP6 = (PS_Spouse6 - PSmean)
mi xeq: gen PS_SpouseWP7 = (PS_Spouse7 - PSmean)
mi xeq: gen PS_SpouseWP8 = (PS_Spouse8 - PSmean)
mi xeq: gen NS_SpouseWP0 = (NS_Spouse0 - NSmean)
mi xeq: gen NS_SpouseWP1 = (NS_Spouse1 - NSmean)
mi xeq: gen NS_SpouseWP2 = (NS_Spouse2 - NSmean)
mi xeq: gen NS_SpouseWP3 = (NS_Spouse3 - NSmean)
mi xeq: gen NS_SpouseWP4 = (NS_Spouse4 - NSmean)
mi xeq: gen NS_SpouseWP5 = (NS_Spouse5 - NSmean)
mi xeq: gen NS_SpouseWP6 = (NS_Spouse6 - NSmean)
mi xeq: gen NS_SpouseWP7 = (NS_Spouse7 - NSmean)
mi xeq: gen NS_SpouseWP8 = (NS_Spouse8 - NSmean)

mi reshape long memory PS_SpouseWP NS_SpouseWP CESD ADL SPart occasionsq ptests couple smoke drink actlevel,i(idauniq) j(occasion)   

*Run the full models for men and women.
*Check the PM and WP interaction.

mi convert flong, clear

misum PS_SpouseBP PS_SpouseWP NS_SpouseBP NS_SpouseWP if indsex==1
misum PS_SpouseBP PS_SpouseWP NS_SpouseBP NS_SpouseWP if indsex==2

*Men.

mi estimate, saving(miestfile3, replace) esample(esample3): mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PS_SpouseBP c.occasion#c.PS_SpouseBP c.PS_SpouseWP c.occasion#c.PS_SpouseWP  ///
c.NS_SpouseBP c.occasion#c.NS_SpouseBP c.NS_SpouseWP c.occasion#c.NS_SpouseWP if indsex==1 /// 
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)

*Women.

mi estimate, saving(miestfile4, replace) esample(esample4): mixed memory c.occasion c.occasionsq c.ptests c.agebl_65 c.agesq ///
c.occasion#c.ptests c.occasion#c.agebl_65 c.occasion#c.agesq c.occasionsq#c.agebl_65  ///
i.topqual c.occasion#i.topqual  ///
i.wealthq0 c.occasion#i.wealthq0  ///
i.smoke c.occasion#i.smoke ///
i.drink c.occasion#i.drink ///
i.actlevel c.occasion#i.actlevel ///
c.SPart c.occasion#c.SPart ///
c.CESD c.occasion#c.CESD ///
c.ADL c.occasion#c.ADL ///
c.PS_SpouseBP c.occasion#c.PS_SpouseBP c.PS_SpouseWP c.occasion#c.PS_SpouseWP  ///
c.NS_SpouseBP c.occasion#c.NS_SpouseBP c.NS_SpouseWP c.occasion#c.NS_SpouseWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w1wgt)  variance ml covariance(un) residuals(independent)


*============.
*Joint Model.
*============.

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

egen PSmean=rowmean(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6 PS_Spouse7 PS_Spouse8)
egen NSmean=rowmean(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6 NS_Spouse7 NS_Spouse8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PS_SpouseBP = PSmean-PSgrand
gen NS_SpouseBP = NSmean-NSgrand

gen PS_SpouseWP0 = (PS_Spouse0 - PSmean)
gen PS_SpouseWP1 = (PS_Spouse1 - PSmean)
gen PS_SpouseWP2 = (PS_Spouse2 - PSmean)
gen PS_SpouseWP3 = (PS_Spouse3 - PSmean)
gen PS_SpouseWP4 = (PS_Spouse4 - PSmean)
gen PS_SpouseWP5 = (PS_Spouse5 - PSmean)
gen PS_SpouseWP6 = (PS_Spouse6 - PSmean)
gen PS_SpouseWP7 = (PS_Spouse7 - PSmean)
gen PS_SpouseWP8 = (PS_Spouse8 - PSmean)

gen NS_SpouseWP0 = (NS_Spouse0 - NSmean)
gen NS_SpouseWP1 = (NS_Spouse1 - NSmean)
gen NS_SpouseWP2 = (NS_Spouse2 - NSmean)
gen NS_SpouseWP3 = (NS_Spouse3 - NSmean)
gen NS_SpouseWP4 = (NS_Spouse4 - NSmean)
gen NS_SpouseWP5 = (NS_Spouse5 - NSmean)
gen NS_SpouseWP6 = (NS_Spouse6 - NSmean)
gen NS_SpouseWP7 = (NS_Spouse7 - NSmean)
gen NS_SpouseWP8 = (NS_Spouse8 - NSmean)

count
by idauniq, sort: generate ptests=_n
*Subtract by 1.
replace ptests = ptests-1

keep idauniq indsex iintdtm* iintdty* memory* asample* dead dod w0int ///
ptests topqual wealthq0 smoke* drink* actlevel* SPart* CESD* ADL* ///
agebl_65 agesq PS_SpouseBP PS_SpouseWP* NS_SpouseBP NS_SpouseWP*

reshape long iintdtm iintdty memory asample smoke drink actlevel SPart CESD ADL PS_SpouseWP NS_SpouseWP, i(idauniq) j(occasion)
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

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_SpouseBP NS_SpouseBP PS_SpouseWP NS_SpouseWP if indsex==1, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_SpouseBP NS_SpouseBP PS_SpouseWP NS_SpouseWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) 

stjm memory agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_SpouseBP NS_SpouseBP PS_SpouseWP NS_SpouseWP if indsex==2, panel(idauniq) ///
timeinteraction(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL PS_SpouseBP NS_SpouseBP PS_SpouseWP NS_SpouseWP) ///
survm(weibull) rfp(1) ///
survcov(agebl_65 agesq topqual1 topqual2 wealth2 wealth3 wealth4 wealth5 smoke drink actlevel SPart CESD ADL) 

*================.
*Complete cases.
*================.

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

keep idauniq indsex w1wgt memory* PS_Spouse* NS_Spouse* age* SPart* smoke* drink* ADL* CESD* actlevel*    ///
couple* topqual wealthq0 ProblemsW0 DiagnosedW0 sc_outcome* w8w1lwgt

*Data in wide form.

egen PSmean=rowmean(PS_Spouse0 PS_Spouse1 PS_Spouse2 PS_Spouse3 PS_Spouse4 PS_Spouse5 PS_Spouse6 PS_Spouse7 PS_Spouse8)
egen NSmean=rowmean(NS_Spouse0 NS_Spouse1 NS_Spouse2 NS_Spouse3 NS_Spouse4 NS_Spouse5 NS_Spouse6 NS_Spouse7 NS_Spouse8)
egen PSgrand = mean(PSmean)
egen NSgrand = mean(NSmean)

*Centre person-mean variables.

gen PS_SpouseBP = PSmean-PSgrand
gen NS_SpouseBP = NSmean-NSgrand

gen PS_SpouseWP0 = (PS_Spouse0 - PSmean)
gen PS_SpouseWP1 = (PS_Spouse1 - PSmean)
gen PS_SpouseWP2 = (PS_Spouse2 - PSmean)
gen PS_SpouseWP3 = (PS_Spouse3 - PSmean)
gen PS_SpouseWP4 = (PS_Spouse4 - PSmean)
gen PS_SpouseWP5 = (PS_Spouse5 - PSmean)
gen PS_SpouseWP6 = (PS_Spouse6 - PSmean)
gen PS_SpouseWP7 = (PS_Spouse7 - PSmean)
gen PS_SpouseWP8 = (PS_Spouse8 - PSmean)

gen NS_SpouseWP0 = (NS_Spouse0 - NSmean)
gen NS_SpouseWP1 = (NS_Spouse1 - NSmean)
gen NS_SpouseWP2 = (NS_Spouse2 - NSmean)
gen NS_SpouseWP3 = (NS_Spouse3 - NSmean)
gen NS_SpouseWP4 = (NS_Spouse4 - NSmean)
gen NS_SpouseWP5 = (NS_Spouse5 - NSmean)
gen NS_SpouseWP6 = (NS_Spouse6 - NSmean)
gen NS_SpouseWP7 = (NS_Spouse7 - NSmean)
gen NS_SpouseWP8 = (NS_Spouse8 - NSmean)

reshape long memory PS_SpouseWP NS_SpouseWP age SPart smoke drink ADL CESD actlevel couple sc_outcome, i(idauniq) j(occasion)
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
c.PS_SpouseBP c.occasion#c.PS_SpouseBP c.PS_SpouseWP c.occasion#c.PS_SpouseWP  ///
c.NS_SpouseBP c.occasion#c.NS_SpouseBP c.NS_SpouseWP c.occasion#c.NS_SpouseWP if indsex==1 /// 
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
c.PS_SpouseBP c.occasion#c.PS_SpouseBP c.PS_SpouseWP c.occasion#c.PS_SpouseWP  ///
c.NS_SpouseBP c.occasion#c.NS_SpouseBP c.NS_SpouseWP c.occasion#c.NS_SpouseWP if indsex==2 /// 
|| idauniq: c.occasion, pweight(w8w1lwgt)  variance ml covariance(un) residuals(independent)

log close




























































