data age;
	input Name $ Number;
	datalines;
Sue 35
Joe xx
Steve 22
;

proc print data=age;
run;