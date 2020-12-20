/* Auto Data set */
DATA auto;
	INPUT make $  mpg rep78 weight foreign;
	CARDS;
AMC     22 3 2930 0
AMC     17 3 3350 0
AMC     22 . 2640 0
Audi    17 5 2830 1
Audi    23 3 2070 1
BMW     25 4 2650 1
Buick   20 3 3250 0
Buick   15 4 4080 0
Buick   18 3 3670 0
Buick   26 . 2230 0
Buick   20 3 3280 0
Buick   16 3 3880 0
Buick   19 3 3400 0
Cad.    14 3 4330 0
Cad.    14 2 3900 0
Cad.    21 3 4290 0
Chev.   29 3 2110 0
Chev.   16 4 3690 0
Chev.   22 3 3180 0
Chev.   22 2 3220 0
Chev.   24 2 2750 0
Chev.   19 3 3430 0
Datsun  23 4 2370 1
Datsun  35 5 2020 1
Datsun  24 4 2280 1
Datsun  21 4 2750 1
;
RUN;

/*  Creating chart  */
/*  1  */
TITLE 'Simple Vertical Bar Chart';

proc gchart data=work.auto;
	vbar mpg / type=freq;
	run;
quit;

/*2  */
TITLE 'Bar Chart - Control Number of Bins';

PROC GCHART DATA=auto;
	VBAR mpg / LEVELS=7;
	RUN;
quit;

/*  3  */
TITLE 'Bar Chart with Discreet Option';

PROC GCHART DATA=auto;
	VBAR rep78 / discrete;
	RUN;
quit;

/* . 4a and 4b  */
TITLE 'Horizontal Bar Chart with Discrete';

PROC GCHART DATA=auto;
	HBAR rep78 / discrete;
	RUN;
quit;

/*  5  */
TITLE 'Pie Chart with Discrete';

PROC GCHART DATA=auto;
	PIE rep78/ DISCRETE VALUE=INSIDE PERCENT=INSIDE SLICE=OUTSIDE;
	RUN;

/*  6 */
TITLE 'Scatterplot - Two Variables';

PROC GPLOT DATA=auto;
	PLOT mpg*weight;
	RUN;
quit;

/*  7  */
TITLE 'Scatterplot - Foreign/Domestic Marked';

PROC GPLOT DATA=auto;
	PLOT mpg*weight=foreign;
	RUN;
quit;

/*  8  */
SYMBOL1 V=circle C=black I=none;
SYMBOL2 V=star C=red I=none;
TITLE 'Scatterplot - Different Symbols';

PROC GPLOT DATA=auto;
	PLOT mpg*weight=foreign;
	RUN;
QUIT;