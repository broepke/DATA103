DATA class;
	INPUT score @@;
	DATALINES;
56 78 84 73 90 44 76 87 92 75 85 67 90 84 74 64 73 78 69 56 87 73 100 54 81 78 69 64 73 65
;
RUN;

PROC UNIVARIATE DATA=class;
	VAR Score;
	TITLE;
RUN;

PROC UNIVARIATE DATA=class;
	VAR Score;
	HISTOGRAM Score / NORMAL;
	PROBPLOT Score;
	TITLE;
RUN;

DATA booklengths;
	INPUT numberofpages @@;
	DATALINES;
34 30 29 32 52 25 24 27 31 29
24 26 30 30 30 29 21 30 25 28
28 28 29 38 28 29 24 24 29 31
30 27 45 30 22 16 29 14 16 29
32 20 20 15 28 28 29 31 29 36
;
	*Produce summary statistics;

PROC MEANS DATA=booklengths N MEAN MEDIAN CLM ALPHA=.10;
	TITLE 'Summary of Picture Book Lengths';
RUN;

DATA Swim;
	INPUT Swimmer $ FinalTime SemiFinalTime @@;
	DATALINES;
RK 24.05 24.07 AH 24.28 24.45 MV 24.39 24.50 BS 24.46 24.57
FH 24.47 24.63 TA 24.61 24.71 JH 24.62 24.68 AV 24.69 24.64
;
RUN;

PROC TTEST DATA=Swim;
	TITLE '50m Freestyle Semifinal vs. Final Results';
	PAIRED SemiFinalTime * FinalTime;
RUN;

/* requests just the Summary and QQ plots */
PROC TTEST DATA=Swim PLOTS(ONLY)=(SUMMARYPLOT QQPLOT);
	TITLE '50m Freestyle Semifinal vs. Final Results';
	PAIRED SemiFinalTime * FinalTime;
RUN;

DATA bus;
	INPUT BusType $ OnTimeOrLate $ @@;
	DATALINES;
E O E L E L R O E O E O E O R L R O R L R O E O R L E O R L R O E O
E O R L E L E O R L E O R L E O R L E O R O E L E O E O E O E O E L
E O E O R L R L R O R L E L E O R L R O E O E O E O E L R O R L  
;
RUN;

PROC FREQ DATA=bus;
	TABLES BusType * OnTimeOrLate / CHISQ;
	TITLE;
RUN;

PROC FORMAT;
	VALUE $type 'R'='Regular' 'E'='Express';
	VALUE $late 'O'='On Time' 'L'='Late';
RUN;

PROC FREQ DATA=bus;
	TABLES BusType * OnTimeOrLate / PLOTS=FREQPLOT(TWOWAY=GROUPHORIZONTAL);
	FORMAT BusType $Type. OnTimeOrLate $Late.;
RUN;

DATA class2;
	INPUT Score Television Exercise @@;
	datalines;
56 6 2   78 7 4   84 5 5   73 4 0   90 3 4
44 9 0   76 5 1   87 3 3   92 2 7   75 8 3
85 1 6   67 4 2   90 5 5   84 6 5   74 5 2
64 4 1   73 0 5   78 5 2   69 6 1   56 7 1
87 8 4   73 8 3  100 0 6   54 8 0   81 5 4
78 5 2   69 4 1   64 7 1   73 7 3   65 6 2  
;
RUN;

PROC CORR DATA=class2;
	VAR Television Exercise;
	WITH Score;
	TITLE 'Correlations for Test Scores';
	TITLE2 'With Hours of Television and Exercise';
RUN;

PROC CORR DATA = class2 PLOTS=(SCATTER MATRIX);
   VAR Television Exercise;
   WITH Score;
   TITLE 'Correlations for Test Scores';
   TITLE2 'With Hours of Television and Exercise';
RUN;

DATA hits;
   INPUT Height Distance @@;
   DATALINES;
50 110 49 135 48 129 53 150 48 124 50 143 51 126 45 107
53 146 50 154 47 136 52 144 47 124 50 133 50 128 50 118
48 135 47 129 45 126 48 118 45 121 53 142 46 122 47 119
51 134 49 130 46 132 51 144 50 132 50 131  
;
RUN;
* Perform regression analysis;    
PROC REG DATA = hits;         
   MODEL Distance = Height;  
   TITLE 'Results of Regression Analysis';
RUN;


DATA heights;
   INPUT Region $ Height @@;
   DATALINES;
West 65 West 58 West 63 West 57 West 61 West 53 West 56 West 66
West 55 West 56 West 65 West 54 West 55 West 62 West 55 West 58
East 65 East 55 East 57 East 66 East 59 East 63 East 58 East 57
East 58 East 63 East 61 East 62 East 58 East 57 East 65 East 57
South 63 South 63 South 68 South 56 South 60 South 65 South 64 South 62
South 59 South 67 South 59 South 65 South 66 South 67 South 64 South 68
North 63 North 65 North 58 North 55 North 57 North 66 North 59 North 61
North 65 North 56 North 57 North 63 North 61 North 60 North 64 North 62  
;
RUN;
* Use ANOVA to run one-way analysis of variance;
PROC ANOVA DATA = heights;  
   CLASS Region;            
   MODEL Height = Region;   
   MEANS Region / SCHEFFE;  
   TITLE “Girls'' Heights from Four Regions”;
RUN;