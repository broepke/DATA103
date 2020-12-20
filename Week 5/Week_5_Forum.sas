proc format;
	value salef 21000-22000='yellow' 22000<-23000='pink';
run;

title 'Proc Report';

proc report data=sashelp.prdsale nowd;
	column country product region, ('Sales' predict actual);
	define country / group;
	define product / group;
	define region / across;
	define predict / sum 'Predicted' style(column)={background=salef.};
	define actual / sum 'Actual' style(column)={background=salef.};
	rbreak after / summarize;
run;

title 'Proc Tabulate';

proc tabulate data=sashelp.prdsale f=dollar12.2;
	class country region product;
	var predict actual;
	table country * product all, region*Sum*(predict 
		actual)*{s={background=salef.}};
	keylabel Sum='Sales' All='Total';
run;

/* Example TWO */
TITLE1 Detailed Cars Report <=$13, 000;
TITLE2 Arranged by Origin;
TITLE3 Produced by PROC TABULATE;

PROC TABULATE DATA=sashelp.cars FORMAT=DOLLAR8.;
	CLASS origin type make model;
	TABLE origin * type * make * model, MSRP;
	VAR MSRP;
	WHERE MSRP LE 13000;
RUN;

TITLE1 Detailed Cars Report <=$13, 000;
TITLE2 Arranged by Origin;
TITLE3 Produced by PROC REPORT;

PROC REPORT DATA=sashelp.cars NOWINDOWS;
	COLUMNS origin type make model MSRP;
	DEFINE origin / ORDER 'Origin of Car' WIDTH=6;
	DEFINE type / ORDER 'Type of Car' WIDTH=8 CENTER;
	DEFINE make / ORDER 'Make of Car' WIDTH=13;
	DEFINE model / DISPLAY 'Model of Car' WIDTH=40;
	DEFINE MSRP / DISPLAY WIDTH=8 FORMAT=Dollar8.;
	WHERE MSRP LE 13000;
RUN;

TITLE1 MSRP Summary Statistics Report;
TITLE2 Cars <=$18, 000;
TITLE3 Produced by PROC TABULATE;

PROC TABULATE DATA=sashelp.cars;
	CLASS type make;
	TABLE type * make, MSRP * (SUM N MEAN MIN MAX);
	VAR MSRP;
	WHERE MSRP LE 18000;
RUN;

TITLE1 MSRP Summary Statistics Report;
TITLE2 Cars <=$18, 000;
TITLE3 Produced by PROC REPORT;

PROC REPORT DATA=sashelp.cars NOWINDOWS;
	COLUMNS type make MSRP MSRP=MSRP_Sum MSRP=MSRP_N MSRP=MSRP_Mean MSRP=MSRP_Min 
		MSRP=MSRP_Max;
	DEFINE type / GROUP 'Type of Car' WIDTH=8;
	DEFINE make / GROUP 'Make of Car' WIDTH=13;
	DEFINE MSRP / ANALYSIS NOPRINT FORMAT=Dollar12.;
	DEFINE MSRP_SUM / ANALYSIS SUM FORMAT=Dollar12.;
	DEFINE MSRP_N / ANALYSIS N "N" FORMAT=COMMA7.;
	DEFINE MSRP_MEAN / ANALYSIS MEAN "Mean";
	DEFINE MSRP_MIN / ANALYSIS MIN "Min";
	DEFINE MSRP_MAX / ANALYSIS MAX "Max";
	WHERE MSRP LE 18000;
RUN;