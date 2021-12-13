/*1*/
/*將血壓分組*/
data data1_1 ; 
set data1 ;
	if sbp >= 140 or dbp >= 90 then bp  = 1 ;
	else bp = 0 ;
run ; 
/*呈現表格*/
PROC FREQ DATA=data1_1;
	TABLE bp ;
RUN; 

/*2*/
/*呈現表格*/
PROC MEANS DATA=data1_1 mean std;
class sex;
VAR age sbp dbp bmi;
RUN;

PROC FREQ DATA=data1_1;
	TABLE bp*sex ;
RUN; 

/*檢定*/
PROC TTEST DATA=data1_1;
	CLASS sex;
	VAR age sbp dbp bmi bp;
RUN;

/*3*/
/*Kaplan-Meier analysis and Log-Rank test*/
ods graphics on;
proc lifetest data=data1_1 method=pl plots=(survival);
/*method:Kaplan-Meier estimates*/
time followup*stroke(0);
strata sex;
run;
ods graphics off;

/*4*/
libname hw3 'C:\Users\user\OneDrive - 國立台灣大學\108-2\流病\期末考\SAS HW\SAS Homework 3_for student' ;

/*fit regression model*/
data data2_1; set hw3.hw3_data2;
	bmi = weight / (height/100)**2 ; 
	if bmi < 18.5 then bmi_g = 0 ;
	else if bmi < 24 then bmi_g = 1 ;
	else if bmi >= 24 then bmi_g = 2 ;
	else  bmi_g= . ;
run ; 

/*linear regression*/
proc glm data=data2_1;
	class bmi_g; /*categorical variable*/
	model chol=bmi_g/solution; /*solution: to illustrate regression coefficients*/
run;

/*5*/
/*糖尿病event*/
data hw3.hw3_data2_2; set hw3.hw3_data2;
	if glu >= 126 then diabetes = 1 ;
	else diabetes = 0 ;
run;
/*fit logistic model*/
proc logistic data=hw3.hw3_data2_2;
	class smoke(ref='0') sex(ref='0') exercise(ref='0')/ param=ref;
	model diabetes(event='1')=smoke age sex weight exercise/ risklimits;
run;
