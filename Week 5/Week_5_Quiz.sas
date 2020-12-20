* Problem 1;
proc freq data=sashelp.shoes;
	where region contains "East" and
		product in ('Sandal', 'Slipper');
	tables region*product / crosslist;
	title "foo";
run;


* Question 3;
proc freq data=sashelp.cars;
	options nodate pageno=1;
	tables cylinders;
run;


* Question 5;
proc means data=sashelp.orsales maxdec=0;
	class product_line;
	var total_retail_price / sum mean;
run;