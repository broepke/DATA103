OPTIONS Nodate LS=78 PS=80;
Title "My title: Getting started with SAS";
Footnote My footnote: Brian Roepke DATA 103;
*Change to your name here;

DATA grade;
	INPUT ID gender $ quiz1 quiz2 hwgrade $;
	DATALINES;
 001 M 80 84 A 
 003 . 85 89 A 
 004 F 90 .  B 
 014 F .  99 B  
 023 . 75 59 C  
 101 M 89 74 . 
 ;
RUN;

PROC PRINT data=grade;
RUN;

Title;