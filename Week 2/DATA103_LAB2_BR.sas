/* 1a. Write a code to identify SAS data sets in the Mydata folder*/
LIBNAME mydata "~/Mydata/";

PROC CONTENTS DATA=mydata._ALL_;
RUN;

/* 1b. Write a code to access auto.sas7bdat from Mydata*/
DATA work.auto;
	SET mydata.auto;
RUN;

/*2. What information you get from proc contents?*/
PROC CONTENTS DATA=work.auto;
RUN;

/*3. Write your code using KEEP*/
DATA work.auto2;
	SET work.auto;
	KEEP mpg price make;
RUN;

/*4. Write your code to run proc contents for auto2*/
PROC CONTENTS data=work.auto2;
RUN;

/*6. Write your code using DROP*/
DATA auto3;
	SET work.auto;
	DROP rep78 hdroom trunk weight length turn displ gratio foreign;
RUN;

/*Subsetting observations*/
PROC FREQ DATA=work.auto;
	TABLES rep78 / MISSING;
RUN;

/*7. Write the code to check file auto2 and show the result.*/
DATA work.auto2;
	SET work.auto;

	IF rep78 ^=.;
RUN;

/*proc freq verifies the change*/
PROC FREQ DATA=work.auto2;
	TABLES rep78;
RUN;

/*8. Write the code to keep in the output file
only cars with repair ratings of 3 or less.*/
DATA work.auto4;
	SET work.auto;

	IF rep78 <=3;
RUN;

/*Let’s check the results using proc freq. */
PROC FREQ DATA=work.auto4;
	TABLES rep78 / MISSING;
RUN;

/*9. Write the code to keep in the output file only
cars with repair ratings of 3 or less and deleting missing values*/
DATA work.auto5;
	SET work.auto;

	IF rep78 <=3 AND rep78 ^=.;
RUN;

/*Let’s check the results using proc freq. */
PROC FREQ DATA=work.auto5;
	TABLES rep78 / MISSING;
RUN;