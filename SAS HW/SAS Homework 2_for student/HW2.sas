/*1*/

/*����������=1*/
data datac2; set datac ;
	if sbp >= 140 or dbp >= 90 then bp = 1 ;
	else bp = 0 ;
run ;

/*�إ�cox ph model*/
proc phreg data = datac2 ;
model followup*stroke(0)=sex bp/risklimits;
/*risklimit: to calculate the confidence interval*/
run;


/*2*/

/*��ƦX��*/
DATA data2c;
	merge data2_1 data2_2;
	by ID;
RUN;

/*�����N�¯g�Ըs(�F�T�����`)*/

data data2c2; set data2c ;

	/*?	�y��L�j�G�k�ʡ�90 �����B�k�ʡ�80 ���� */
	if sex = 1 and waist >= 90 then waistbig = 1 ;
	else if sex = 0 and waist >= 80 then waistbig = 1 ;
	else waistbig = 0 ;

	/*�������`�G���Y����130mmHg �εαi����85mmHg */
	if (sbp >= 130) or (dbp >= 85) then bphigh = 1 ;
	else bphigh  = 0 ;	

	/*���K�ׯ׳J�աG�k��<40mg/dl�B�k��<50mg/dl  */
	if sex = 1 and hdl < 40 then proteinless = 1 ;
	else if sex = 0 and hdl < 50 then proteinless = 1 ;
	else proteinless  = 0 ;	

	/*��}�ȹL���G�Ÿ���}��100 mg/dl  */
	if glu >= 100 then gluhigh = 1 ;
	else gluhigh  = 0 ;	

	/*�T�ĥ̪o�׹L���G�T�ĥ̪o�ס�150 mg/dl */
	if tri >= 150 then trihigh = 1 ;
	else trihigh  = 0 ;	

	/*�F�T��*/
	total = waistbig + bphigh + proteinless + gluhigh + trihigh ;
	if  total >= 3 then metabolic = 1 ;
	else metabolic = 0 ;
	
run ;

PROC FREQ DATA=  data2c2;
	TABLE metabolic;
RUN;


/*3*/

/*�p��BMI*/
data data2c3 ; set data2c ;
	BMI = weight / (( height / 100 ) ** 2 ) ; 
run;

/*to test the normal distribution*/
proc univariate data=data2c3 normal;
	var waist bmi; 
run;
/*Spearman's rank correlation coefficient*/
ods graphics on;
proc corr data=data2c3 plots=matrix spearman;
	var waist bmi;
run;
ods graphics off;


/*4*/
/*=Strength of association=*/
/*=�إ߸��=*/
data data4;
input htn$ diet$ count; /*�������w��=1 ���f��=1 ���*/
datalines;
1 1 24
1 0 36
0 1 60
0 0 180
;

proc freq data = data4 order=data ; 
	weight count; 
	tables htn*diet /chisq relrisk; 
run;
