/*1*/
libname a 'D:\SAS' ;

PROC SORT data=a.Hw1_basic; 
	by ID ; 
RUN;

PROC SORT data=a.Hw1_health; 
	by ID ; 
RUN;

DATA a.hw1_data1;
merge a.Hw1_basic a.Hw1_health;
by ID;
RUN;

/*2*/

DATA a.hw1_data2; set a.hw1_data1;

BMI=weight/((height/100)**2);
if BMI<18.5 then  bmi_g='0';
else if BMI<24 then bmi_g='1';
else if BMI<27 then bmi_g='2';
else bmi_g='3';

if sbp<140 and dbp<90 then  pp='0';
else pp='1';

RUN;


/*3*/

PROC MEANS DATA=a.Hw1_data2 mean std cv;
VAR age weight BMI waist ;
RUN;

/*4*/
DATA a.Hw1_data4; set a.Hw1_data2;
if dm=8 then delete; 
run;

PROC FREQ DATA=a.Hw1_data4;
TABLE sex*dm /expected chisq ;
RUN;

PROC FREQ DATA=a.Hw1_data4;
    TABLE sex*dm / chisq expected fisher;
RUN;


/*5*/
PROC MEANS DATA=a.Hw1_data2 mean std cv;
CLASS sex;
VAR glu ;
RUN;

PROC TTEST DATA=a.Hw1_data2;
CLASS sex;
VAR glu;
RUN;


/*6*/

DATA a.Hw1_data6; set a.Hw1_data2;
if age<55 then age_g=0;
else age_g=1;
RUN;

PROC FREQ DATA=a.Hw1_data6;
TABLE age_g*htn age_g*stroke age_g*hl /nopercent nocol;
RUN; 

PROC SORT DATA=a.Hw1_data6;
by age_g;
RUN;

PROC GCHART DATA=a.Hw1_data6;
By age_g;
PIE htn stroke hl/type = percent ;
RUN;
QUIT;


