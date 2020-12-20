LIBNAME mydata "~/Mydata/";

PROC CONTENTS DATA=mydata._ALL_;
RUN;

DATA work.auto;
	SET mydata.auto;
RUN;

PROC CONTENTS DATA=work.auto;
RUN;

/* Subset with IF */
DATA work.auto_if;
	SET work.auto;
	Effiency = price/mpg;
	IF mpg > 30;
RUN;

/* Subset with WHERE for finding a character pattern.*/
DATA work.auto_where;
	SET work.auto;
	WHERE make CONTAINS "Buick";
RUN;

/* Conditional on newly created variable in the PDV*/
/*Note: This causes ERROR: Variable effiency is not on file WORK.AUTO. */
DATA work.auto_new_variable;
	SET work.auto;
	effiency = price/mpg;
	WHERE effiency > 500;
	KEEP make effiency;
RUN;

/* Conditional on newly created variable in the PDV*/
DATA work.auto_new_variable;
	SET work.auto;
	effiency = price/mpg;
	IF effiency > 500;
	KEEP make effiency;
RUN;