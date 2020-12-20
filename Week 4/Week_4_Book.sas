data work.sort_test;
	set sashelp.cars;
run;

proc sort;
	by descending MSRP;
run;