LIBNAME Mydata "~/Mydata/";

PROC FORMAT;
	VALUE $FMTRACE "AA"="African American" "H"="Hispanic" "OTH"="Other " 
		"C"="White";
RUN;

DATA survey;
	INFILE '~/Mydata/SURVEY.csv' dlm=',' firstobs=2;
	INPUT SUBJECT SATISFACTION AGE EDU GENDER$ ARRIVE$ RACE$ REASON TEMP 
		STAYMINUTES VERSION LOCATION$ MARRIED$;
RUN;

PROC FREQ ORDER=formatted DATA=survey;
	TABLES RACE;
	FORMAT RACE $FMTRACE.;
RUN;

DATA COINS;
	INPUT @1 CATEGORY $9. @11 NUMBER 3.;
	DATALINES;
CENTS 152
CENTS 100
NICKELS 49
DIMES 59
QUARTERS 21
HALF 44 
DOLLARS 21
;

PROC FREQ;
	WEIGHT NUMBER;
	TITLE 'Reading Summarized Count data';
	TABLES CATEGORY;
RUN;

/* Example: The Goodness-of-Fit */
data Peaplants;
	input COLORTYPE $ number;
	label COLORTYPE='Pea Plants Types';
	datalines;
YellowSmooth 315
YellowWrinkled 108
GreenSmooth 101
GreenWrinkled 32
;
Run;

PROC SORT data=peaplants;
	by descending number;
run;

PROC FREQ ORDER=DATA;
	WEIGHT number;
	TITLE 'GOODNESS OF FIT ANALYSIS';
	TABLES COLORTYPE / NOCUM CHISQ TESTP=(0.5625 0.1875 0.1875 0.0625);
RUN;

/* Chi-Square of Summarized Data for the Crime Case */
DATA DRINKERS;
	INPUT CRIME $ DRINKER COUNT;
	DATALINES;
Arson 1 50
Arson 0 43
Rape 1 88
Rape 0 62
Violence 1 155
Violence 0 110
Stealing 1 379
Stealing 0 300
Coining 1 18
Coining 0 14
Fraud 1 63
Fraud 0 144
;

PROC Format;
	value drinker 0='Non-Drinker' 1='Drinker';
run;

PROC FREQ DATA=DRINKERS;
	WEIGHT COUNT;
	TABLES CRIME*DRINKER/CHISQ;
	FORMAT drinker drinker.;
	TITLE 'Chi Square Analysis of a Contingency Table';
RUN;

PROC FREQ DATA=Mydata.rash;
	TABLES CLEANER*RASH / CHISQ;
	TITLE 'CHI-SQUARE ANALYSIS FOR A 2X2 TABLE';
RUN;

TITLE;
FOOTNOTE;

data onettest;
	input time @@;
	datalines;
3.5 4.2 4.5 4.8 5 5 5 5.5 5.5 5.5 6 6 
6 6 6.5 6.5 6.5 6.5 6.5 7.5 7.5 7.5 8 
8 8.5 8.5 8.5 9 9 6.5
;
run;

proc ttest data=onettest sides=2 alpha=0.1 h0=7;
	var time;
run;

proc univariate data=onettest MU0=7;
	var time;
run;

PROC CORR DATA=Mydata.SOMEDATA;
	VAR AGE TIME1 TIME2;
	TITLE "Example using PROC CORR";
RUN;

PROC CORR DATA=Mydata.SOMEDATA PLOTS=MATRIX;
	VAR AGE TIME1 TIME2;
	TITLE 'Example using PROC CORR';
RUN;

PROC CORR DATA=Mydata.SOMEDATA PLOTS=MATRIX(HISTOGRAM);
	VAR AGE TIME1 TIME2;
	TITLE 'Example using PROC CORR';
RUN;

DATA ART;
	INFILE '~/Mydata/art.csv' dlm=',';
	INPUT SUBJECT $ CREATE TASK;
RUN;

PROC REG data=art;
	MODEL TASK=CREATE;
	TITLE "Example Linear Regression using Proc Reg";
	RUN;
QUIT;