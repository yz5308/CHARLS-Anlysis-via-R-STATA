clear all
set more off
cap log close

cd "/Users/zhaoyijie/Desktop/edu_exp"

log using "dofile/eduexp",replace

use "datafile/Demographic_background.dta", clear 

merge 1:1 ID using"datafile/exp_income_wealth.dta"

keep if _merge==3

*处理教育经历数据*

gen edu=zbd001

drop if edu==.

replace edu=18 if edu==10
replace edu=16 if edu==9
replace edu=14 if edu==8
replace edu=11 if edu==7
replace edu=12 if edu==6
replace edu=9 if edu==5
replace edu=6 if edu==4
replace edu=5 if edu==3
replace edu=3 if edu==2
replace edu=0 if edu==1



*处理性别数据dummy*
gen gender=ba000_w2_3
replace gender=0 if gender==2
drop if gender==.

*处理户籍数据dummy*
gen hukou=zbc001
drop if hukou==.
replace hukou=0 if hukou==4
replace hukou=0 if hukou==1
replace hukou=1 if hukou==2
replace hukou=1 if hukou==3


*处理党员信息dummy*
gen com=ba006_w2_1
drop if com==.
replace com=0 if com==2



*处理婚姻状况dummy*
gen mar=be001
replace mar=0 if mar==4
replace mar=0 if mar==5
replace mar=0 if mar==6
replace mar=0 if mar==7
replace mar=1 if mar==3
replace mar=1 if mar==2
replace mar=1 if mar==3

drop if mar==.

*处理消费数据*
*均为个人年度消费数据*

gen exp=EXP_ND
gen imexp=IM_EXP_ND


drop if exp==0
drop if exp==.
drop if EXP1==0
drop if exp-EXP1==0

gen lgexp=log(exp)
gen lgimexp=log(imexp)

gen food=EXP1
gen enjoy=EXP5+EXP8+EXP9+EXP10+EXP13
gen daily=EXP4+EXP7+EXP11+EXP16+EXP17
gen tech=EXP2+EXP6+EXP14+EXP3
gen train=EXP15
gen medical=EXP18+EXP12


*处理收入数据*
gen income=INCOME_PC
gen lgincome=.
replace lgincome=log(income) if income>0
replace lgincome=-log(-income) if income<0
replace lgincome=0 if income==0
drop if income==.


*处理财富数据*
gen wealth=WEALTH_PC
gen lgwealth=.
replace lgwealth=log(wealth) if wealth>0
replace lgwealth=-log(-wealth) if wealth<0
replace lgwealth=0 if wealth==0
drop if wealth==.



*处理年龄数据*
replace zba002_1=ba002_1 if zba002_1==.
gen age= 2018-zba002_1
drop if age<=50
gen age2= age*age

drop if age>=100
drop if age==.


*恩格尔系数*
gen engel=food*100/exp

gen enjoyper=enjoy*100/exp
gen dailyper=daily*100/exp
gen techper=tech*100/exp
gen trainper=train*100/exp
gen medicalper=medical*100/exp

*统计性分析*
sum gender mar com hukou age income wealth
sum food enjoy daily tech train medical 
sum edu engel exp



*回归*
reg lgexp edu,r
outreg2 using exp.xls,replace bdec(3) sdec(3)
reg lgexp edu lgincom,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth age,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth age hukou,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth age hukou mar,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth age hukou mar com,r
outreg2 using exp.xls,append bdec(3) sdec(3)
reg lgexp edu lgincome lgwealth age hukou mar com gender,r
outreg2 using exp.xls,append bdec(3) sdec(3)


reg engel edu,r
outreg2 using engel.xls,replace bdec(3) sdec(3)
reg engel edu lgincom,r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth,r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth age,r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth age hukou, r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth age hukou mar,r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth age hukou mar com,r
outreg2 using engel.xls,append bdec(3) sdec(3)
reg engel edu lgincome lgwealth age hukou mar com gender,r
outreg2 using engel.xls,append bdec(3) sdec(3)



reg engel edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,replace bdec(3) sdec(3)
reg enjoyper edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,append bdec(3) sdec(3)
reg dailyper edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,append bdec(3) sdec(3)
reg techper edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,append bdec(3) sdec(3)
reg trainper edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,append bdec(3) sdec(3)
reg medicalper edu lgincome lgwealth age hukou mar com gender,r
outreg2 using expense.xls,append bdec(3) sdec(3)


histogram edu
histogram exp
histogram age
histogram mar
histogram com
histogram gender
histogram engel
 
graph pie exp, over(edu)
graph pie food enjoy daily tech train medical


graph twoway sunflower exp edu || lfit exp edu
graph twoway sunflower engel edu || lfit engel ed
