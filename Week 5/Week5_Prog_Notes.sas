/* changes SAS system options */
options nodate nonumber ps=30 ls=64;

/* noobs = suppress the obs column*/
/* split = line break char for use with label*/
proc print data=sashelp.shoes noobs split='.';
	/* report variables to display */
	var subsidiary product inventory sales;

	/* subset the data */
	where product='Boot' or product='Sandal';

	/* condition */
	sum inventory sales;

	/* columns to sum */
	by region;

	/* group by */
	pageby region;

	/* print each group on a separate page */
	/* new column labels; Total and Inventory on separate lines*/
	label inventory='Total.Inventory' sales='Total.Sales';

	/* format specifiers */
	format inventory sales dollar14.2;

	/* report title */
	title 'Boot and Sandal Report';

	/* report footnotes */
	footnote 'Created by Tony Smith';
	footnote2 'Chicago, IL';
run;

proc print data=sashelp.shoes (obs=5);
	title1 'Shoe Store';
	title2 'Report One';
	title3 'Accounting';
run;

/** title2 replaces the first title2 in the report **/
proc print data=sashelp.shoes (obs=5);
	title2 'Report Two';
run;

** n-way table **;
proc freq data=sashelp.cars;
   where make ='Honda' and type = 'Hybrid';
   title 'Honda 3-way Table of Model, Horsepower and Engine Size';
   tables model * Horsepower * EngineSize / NOCOL NOROW; ;
run;