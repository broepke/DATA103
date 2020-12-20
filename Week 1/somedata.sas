LIBNAME mydata "~/Mydata/";
*Identifying SAS data sets within SAS 
Data Libraries;

DATA myexample;
	SET mydata.somedata;
	*Accessing SAS data sets within SAS Data 
Libraries;
RUN;

PROC PRINT data=myexample;
RUN;

PROC CONTENTS DATA=mydata._ALL_;