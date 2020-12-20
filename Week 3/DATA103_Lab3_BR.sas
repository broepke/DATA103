/*PROBLEM 1*/
data weight2;                     
   input IDnumber $ Week1 Week16; 
   WeightLoss2=Week1-Week16;      
   datalines;         
2477 195  163
2431 220  198
2456 173  155
2412 135  116
;                           

proc print data=weight2; 
run;  
  
/*PROBLEM 2*/
data weight3;  
   infile datalines missover;  
   input IDnumber $ Week1 Week16;  
   WeightLoss2=Week1-Week16;
   datalines;  
2477 195  163
2431 
2456 173  155
2412 135  116
;   

proc print data=weight3; 
run;  

/*PROBLEM 3 - you need to write the code on question 1,2,3 before running*/
DATA quiz;
	infile DATALINES dlm=',' dsd; 
	length Name $10;
	input Name $ (Q1-Q5) ($);
	DATALINES;
Andrea,A,C,A,D,
William,B,C,A,D,A
Manchester,C,B,,A,C
 ,D,D,D,C,A
Annabelle,A,B,C,D,A
Run;

PROC PRINT  data = quiz;
	title 'Answers from students';
	var Name Q1-Q5;
RUN;