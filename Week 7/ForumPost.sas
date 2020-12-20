/* calculate mean for MPG_Highway */
proc means data=sashelp.cars mean;
	title "Calculate the Mean of MPG_Highway";
	var MPG_Highway;
run;

/* Sort based on MPG */
proc sort data=sashelp.cars out=cars;
	by MPG_Highway;
run;

/* sample a subset of the data*/
proc surveyselect data=cars out=sample outall samprate=0.1 
		seed=12345;
	strata MPG_Highway;
	title "10% sample of data";
run;

/* H0: m =  m0 The population mean is equal to a hypothesized value, m0
   Ha: m != m0 The population mean is not equal to m0 */
proc univariate data=sample MU0=26.8;
	where selected = 1;
	title "One Sample t-Test for a Mean of 26.8";
	var MPG_Highway;
run;